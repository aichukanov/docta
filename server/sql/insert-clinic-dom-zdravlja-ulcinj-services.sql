-- ═══════════════════════════════════════════════════════════════════════════
-- Dom zdravlja Ulcinj — услуги, анализы и цены
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dom-zdravlja-ulcinj-services.sql
--
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-dom-zdravlja-ulcinj.sql И миграция
-- server/sql/migrations/054-fzocg-pzz-linkage-and-names.sql — применять ПОСЛЕ неё: 054 заводит записи
-- A01010 / H02010 (REVISK) / H04011 и переименовывает fixation («Frikcije»), home-visit-brief-doctor-visit-up-to-5-km
-- (A02008), cervical-drug-application (X01024) и др. До 054 страховка «unmatched_service» покажет 3 slug.
-- Клиника — по google_place_id/slug, услуги и анализы — по slug, литеральных id нет.
-- Новых записей каталога в этом файле НЕТ (правило подволны 2b для домов здоровья; недостающие завела 054).
--
-- Источник цен: «Cijenovnik PZZ za treća lica» — PDF на сайте ДЗ, посты «Cijenovnik usluga prema
-- trećim licima u PZZ» от 2019-03-04 и 2019-04-12 (один и тот же файл: /wp-content/uploads/2019/03/
-- и /2019/04/Cijenovnik-PZZ-za-treca-lica.pdf, 278 486 байт, sha256 51f190f7…3c2). PDF напечатан из
-- «CJENOVNIK PZZ.xlsx» 2019-03-04 (creationDate), текстовый слой есть, 23 стр. Колонки: «Šifra usluge»
-- (коды ФЗОЦГ), «Spisak usluga», «Cijena» — цена для третьих лиц (над таблицами стоят множители
-- 3.00 / 2.50 к тарифу ФЗОЦГ; взята итоговая колонка «Cijena»). 349 строк, 329 разных кодов.
-- Снимок: data/clinic-pricelists/sources/dom-zdravlja-ulcinj/2026-10-08.cijenovnik-pzz-treca-lica.pdf.
-- Сопоставление — ПО НАЗВАНИЮ строки, а не по привязке medical_service_tariffs: у части кодов
-- (A01010, A02008, H04010/H04011, H02010–H02013, C01002) привязка тарифа к каталогу была ошибочна —
-- исправлена миграцией 054, теперь привязка и сопоставление здесь совпадают.
-- Где у одной записи каталога две равноценные копии (наследие импортов ДЗ и больниц), взята та,
-- к которой привязан тариф ФЗОЦГ, если её название совпадает со строкой прайса.
--
-- Один код в нескольких разделах прайса (общая практика / гинекология / ТБЦ / патронаж) стоит
-- по-разному → price = минимум, price_max = максимум. J06002 («за svaki snimak» — любой отдел
-- позвоночника) и J06003 (любой отдел конечностей и таз) разложены на записи каталога по схеме
-- ДЗ Даниловград, с одной ценой и одним кодом.
-- Бывшие спорные (6) после 054 сопоставлены: A01010, A02008, X01020 (fixation = «Frikcije»), H02010, H04011 — услуги;
-- K01064 «Mikroskopsko citološki pregled (stepen)» — анализ direct-microscopic-preparation, как у ДЗ Херцег-Нови
-- и больниц Данило/Никшич/КЦЦГ с тем же кодом (другой записи в каталоге нет).
--
-- Без цены (15) — только то, что сайт называет конкретно: 10 справок со страницы /medicina-rada/
-- (по схеме ДЗ Бар), санитарные осмотры («izdavanja sanitarnih knjižica», /centar-za-dijagnostiku/),
-- осмотры интерниста и офтальмолога (RASPORED RADA SPECIJALISTA). Тарифы ФЗОЦГ из
-- medical_service_tariffs ценами клиники не ставятся — цены только из прайса самого ДЗ.
-- is_price_outdated не ставится (решение юзера 2026-10-08), дата прайса — в записи импорта.
--
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, цены пишутся ON DUPLICATE KEY
-- UPDATE, лишнее от прошлых прогонов удаляется. ⚠️ Услуги, добавленные клинике вручную
-- (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJkVrkFGQTThMRiBnsu9NYcLM' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'dom-zdravlja-ulcinj' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-dom-zdravlja-ulcinj.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: УСЛУГИ — КАНОНИЧЕСКИЙ СПИСОК
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_dzulcinj_services;
CREATE TEMPORARY TABLE tmp_dzulcinj_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL,
	code VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_dzulcinj_services (slug, price, price_max, code) VALUES
-- ── Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle) ──
('preventive-examination-up-to-age-1', 39.41, NULL, 'UL_A01001'), -- A01001 Preventivni pregledi djece u 1. godini života — 39.41 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('preventive-examination-at-age-2', 39.41, NULL, 'UL_A01002'), -- A01002 Preventivni pregled djece u 2. godini života — 39.41 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('preventive-examination-at-age-4', 39.41, NULL, 'UL_A01003'), -- A01003 Preventivni pregled djece u 4. godini života — 39.41 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('preventive-examination-before-primary-school', 47.29, NULL, 'UL_A01004'), -- A01004 Preventivni pregled pred polazak u osnovnu školu — 47.29 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('primary-school-preventive-examination', 36.25, NULL, 'UL_A01005'), -- A01005 Preventivni pregledi u osnovnoj školi ( 2, 4, 6 i posljednji razred osnovne škole) — 36.25 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('secondary-school-preventive-systematic-examination', 36.25, NULL, 'UL_A01006'), -- A01006 Preventivni (sistematski) pregled učenika u prvom i trećem razredu srednje škole — 36.25 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('student-systematic-preventive-examination', 36.25, NULL, 'UL_A01007'), -- A01007 Preventivni (sistematski) pregled studenata na prvoj i trećoj godini studija — 36.25 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('systematic-preventive-examination-for-patients-over-65', 36.25, NULL, 'UL_A01008'), -- A01008 Preventivni (sistematski) pregled lica starijih od 65 godina. — 36.25 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('follow-up-examination-after-preventive-examination', 23.64, NULL, 'UL_A01009'), -- A01009 Kontrolni pregled nakon preventivnog pregleda — 23.64 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('preventive-examination-of-children-under-15-during-epidemic', 36.25, NULL, 'UL_A01010'), -- A01010 Preventivni pregled djece do 15 godina u slučaju epidemije neke od zaraznih bolesti. — 36.25 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('pediatric-vaccination-and-revaccination-by-schedule', 11.03, NULL, 'UL_A01011'), -- A01011 Vakcinacija i revakcinacija djece i omladine po kalendaru vakcinacija — 11.03 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('influenza-vaccination-for-patients-over-65', 11.03, NULL, 'UL_A01012'), -- A01012 Vakcinacija starijih od 65 godina protiv gripe — 11.03 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('immunoprophylaxis-and-chemoprophylaxis-for-infectious-disease-prevention', 11.03, NULL, 'UL_A01013'), -- A01013 Imunoprofilaksa, imunoprofilaksa sa serumom i hemioprofilaksa za spriječavanje zaraznih bolesti u skladu sa zakonom — 11.03 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('cardiovascular-risk-preventive-examination-adults-over-40', 23.64, NULL, 'UL_A01014'), -- A01014 Preventivni pregled muškaraca nakon 40 godine života, i žena nakon 45.godine života zbog ranog otkrivanje povišenog krvnog pritiska, holesterola i triglicerida i riziko faktora za pojavu bolesti srca i krvnih sudova i to svakih 5 godina jedanput. — 23.64 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('breast-cancer-early-detection-examination', 23.64, NULL, 'UL_A01015'), -- A01015 Pregledi za rano otkrivanje raka dojke kod žena i to jedanput na 3 godine. Kod žena u rizičnoj grupi (sa rakom dojke kod majke, sestre, kćerke) pregledi se obavljaju svake godine — 23.64 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('first-curative-examination', 23.64, NULL, 'UL_A02001'), -- A02001 Prvi kurativni pregled — 23.64 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('follow-up-curative-examination', 15.76, NULL, 'UL_A02002'), -- A02002 Ponovni kurativni pregled (kontrolni) — 15.76 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('pre-operative-outpatient-examination-general-anesthesia', 39.41, NULL, 'UL_A02003'), -- A02003 Pregled pacijenata koji se ambulantno spremaju za operaciju u opštoj anasteziji. — 39.41 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('brief-doctor-visit-without-examination', 15.76, NULL, 'UL_A02004'), -- A02004 Kratka posjeta doktoru (posjeta bez pregleda doktora) — 15.76 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('home-visit-first-curative-examination-up-to-5-km', 55.17, NULL, 'UL_A02005'), -- A02005 Prvi kurativni pregled u kući osiguranika na udaljenosti do 5 km od ambulante izabranog doktora — 55.17 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('home-visit-first-curative-examination-5-to-15-km', 70.93, NULL, 'UL_A02006'), -- A02006 Prvi kurativni pregled u kući osiguranika na udaljenosti od 5-15 km od ambulante izabranog doktora, ili teško dostupnim krajevima — 70.93 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('home-visit-first-curative-examination-over-15-km', 86.69, NULL, 'UL_A02007'), -- A02007 Prvi kurativni pregled u kući osiguranika na udaljenosti više od 15 km od ambulante izabranog doktora, ili teško dostupnim krajevima — 86.69 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('home-visit-brief-doctor-visit-up-to-5-km', 47.29, NULL, 'UL_A02008'), -- A02008 Ponovni kurativni pregled (kontrolni) u kući osiguranika na udaljenosti do 5 km od ambulante izabranog doktora — 47.29 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('home-visit-follow-up-curative-examination-5-to-15-km', 63.05, NULL, 'UL_A02009'), -- A02009 Ponovni kurativni pregled (kontrolni) u kući osiguranika na udaljenosti od 5-15 km od ambulante izabranog doktora, ili teško dostupnim krajevima — 63.05 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('home-visit-follow-up-curative-examination-over-15-km', 78.81, NULL, 'UL_A02010'), -- A02010 Ponovni kurativni pregled (kontrolni) u kući osiguranika na udaljenosti više od 15 km od ambulante izabranog doktora, ili teško dostupnim krajevima — 78.81 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('doctor-visit-for-ipk-workup', 34.51, NULL, 'UL_A02011'), -- A02011 Posjeta doktoru radi obrade za IPK — 34.51 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('foreign-body-removal-from-ear', 15.76, NULL, 'UL_X01001'), -- X01001 odstranjivanje stranog tijela iz uha — 15.76 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('foreign-body-removal-from-throat', 15.76, NULL, 'UL_X01002'), -- X01002 odstranjivanje stranog tijela iz grla — 15.76 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('foreign-body-removal-from-skin-and-subcutaneous-tissue', 7.88, NULL, 'UL_X01003'), -- X01003 odstranjivanje stranog tijela iz kože — 7.88 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('local-anesthesia-administration', 6.57, 7.88, 'UL_X01004'), -- X01004 davanje lokalne anastezije — 7.88 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle)) | X01004 davanje lokalne anastezije — 6.57 (Usluge izabranog ginekologa)
('cerumen-ear-irrigation', 7.88, NULL, 'UL_X01005'), -- X01005 ispiranje cerumena iz uha — 7.88 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('oxygen-administration', 4.32, 6.57, 'UL_X01006'), -- X01006 davanje kiseonika — 5.11 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle)) | X01006 davanje kiseonika — 6.57 (Usluge izabranog ginekologa) | X01006 davanje kiseonika — 4.32 (Centar za plućne bolesti i TBC)
('swab-collection-for-laboratory-analysis', 6.57, 7.88, 'UL_X01007'), -- X01007 uzimanje briseva sa slanjem na analizu — 7.88 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle)) | X01007 uzimanje briseva sa slanjem na analizu — 6.57 (Usluge izabranog ginekologa) | X01007 uzimanje briseva sa slanjem na analizu — 6.66 (Centar za plućne bolesti i TBC)
('inhalation-therapy', 4.32, 5.11, 'UL_X01010'), -- X01010 davanje inhalacije — 5.11 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle)) | X01010 davanje inhalacije — 4.32 (Centar za plućne bolesti i TBC)
('anterior-hematoma-puncture', 7.88, NULL, 'UL_X01011'), -- X01011 punkcija potkožnih hematoma — 7.88 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('gastrostomy-site-care', 5.11, NULL, 'UL_X01012'), -- X01012 toaleta gastrostome — 5.11 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('artificial-anus-care', 5.11, NULL, 'UL_X01013'), -- X01013 toaleta vještačkog anusa — 5.11 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('primary-wound-care-without-sutures', 6.57, 7.88, 'UL_X01014'), -- X01014 zbrinjavanje rane bez šivanja — 7.88 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle)) | X01014 zbrinjavanje rane bez šivanja — 6.57 (Usluge izabranog ginekologa)
('suture-removal', 5.11, 6.57, 'UL_X01015'), -- X01015 skidanje hirurških konaca — 5.11 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle)) | X01015 skidanje hirurških konaca — 6.57 (Usluge izabranog ginekologa)
('fixation-bandage', 5.11, NULL, 'UL_X01018'), -- X01018 fiksacioni zavoj — 5.11 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('immobilization', 7.88, NULL, 'UL_X01019'), -- X01019 imobilizacija — 7.88 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('fixation', 5.11, 6.57, 'UL_X01020'), -- X01020 frikcije — 5.11 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle)) | X01020 frikcije — 6.57 (Usluge izabranog ginekologa); запись fixation переименована в «Frikcije» миграцией 054
('subcutaneous-or-intramuscular-injection', 2.16, 6.57, 'UL_X01021'), -- X01021 lokalno apliciranje lijeka (subkutano i intramuskularno) — 2.56 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle)) | X01021 lokalno apliciranje lijeka (subkutano i intramuskularno) — 6.57 (Usluge izabranog ginekologa) | X01021 lokalno apliciranje lijeka (subkutano i intramuskularno) — 2.16 (Centar za plućne bolesti i TBC)
('burn-wound-care', 15.76, NULL, 'UL_X02002'), -- X02002 obrada opekotina — 15.76 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('abscess-incision', 6.57, 15.76, 'UL_X02003'), -- X02003 incizija abscesa — 15.76 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle)) | X02003 incizija abscesa — 6.57 (Usluge izabranog ginekologa)
('eye-foreign-body-removal-cornea', 15.76, NULL, 'UL_X02004'), -- X02004 odstranjivanje stranog tijela iz oka (rožnjače) — 15.76 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('anterior-nasal-packing', 15.76, NULL, 'UL_X02005'), -- X02005 prednja tamponada nosa — 15.76 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('urinary-catheter-placement', 6.57, 15.76, 'UL_X02006'), -- X02006 kateterizacija mokraćne bešike sa ili bez ispiranja, — 15.76 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle)) | X02006 kateterizacija mokraćne bešike sa ili bez ispiranja, — 6.57 (Usluge izabranog ginekologa)
('enema', 6.57, 7.67, 'UL_X02007'), -- X02007 davanje klizme — 7.67 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle)) | X02007 davanje klizme — 6.57 (Usluge izabranog ginekologa)
('indwelling-catheter-placement', 15.76, NULL, 'UL_X02008'), -- X02008 namještanje trajnog katetera, — 15.76 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('intravenous-cannula-placement', 5.11, 6.57, 'UL_X02009'), -- X02009 postavljanje kanile u venu ili uključivanje infuzije — 5.11 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle)) | X02009 postavljanje kanile u venu ili uključivanje infuzije — 6.57 (Usluge izabranog ginekologa)
('ecg', 6.57, 10.44, 'UL_X02010'), -- X02010 snimanje i očitavanje EKG — 10.44 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle)) | X02010 snimanje i očitavanje EKG — 6.57 (Usluge izabranog ginekologa)
('spirometry', 8.82, 10.44, 'UL_X02011'), -- X02011 snimanje i čitanje spirometrije — 10.44 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle)) | X02011 snimanje i čitanje spirometrije — 8.82 (Centar za plućne bolesti i TBC)
('paraphimosis-reduction', 15.76, NULL, 'UL_X02019'), -- X02019 repozicija parafimoze — 15.76 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('incarcerated-hernia-reduction', 15.76, NULL, 'UL_X02020'), -- X02020 repozicija uklještene kile — 15.76 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('atheroma-cyst-xanthoma-or-small-benign-tumor-excision', 6.57, 15.76, 'UL_X02021'), -- X02021 ekstirpac. ateroma, ciste ili manjeg benin. tumora — 15.76 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle)) | X02021 ekstirpac. ateroma, ciste ili manjeg benin. tumora — 6.57 (Usluge izabranog ginekologa)
('wound-suturing-under-local-anesthesia', 6.57, 23.64, 'UL_X03001'), -- X03001 obrada rane sa šivanjem uz lokalnu anesteziju — 23.64 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle)) | X03001 obrada rane sa šivanjem uz lokalnu anesteziju — 6.57 (Usluge izabranog ginekologa)
('external-cardiac-defibrillation', 15.76, NULL, 'UL_X03002'), -- X03002 defibrilacija — 15.76 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('endotracheal-intubation', 37.06, NULL, 'UL_X03003'), -- X03003 intubacija — 37.06 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
('gastric-lavage', 23.64, NULL, 'UL_X03004'), -- X03004 ispiranje želuca — 23.64 (Usluge izabranog doktora (za djecu do 15 g. – pedijatar i za odrasle))
-- ── Usluge izabranog ginekologa ──
('pregnancy-preventive-examination-first-trimester', 32.84, NULL, 'UL_C01001'), -- C01001 Preventivni pregled u toku trudnoće (pregled trudnice u I trimestru trudnoće i četiri kontrolna pregleda trudnoće) — 32.84 (Usluge izabranog ginekologa)
('pregnancy-ultrasound', 26.27, NULL, 'UL_C01003'), -- C01003 Ultrazvučni pregled u toku trudnoće (prvi do 16. nedjelje trudnoće, drugi do 26. nedjelje trudnoće i treći do 34. ili 35. nedjelje trudnoće), a kod rizičnih trudnoća prema indikacijama — 26.27 (Usluge izabranog ginekologa)
('postpartum-examination-at-6-weeks', 19.70, NULL, 'UL_C01004'), -- C01004 Pregled i savjetovanje 6 nedjelja nakon porođaja — 19.70 (Usluge izabranog ginekologa)
('post-abortion-examination-and-counseling', 19.70, NULL, 'UL_C01005'), -- C01005 Pregled i savjetovanje 3 nedjelje nakon spontanog ili dozvoljenog abortusa. — 19.70 (Usluge izabranog ginekologa)
('post-ectopic-pregnancy-examination-and-counseling', 19.70, NULL, 'UL_C01006'), -- C01006 Pregled i savjetovanje 3 nedjelje nakon ekstrauterinog graviditeta. Pregled je kombinovan sa PAP testom, potrebnim laboratorijskim pretragama, savjetovanjem i određivanjem metode kontracepcije — 19.70 (Usluge izabranog ginekologa)
('reproductive-age-women-preventive-examination-with-pap-test', 26.27, NULL, 'UL_C01007'), -- C01007 Preventivni pregled sa savjetovanjem žena u reproduktivnom dobu, pregled za otkrivanje raka na reproduktivnim organima žena i to na 3 godine jedanput u životnoj dobi od 20. do 75. godine starosti (osim ako izabrani ginekolog ne utvrdi drugačiju dinamiku) — 26.27 (Usluge izabranog ginekologa)
('first-specialist-curative-gynecological-examination', 19.70, NULL, 'UL_C02001'), -- C02001 Prvi kurativni pregled žena (specijalistički) — 19.70 (Usluge izabranog ginekologa)
('follow-up-specialist-curative-gynecological-examination', 13.14, NULL, 'UL_C02002'), -- C02002 Ponovni kurativni pregled žena (kontrolni specijalistički) — 13.14 (Usluge izabranog ginekologa)
('brief-gynecologist-visit-without-examination', 6.57, NULL, 'UL_C02003'), -- C02003 Kratka posjeta doktoru bez ponovnog pregleda. — 6.57 (Usluge izabranog ginekologa)
('mechanical-contraceptive-device-check', 6.57, NULL, 'UL_X01017'), -- X01017 kontrola mehaničkog kontraceptivnog sredstva — 6.57 (Usluge izabranog ginekologa)
('cervical-drug-application', 6.57, NULL, 'UL_X01024'), -- X01024 lokalno apliciranje lijeka (vaginalno i cervikalno) — 6.57 (Usluge izabranog ginekologa)
('iud-insertion', 6.57, NULL, 'UL_X01025'), -- X01025 stavljanje IUD — 6.57 (Usluge izabranog ginekologa)
('iud-removal', 6.57, NULL, 'UL_X01026'), -- X01026 skidanje IUD — 6.57 (Usluge izabranog ginekologa)
('colposcopy', 6.57, NULL, 'UL_X02016'), -- X02016 kolposkopski pregled — 6.57 (Usluge izabranog ginekologa)
('bartholin-gland-and-vulva-incision-and-drainage', 6.57, NULL, 'UL_X02017'), -- X02017 incizija i drenaža Bartolinijeve žlijezde i vulve — 6.57 (Usluge izabranog ginekologa)
('vulvar-and-vaginal-condyloma-abrasion', 6.57, NULL, 'UL_X02018'), -- X02018 abrazija kondiloma vulve i vagine — 6.57 (Usluge izabranog ginekologa)
('vulva-biopsy-with-lab-analysis', 6.57, NULL, 'UL_X03005'), -- X03005 uzimanje biopsije labije i vulve sa slanjem uzoraka na analizu — 6.57 (Usluge izabranog ginekologa)
('cervical-biopsy-with-lab-analysis', 6.57, NULL, 'UL_X03006'), -- X03006 uzimanje biopsije vagine i cerviksa sa slanjem uzoraka na analizu — 6.57 (Usluge izabranog ginekologa)
('endometrial-biopsy-with-lab-analysis', 6.57, NULL, 'UL_X03007'), -- X03007 uzimanje biopsije endometrijuma sa slanjem uzoraka na analizu — 6.57 (Usluge izabranog ginekologa)
('cervical-or-uterine-polypectomy', 6.57, NULL, 'UL_X03008'), -- X03008 polipektomija (grlića materice, cavum uteri) — 6.57 (Usluge izabranog ginekologa)
('amnioscopy', 6.57, NULL, 'UL_X03009'), -- X03009 amnioskopija — 6.57 (Usluge izabranog ginekologa)
('gynecological-ultrasound', 6.57, NULL, 'UL_X03010'), -- X03010 ultrazvučni pregled žene — 6.57 (Usluge izabranog ginekologa)
('pregnancy-cardiotocography-ctg', 6.57, NULL, 'UL_X03013'), -- X03013 CTG - kardiotokografija — 6.57 (Usluge izabranog ginekologa)
-- ── Centar za plućne bolesti i TBC ──
('tuberculin-skin-test', 7.02, NULL, 'UL_G01001'), -- G01001 Tuberkulinsko testiranje. — 7.02 (Centar za plućne bolesti i TBC)
('adult-examination-for-registered-tb', 28.08, NULL, 'UL_G01002'), -- G01002 Pregled osoba sa registrovanom TBC — 28.08 (Centar za plućne bolesti i TBC)
('tb-contact-tracing-examination', 28.08, NULL, 'UL_G01003'), -- G01003 Pregled osoba iz kontakta — 28.08 (Centar za plućne bolesti i TBC)
('patient-examination-with-chemoprophylaxis', 28.08, NULL, 'UL_G01004'), -- G01004 Pregled i praćenje lica pod hemioprofilaksom. — 28.08 (Centar za plućne bolesti i TBC)
('first-pulmonologist-curative-examination', 28.08, NULL, 'UL_G02001'), -- G02001 Prvi kurativni pregled (specijalistički) — 28.08 (Centar za plućne bolesti i TBC)
('follow-up-pulmonologist-curative-examination', 21.06, NULL, 'UL_G02002'), -- G02002 Ponovni kurativni pregled (kontrolni specijalistički). — 21.06 (Centar za plućne bolesti i TBC)
('sputum-collection-for-bacterial-and-fungal-analysis', 2.16, NULL, 'UL_X01008'), -- X01008 uzimanje sputuma za analizu na bakterije i gljivice — 2.16 (Centar za plućne bolesti i TBC)
('directly-observed-treatment-for-tb-dots', 2.16, 2.20, 'UL_X01022'), -- X01022 direktno opservirana terapija za TBC (DOTs) — 2.16 (Centar za plućne bolesti i TBC) | X01022 direktno opservirana terapija za TBC (DOTs) — 2.20 (Jedinica za patronažu)
('prick-test-inhalation-allergens', 22.32, NULL, 'UL_X02001'), -- X02001 ispitivanje kožne preosetljivosti na inhalacione alergene (alergološko prick - testiranje) — 22.32 (Centar za plućne bolesti i TBC)
('bronchodilator-test', 8.82, NULL, 'UL_X02012'), -- X02012 bronhodilatacijski testovi — 8.82 (Centar za plućne bolesti i TBC)
('pleural-puncture', 26.64, NULL, 'UL_X02013'), -- X02013 dijagnostička punkcija pleure — 26.64 (Centar za plućne bolesti i TBC)
('thoracentesis', 26.64, NULL, 'UL_X02014'), -- X02014 terapijska punkcija pleure — 26.64 (Centar za plućne bolesti i TBC)
('evacuation-pleural-puncture', 26.64, NULL, 'UL_X02015'), -- X02015 evakuaciona punkcija pleure — 26.64 (Centar za plućne bolesti i TBC)
('sputum-collection-for-cytology', 2.16, NULL, 'UL_X03011'), -- X03011 uzimanje sputuma za citološku analizu — 2.16 (Centar za plućne bolesti i TBC)
-- ── Centar za mentalno zdravlje ──
('first-psychiatrist-examination', 50.02, NULL, 'UL_H01001'), -- H01001 Prvi pregled (specijalistički) — 50.02 (Centar za mentalno zdravlje)
('follow-up-psychiatrist-examination', 33.35, NULL, 'UL_H01002'), -- H01002 Ponovni pregled (kontrolni specijalistički) — 33.35 (Centar za mentalno zdravlje)
('brief-psychiatrist-visit-without-examination', 16.67, NULL, 'UL_H01003'), -- H01003 Kratka posjeta doktoru bez ponovnog pregleda — 16.67 (Centar za mentalno zdravlje)
('individual-supportive-psychotherapy-and-counseling', 33.35, NULL, 'UL_H01004'), -- H01004 Površna individualna terapija (savjeti pacijentu) — 33.35 (Centar za mentalno zdravlje)
('additional-individual-therapy', 50.02, NULL, 'UL_H01005'), -- H01005 Dubinska individualna terapija (savjetodavna terapija) — 50.02 (Centar za mentalno zdravlje)
('group-psychodynamic-and-sociodynamic-therapy', 133.38, NULL, 'UL_H01006'), -- H01006 Grupna psihoterapija psihodinamskih i sociodinamskih kinflikata (grupa sa najmanje 6 osoba) — 133.38 (Centar za mentalno zdravlje)
('group-psychotherapy-session-for-addictions', 133.38, NULL, 'UL_H01007'), -- H01007 Grupna psihoterapija kod lica sa bolestima zavisnosti (grupa sa najmanje 6 osoba) — 133.38 (Centar za mentalno zdravlje)
('family-psychotherapy-session', 100.04, NULL, 'UL_H01008'), -- H01008 Porodična psihoterapija (terapija bračnih i drugih parova) — 100.04 (Centar za mentalno zdravlje)
('analytically-oriented-depth-psychotherapy-session', 66.69, NULL, 'UL_H01009'), -- H01009 Analitički usmjerena terapija — 66.69 (Centar za mentalno zdravlje)
('behavioral-psychotherapy', 66.69, NULL, 'UL_H01010'), -- H01010 Psihoterpija ponašanja — 66.69 (Centar za mentalno zdravlje)
('relaxation-technique', 55.58, NULL, 'UL_H01011'), -- H01011 Tehnika relaksacije — 55.58 (Centar za mentalno zdravlje)
('brief-psychodiagnostic-interview', 16.67, NULL, 'UL_H01012'), -- H01012 Kraći psihodijagnostički intervju — 16.67 (Centar za mentalno zdravlje)
('pediatric-psychomotor-development-assessment', 100.04, NULL, 'UL_H01013'), -- H01013 Procjena psihomotornog razvoja djeteteta — 100.04 (Centar za mentalno zdravlje)
('brief-pediatric-intellectual-status-test-under-15', 50.02, NULL, 'UL_H01014'), -- H01014 Kratki klinički test procjene intelektualnog statusa za djece do 15 godina — 50.02 (Centar za mentalno zdravlje)
('brief-adult-intellectual-status-test', 33.35, NULL, 'UL_H01015'), -- H01015 Kratki klinički test procjene intelektualnog statusa za odrasle — 33.35 (Centar za mentalno zdravlje)
('pediatric-personality-structure-assessment-under-15', 88.92, NULL, 'UL_H01016'), -- H01016 Procjena strukture ličnosti (eksploracija) djece do 15 godina — 88.92 (Centar za mentalno zdravlje)
('personality-structure-assessment-for-adults', 55.58, NULL, 'UL_H01017'), -- H01017 Procjena strukture ličnosti (eksploracija) za odrasle — 55.58 (Centar za mentalno zdravlje)
('pediatric-individual-function-clinical-testing-under-15', 27.79, NULL, 'UL_H01018'), -- H01018 Kliničko ispitivanje pojedinačnih funkcija djece do 15 godina. — 27.79 (Centar za mentalno zdravlje)
('adult-individual-function-clinical-testing', 15.56, NULL, 'UL_H01019'), -- H01019 Kliničko ispitivanje pojedinačnih funkcija za odrasle. — 15.56 (Centar za mentalno zdravlje)
('results-processing-integration-and-report-writing', 133.38, NULL, 'UL_H01020'), -- H01020 Obrada rezultata, integracija rezultata, pisanje nalaza — 133.38 (Centar za mentalno zdravlje)
('heteroanamnesis', 16.67, NULL, 'UL_H01021'), -- H01021 Heteroanamneza — 16.67 (Centar za mentalno zdravlje)
('family-counseling', 16.67, NULL, 'UL_H01022'), -- H01022 Savjet roditeljima i članovima porodice — 16.67 (Centar za mentalno zdravlje)
('multidisciplinary-team-patient-consultation', 33.35, NULL, 'UL_H01023'), -- H01023 Konsultacija stručnog tima o pacijentu — 33.35 (Centar za mentalno zdravlje)
('psychologist-interview', 27.36, NULL, 'UL_H02001'), -- H02001 Anamneza, dijagnostički intervju — 27.36 (Centar za mentalno zdravlje)
('psychological-testing-category-a', 27.36, NULL, 'UL_H02002'), -- H02002 Prikupljanje podataka sa psihološkim testovima i metodama kategorije A(testovi:P, TRL, BTI, DAT, TMO, SPP3) — 27.36 (Centar za mentalno zdravlje)
('psychological-testing-category-b', 45.60, NULL, 'UL_H02003'), -- H02003 Prikupljanje podataka sa psihološkim testovima i metodama kategorije B (testovi: D-48, LB, PM, AV, DAT, EOV) — 45.60 (Centar za mentalno zdravlje)
('psychological-testing-category-c', 72.96, NULL, 'UL_H02004'), -- H02004 Prikupljanje podataka sa psihološkim testovima i metodama kategorije C (testovi: WB, WISC, OI, FPI, APQ, PIE) — 72.96 (Centar za mentalno zdravlje)
('psychological-testing-category-d', 109.44, NULL, 'UL_H02005'), -- H02005 Prikupljanje podataka sa psihološkim testovima i metodama kategorije D (Rošahov dijagnostički test, PPM, usmjereni dijagnostički intrevju, neuropsihološka anliza) — 109.44 (Centar za mentalno zdravlje)
('organicity-assessment', 109.44, NULL, 'UL_H02006'), -- H02006 Procjena organiciteta — 109.44 (Centar za mentalno zdravlje)
('special-needs-child-diagnostic-interview', 54.72, NULL, 'UL_H02007'), -- H02007 Prvi intervju-Dijagnostički intervju djeteta sa posebnim potrebama — 54.72 (Centar za mentalno zdravlje)
('goodenough-intelligence-test-for-special-needs-children-under-14', 19.95, NULL, 'UL_H02008'), -- H02008 Procjena intelektualnih sposobnosti djeteta sa posebnim potrebama do 14 g.-Gudinaf-ov test — 19.95 (Centar za mentalno zdravlje)
('binet-simon-intelligence-test-for-special-needs-children-under-14', 25.37, NULL, 'UL_H02009'), -- H02009 Procjena intelektualnih sposobnosti djeteta sa posebnim potrebama do 14 g.-Bine-Simonova skala — 25.37 (Centar za mentalno zdravlje)
('revisk-intelligence-test-for-special-needs-children-under-14', 22.66, NULL, 'UL_H02010'), -- H02010 Procjena intelektualnih sposobnosti djeteta sa posebnim potrebama do 14 godina-Revisk — 22.66 (Centar za mentalno zdravlje)
('progressive-matrices-test-for-special-needs-children-under-14', 30.78, NULL, 'UL_H02011'), -- H02011 Procjena intelektualnih sposobnosti djeteta sa posebnim potrebama do 14 g.-Progresivne matrice — 30.78 (Centar za mentalno zdravlje)
('viti-test-for-special-needs-children-under-14', 25.37, NULL, 'UL_H02012'), -- H02012 Procjena intelektualnih sposobnosti djeteta sa posebnim potrebama preko14 godina-Viti test — 25.37 (Centar za mentalno zdravlje)
('wechsler-bellevue-test-for-special-needs-children-over-14', 25.37, NULL, 'UL_H02013'), -- H02013 Procjena intelektualnih sposobnosti djeteta sa posebnim potrebama preko14 godina-W-B skala — 25.37 (Centar za mentalno zdravlje)
('special-needs-child-psychomotor-development-assessment', 22.66, NULL, 'UL_H02014'), -- H02014 Procjena psihomotornog razvoja djeteta sa posebnim potrebama — 22.66 (Centar za mentalno zdravlje)
('special-needs-child-social-maturity-assessment', 19.95, NULL, 'UL_H02015'), -- H02015 Procjena socijalne zrelosti djeteta sa posebnim potrebama — 19.95 (Centar za mentalno zdravlje)
('multidisciplinary-developmental-disorder-patient-workup', 28.07, NULL, 'UL_H02016'), -- H02016 Timska obrada pacijenta sa smetnjama u razvoju — 28.07 (Centar za mentalno zdravlje)
('play-diagnostic-assessment', 19.95, NULL, 'UL_H02017'), -- H02017 Dijagnostika igrom — 19.95 (Centar za mentalno zdravlje)
('special-needs-child-personality-tests-underdeveloped', 25.37, NULL, 'UL_H02018'), -- H02018 Testovi ličnosti djeteta sa posebnim potrebama- Testovi nedovršenih rečenica — 25.37 (Centar za mentalno zdravlje)
('special-needs-child-family-drawing-test', 19.95, NULL, 'UL_H02019'), -- H02019 Testovi ličnosti djeteta sa posebnim potrebama-Crtež porodice — 19.95 (Centar za mentalno zdravlje)
('special-needs-child-ego-perception-test', 25.37, NULL, 'UL_H02020'), -- H02020 Testovi ličnosti djeteta sa posebnim potrebama - Test ego percepcije — 25.37 (Centar za mentalno zdravlje)
('parental-counseling-work', 28.07, NULL, 'UL_H02021'), -- H02021 Savjetodavan rad sa roditeljem — 28.07 (Centar za mentalno zdravlje)
('school-or-kindergarten-pedagogue-counseling', 14.54, NULL, 'UL_H02022'), -- H02022 Savjet pedagogu škole ili vrtića — 14.54 (Centar za mentalno zdravlje)
('data-processing', 19.95, NULL, 'UL_H02023'), -- H02023 Obrada podataka — 19.95 (Centar za mentalno zdravlje)
('results-integration-and-report-writing', 109.44, NULL, 'UL_H02024'), -- H02024 Obrada rezultata, integracija rezultata, pisanje nalaza — 109.44 (Centar za mentalno zdravlje)
('individual-supportive-therapy', 28.07, NULL, 'UL_H02025'), -- H02025 Individualna površna terapija — 28.07 (Centar za mentalno zdravlje)
('social-worker-expert-assessment', 16.25, NULL, 'UL_H04001'), -- H04001 Socijalni radnik, nalaz i mišljenje — 16.25 (Centar za mentalno zdravlje)
('social-worker-interview-social-history', 16.25, NULL, 'UL_H04002'), -- H04002 Socijalni radnik-intervju — 16.25 (Centar za mentalno zdravlje)
('field-social-anamnesis', 24.37, NULL, 'UL_H04003'), -- H04003 Socijalna anamneza na terenu — 24.37 (Centar za mentalno zdravlje)
('individual-sociotherapy', 32.49, NULL, 'UL_H04004'), -- H04004 Socio terapija-liječeni pacijenti — 32.49 (Centar za mentalno zdravlje)
('marital-sociotherapy', 24.37, NULL, 'UL_H04005'), -- H04005 Socio tretman-bračni — 24.37 (Centar za mentalno zdravlje)
('family-group-sociotherapy', 24.37, NULL, 'UL_H04006'), -- H04006 Socio tretman-član porodice — 24.37 (Centar za mentalno zdravlje)
('family-sociotherapy', 32.49, NULL, 'UL_H04007'), -- H04007 Socio tretman- porodica-teren — 32.49 (Centar za mentalno zdravlje)
('individual-stress-sociotherapy', 24.37, NULL, 'UL_H04008'), -- H04008 Socio terapija-individualna seansa — 24.37 (Centar za mentalno zdravlje)
('organized-sociotherapy', 32.49, NULL, 'UL_H04009'), -- H04009 Socio tretman-radna organizacija — 32.49 (Centar za mentalno zdravlje)
('legal-responsibility-assessment', 24.37, NULL, 'UL_H04010'), -- H04010 Vještačenje zakonske odgovornosti — 24.37 (Centar za mentalno zdravlje)
('cooperation-with-social-protection-and-healthcare-services', 24.37, NULL, 'UL_H04011'), -- H04011 Saradnja sa službama socijalne zaštite i drugim zdravstvenim ustanovama — 24.37 (Centar za mentalno zdravlje)
('first-discharge-team-home-visit-up-to-5-km', 142.64, NULL, 'UL_H09001'), -- H09001 Prva posjeta asertivnog tima u kući osiguranika na udaljenosti do 5 km od Doma zdravlja — 142.64 (Centar za mentalno zdravlje)
('first-discharge-team-home-visit-5-to-15-km', 164.59, NULL, 'UL_H09002'), -- H09002 Prva posjeta asertivnog tima u kući osiguranika na udaljenosti od 5-15 km od Doma zdravlja — 164.59 (Centar za mentalno zdravlje)
('first-discharge-team-home-visit-over-15-km', 186.53, NULL, 'UL_H09003'), -- H09003 Prva posjeta asertivnog tima u kući osiguranika na udaljenosti preko 15 km od Doma zdravlja — 186.53 (Centar za mentalno zdravlje)
('follow-up-discharge-team-home-visit-up-to-5-km', 109.73, NULL, 'UL_H09004'), -- H09004 Ponovna posjeta asertivnog tima u kući osiguranika na udaljenosti do 5 km od Doma zdravlja — 109.73 (Centar za mentalno zdravlje)
('follow-up-discharge-team-home-visit-5-to-15-km', 131.67, NULL, 'UL_H09005'), -- H09005 Ponovna posjeta asertivnog tima u kući osiguranika na udaljenosti od 5-15 km od Doma zdravlja — 131.67 (Centar za mentalno zdravlje)
('follow-up-discharge-team-home-visit-over-15-km', 153.62, NULL, 'UL_H09006'), -- H09006 Ponovna posjeta asertivnog tima u kući osiguranika na udaljenosti preko 15 km od Doma zdravlja — 153.62 (Centar za mentalno zdravlje)
('methadone-administration', 3.71, NULL, 'UL_X01023'), -- X01023 davanje metadona — 3.71 (Centar za mentalno zdravlje)
-- ── Centar za dijagnostiku – RTG i UZ ──
('first-radiologist-examination', 9.98, NULL, 'UL_J01001'), -- J01001 Prvi specijalistički pregled (radiolog) — 9.98 (Centar za dijagnostiku – RTG i UZ)
('targeted-skull-region-x-ray-per-image', 7.49, NULL, 'UL_J06001'), -- J06001 Snimanje skeleta lobanje i lica-za svaki snimak — 7.49 (Centar za dijagnostiku – RTG i UZ)
('x-ray-cervical-spine', 7.49, NULL, 'UL_J06002'), -- J06002 Snimanje pojedinih dijelova kičme i sakroilijačne regije-za svaki snimak — 7.49 (Centar za dijagnostiku – RTG i UZ)
('x-ray-thoracic-spine', 7.49, NULL, 'UL_J06002'), -- J06002 Snimanje pojedinih dijelova kičme i sakroilijačne regije-za svaki snimak — 7.49 (Centar za dijagnostiku – RTG i UZ)
('x-ray-lumbar-spine-and-sacrum', 7.49, NULL, 'UL_J06002'), -- J06002 Snimanje pojedinih dijelova kičme i sakroilijačne regije-za svaki snimak — 7.49 (Centar za dijagnostiku – RTG i UZ)
('x-ray-sacrum', 7.49, NULL, 'UL_J06002'), -- J06002 Snimanje pojedinih dijelova kičme i sakroilijačne regije-za svaki snimak — 7.49 (Centar za dijagnostiku – RTG i UZ)
('x-ray-sacroiliac-joints', 7.49, NULL, 'UL_J06002'), -- J06002 Snimanje pojedinih dijelova kičme i sakroilijačne regije-za svaki snimak — 7.49 (Centar za dijagnostiku – RTG i UZ)
('extremity-x-ray-per-image', 7.49, NULL, 'UL_J06003'), -- J06003 Snimanje pojedinih djelova skeleta, ekstremiteta i karlice za svaki snimak -ekspoziciju — 7.49 (Centar za dijagnostiku – RTG i UZ)
('x-ray-pelvis', 7.49, NULL, 'UL_J06003'), -- J06003 Snimanje pojedinih djelova skeleta, ekstremiteta i karlice za svaki snimak -ekspoziciju — 7.49 (Centar za dijagnostiku – RTG i UZ)
('foreign-body-localization-x-ray-except-eye', 7.49, NULL, 'UL_J06004'), -- J06004 Lokalizacija stranog tijela u bilo kojem organu — 7.49 (Centar za dijagnostiku – RTG i UZ)
('pharynx-and-larynx-x-ray', 7.49, NULL, 'UL_J06005'), -- J06005 Snimanje ždrijela i grkljana — 7.49 (Centar za dijagnostiku – RTG i UZ)
('chest-ribs-or-sternum-x-ray-per-view', 2.50, NULL, 'UL_J06006'), -- J06006 Snimanje toraksa (rebra, sternum) -za svaku projekciju — 2.50 (Centar za dijagnostiku – RTG i UZ)
('lung-fluorography', 4.99, NULL, 'UL_J06007'), -- J06007 Fluorogram pluća — 4.99 (Centar za dijagnostiku – RTG i UZ)
('x-ray-chest', 7.49, NULL, 'UL_J06008'), -- J06008 Snimanje pluća za svaki pravac — 7.49 (Centar za dijagnostiku – RTG i UZ)
('mediastinum-x-ray', 7.49, NULL, 'UL_J06009'), -- J06009 Snimak medijastinuma — 7.49 (Centar za dijagnostiku – RTG i UZ)
('heart-teleradiography', 7.49, NULL, 'UL_J06010'), -- J06010 Teleradiografija srca — 7.49 (Centar za dijagnostiku – RTG i UZ)
('hepatobiliary-tract-x-ray', 7.49, NULL, 'UL_J06011'), -- J06011 Snimanje hepatobilijarnog trakta — 7.49 (Centar za dijagnostiku – RTG i UZ)
('x-ray-urinary-tract', 7.49, NULL, 'UL_J06012'), -- J06012 Snimanje urogenitalnog trakta — 7.49 (Centar za dijagnostiku – RTG i UZ)
('x-ray-urinary-tract-native', 4.99, NULL, 'UL_J06013'), -- J06013 Nativni snimak urotrakta, sa snimkom male karlice — 4.99 (Centar za dijagnostiku – RTG i UZ)
('mammography', 7.49, NULL, 'UL_J06014'), -- J06014 Mamografija — 7.49 (Centar za dijagnostiku – RTG i UZ)
('x-ray-abdomen-native', 7.49, NULL, 'UL_J06015'), -- J06015 Nativni snimak abdomena za svaki pravac — 7.49 (Centar za dijagnostiku – RTG i UZ)
('upper-abdomen-ultrasound', 32.18, NULL, 'UL_J07001'), -- J07001 UZ gornjeg abdomena:žučne kese,žučnih puteva, jetre, gušterače i slezine — 32.18 (Centar za dijagnostiku – RTG i UZ)
('lower-abdomen-ultrasound', 32.18, NULL, 'UL_J07002'), -- J07002 UZ donjega abdomena: mokraćne bešike i prostate, retroperitoneuma: bubrega, nadbubrežnih žljezda — 32.18 (Centar za dijagnostiku – RTG i UZ)
('testicular-ultrasound', 32.18, NULL, 'UL_J07003'), -- J07003 UZ testisa kod muškaraca — 32.18 (Centar za dijagnostiku – RTG i UZ)
('pediatric-hip-ultrasound', 32.18, NULL, 'UL_J07004'), -- J07004 UZ kukova kod odojčadi — 32.18 (Centar za dijagnostiku – RTG i UZ)
('joint-and-soft-tissue-ultrasound', 32.18, NULL, 'UL_J07005'), -- J07005 UZ ciljani pregled zglobova i mekih tkiva — 32.18 (Centar za dijagnostiku – RTG i UZ)
('ultrasound-lymph-nodes', 32.18, NULL, 'UL_J07006'), -- J07006 UZ pregled limfnih žlijezda — 32.18 (Centar za dijagnostiku – RTG i UZ)
('ultrasound-thyroid-and-parathyroid-glands', 32.18, NULL, 'UL_J07007'), -- J07007 UZ štitne i paraštitne žlijezde — 32.18 (Centar za dijagnostiku – RTG i UZ)
('breast-ultrasound', 32.18, NULL, 'UL_J07008'), -- J07008 UZ pregled dojki — 32.18 (Centar za dijagnostiku – RTG i UZ)
('panoramic-dental-radiography', 3.42, NULL, 'UL_J11001'), -- J11001 Panoramska dentalna radiografija — 3.42 (Centar za dijagnostiku – RTG i UZ)
('intraoral-x-ray', 3.42, NULL, 'UL_J11002'), -- J11002 Obični intraoralni snimak zuba — 3.42 (Centar za dijagnostiku – RTG i UZ)
('panoramic-x-ray', 27.36, NULL, 'UL_J11003'), -- J11003 Ortopantomografski snimak — 27.36 (Centar za dijagnostiku – RTG i UZ)
('cephalometric-x-ray', 5.13, NULL, 'UL_J11004'), -- J11004 Telerentgenski snimak glave — 5.13 (Centar za dijagnostiku – RTG i UZ)
-- ── Centar za dijagnostiku – mikrobiološka dijagnostika ──
('sample-reception-and-sterile-container-distribution', 1.43, NULL, 'UL_K01002'), -- K01002 Prijem materijala i davanje sterilnih posuda za urin, sputum, stolicu i dr. — 1.43 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('microbiology-sample-collection', 2.38, NULL, 'UL_K01003'), -- K01003 Uzimanje uzoraka — 2.38 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('crp-latex-test', 7.61, NULL, 'UL_K01059'), -- K01059 CRP-LATEX — 7.61 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('crp-turbidimetry', 7.61, NULL, 'UL_K01065'), -- K01065 CRP-TURBIDOMETRIJA — 7.61 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('aso-turbidimetry', 9.52, NULL, 'UL_K01066'), -- K01066 ASTO-TURBIDOMETRIJA — 9.52 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('rheumatoid-factor-turbidimetry', 9.52, NULL, 'UL_K01068'), -- K01068 REUMA FAKTOR (RF)-TURBIDOMETRIJA — 9.52 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('microbial-antigen-latex-agglutination-test', 4.28, NULL, 'UL_K02008'), -- K02008 Detekcija antimikrobnih antigena latex aglutinacionim testom — 4.28 (Centar za dijagnostiku – mikrobiološka dijagnostika)
-- ── Jedinica za patronažu ──
('newborn-and-family-home-patronage-visit', 30.74, NULL, 'UL_L01001'), -- L01001 Patronažna posjeta djeteta u prvoj godini života sa zdravstvenim vaspitanjem majke i porodice — 30.74 (Jedinica za patronažu)
('home-patronage-visit-child-age-2', 30.74, NULL, 'UL_L01002'), -- L01002 Patronažna posjeta kod djeteta u drugoj godini života — 30.74 (Jedinica za patronažu)
('home-patronage-visit-child-age-4', 30.74, NULL, 'UL_L01003'), -- L01003 Patronažna posjeta kod djeteta u čertvrtoj godini života — 30.74 (Jedinica za patronažu)
('pregnancy-patronage-visit-birth-and-newborn-care-preparation', 30.74, NULL, 'UL_L01007'), -- L01007 Patronažna posjeta trudnici sa zdravstvenim vaspitanjem (savjetovanje o trudnoći i pripremi za porođaj, o dojenju, pravilnoj ishrani i njezi novorođenčeta (odojčeta)) — 30.74 (Jedinica za patronažu)
('postpartum-patronage-visit', 30.74, NULL, 'UL_L01008'), -- L01008 Patronažna posjeta kod babinjare sa zdravstvenim vaspitanjem — 30.74 (Jedinica za patronažu)
('patronage-visit-for-women-without-gynecological-visit-3-years', 30.74, NULL, 'UL_L01009'), -- L01009 Patronažna posjeta kod žena koje više od 3. godine nisu bile kod ginekologa — 30.74 (Jedinica za patronažu)
('senior-patronage-visit-over-65', 30.74, NULL, 'UL_L01012'), -- L01012 Patronažna posjeta osoba starijih od 65 godina, koje tokom kalendarske godine nisu bile kod svog izabranog doktora — 30.74 (Jedinica za patronažu)
('chronic-patient-patronage-visit', 30.74, NULL, 'UL_L02001'), -- L02001 Patronažne posjete hroničnom bolesniku (oboljelom od urođenog poremećaja zgrušavanja krvi, šećerne bolesti, duševnih bolesti, malignih bolesti i na peritonealnoj dijalizi), osobi sa bolestima zavisnosti i invalidnoj osobi po nalogu izabranog doktora. — 30.74 (Jedinica za patronažu)
('active-tb-patient-patronage-visit', 30.74, NULL, 'UL_L02002'), -- L02002 Patronažne posjete kod lica sa aktivnom TBC — 30.74 (Jedinica za patronažu)
('immobile-patient-patronage-visit', 30.74, NULL, 'UL_L02003'), -- L02003 Patronažne posjeta bolesniku kome je potrebna djelimična ili potpuna pomoć kod izvođenja osnovnih životnih aktivnosti zbog bolesti ili starosti (nepokretan ili ograničeno pokretan, vezan za kolica ili krevet ili hoda uz pomoć druge osobe i pomagala)(oboljelom od distrofije, multiple skleroze, cerebralne paralize) — 30.74 (Jedinica za patronažu)
('family-health-social-problem-patronage-visit', 30.74, NULL, 'UL_L02004'), -- L02004 Patronažna posjeta porodici u kojoj postoje zdravstveno-socijalni problemi — 30.74 (Jedinica za patronažu)
('family-with-elderly-or-disabled-member-patronage-visit', 30.74, NULL, 'UL_L02005'), -- L02005 Patronažna posjeta porodici koja se brine o invalidnoj osobi, teškom bolesniku ili o staroj osobi — 30.74 (Jedinica za patronažu)
('preventive-action-participation', 61.49, NULL, 'UL_L04001'), -- L04001 Uključivanje u preventivne akcije kod vodećih javnozdravstvenih problema — 61.49 (Jedinica za patronažu)
('health-education-group-work', 61.49, NULL, 'UL_L04002'), -- L04002 Zdravstveno vaspitni i promotivni programi- grupni rad — 61.49 (Jedinica za patronažu)
('chronic-patient-health-education', 61.49, NULL, 'UL_L04003'), -- L04003 Zdravstveno vaspitni rad sa hroničnim bolesnicima — 61.49 (Jedinica za patronažu)
('patronage-nurse-treatment-visit-up-to-5-km', 20.50, NULL, 'UL_L03001'), -- L03001 Posjeta patronažne sestre zbog tretmana i postupaka kod nepokretnih ili teško pokretnih bolesnika po nalogu izabranog doktora na udaljenosti do 5 km od Doma zdravlja. — 20.50 (Jedinica za patronažu)
('patronage-nurse-treatment-visit-5-to-15-km', 25.62, NULL, 'UL_L03002'), -- L03002 Posjeta patronažne sestre zbog tretmana i postupaka kod nepokretnih ili teško pokretnih bolesnika po nalogu izabranog doktora na udaljenosti od 5 do15 km od Doma zdravlja. — 25.62 (Jedinica za patronažu)
('patronage-nurse-treatment-visit-over-15-km', 30.74, NULL, 'UL_L03003'), -- L03003 Posjeta patronažne sestre zbog tretmana i postupaka kod nepokretnih ili teško pokretnih bolesnika po nalogu izabranog doktora na udaljenosti više od 15 km od Doma zdravlja. — 30.74 (Jedinica za patronažu)
('patronage-nurse-infusion-visit-up-to-5-km', 30.74, NULL, 'UL_L03004'), -- L03004 Posjeta patronažne sestre zbog davanja infuzije po nalogu izabranog doktora na udaljenosti do 5 km od Doma zdravlja. — 30.74 (Jedinica za patronažu)
('patronage-nurse-infusion-visit-5-to-15-km', 35.87, NULL, 'UL_L03005'), -- L03005 Posjeta patronažne sestre zbog davanja infuzije po nalogu izabranog doktora na udaljenosti od 5do15 km od Doma zdravlja. — 35.87 (Jedinica za patronažu)
('patronage-nurse-infusion-visit-over-15-km', 40.99, NULL, 'UL_L03006'), -- L03006 Posjeta patronažne sestre zbog davanja infuzije po nalogu izabranog doktora na udaljenosti više od 15 km od Doma zdravlja. — 40.99 (Jedinica za patronažu)
-- ── Fizikalna terapija ──
('manual-segmental-massage', 8.30, NULL, 'UL_M01001'), -- M01001 Manuelna segmentna masaža. — 8.30 (Fizikalna terapija)
('lymphatic-drainage-complete', 8.30, NULL, 'UL_M01002'), -- M01002 Manuelna limfna drenaža. — 8.30 (Fizikalna terapija)
('apparatus-assisted-massage', 5.54, NULL, 'UL_M01003'), -- M01003 Aparaturna masaža. — 5.54 (Fizikalna terapija)
('thermotherapy-cryotherapy', 8.30, NULL, 'UL_M01004'), -- M01004 Krioterapija i kriomasaža. — 8.30 (Fizikalna terapija)
('manual-muscle-test-per-extremity', 5.54, NULL, 'UL_M01005'), -- M01005 Manuelni mišićni test, po ekstremitetu. — 5.54 (Fizikalna terapija)
('infrared-ultraviolet-and-bioptron-lamp-irradiation', 8.30, NULL, 'UL_M01006'), -- M01006 Zračenje infracrvenim, ultravioletnim i bioptrom lampom. — 8.30 (Fizikalna terapija)
('thermotherapy-parafango', 5.54, NULL, 'UL_M01007'), -- M01007 Parafin i fango terapija. — 5.54 (Fizikalna terapija)
('galvanic-therapy', 11.07, NULL, 'UL_M01008'), -- M01008 Galvanizacija. — 11.07 (Fizikalna terapija)
('electrophoresis', 8.30, NULL, 'UL_M01009'), -- M01009 Elektroforeza. — 8.30 (Fizikalna terapija)
('diadynamic-currents', 8.30, NULL, 'UL_M01010'), -- M01010 Diadinamske struje. — 8.30 (Fizikalna terapija)
('transcutaneous-electrical-nerve-stimulation-tens', 11.07, NULL, 'UL_M01011'), -- M01011 Transkutana nervna stimulacija. — 11.07 (Fizikalna terapija)
('ktd-diathermy', 11.07, NULL, 'UL_M01012'), -- M01012 KTD. — 11.07 (Fizikalna terapija)
('microwave-diathermy', 8.30, NULL, 'UL_M01013'), -- M01013 Mikrotalasna diatermija. — 8.30 (Fizikalna terapija)
('sonophoresis', 8.30, NULL, 'UL_M01014'), -- M01014 Sonoforeza. — 8.30 (Fizikalna terapija)
('muscle-electrical-stimulation', 11.07, NULL, 'UL_M01015'), -- M01015 Elektrostimulacija mišića. — 11.07 (Fizikalna terapija)
('activities-of-daily-living-training', 11.07, NULL, 'UL_M01016'), -- M01016 Uvježbavanje aktivnosti svakodnevnog života prema patološkim stanjima. — 11.07 (Fizikalna terapija)
('gait-exercises', 8.30, NULL, 'UL_M01017'), -- M01017 Vježba hoda. — 8.30 (Fizikalna terapija)
('gait-training-with-walking-aid', 11.07, NULL, 'UL_M01018'), -- M01018 Obuka hoda sa pomagalom. — 11.07 (Fizikalna terapija)
('gait-coordination-correction-and-balance-automation-exercises', 11.07, NULL, 'UL_M01019'), -- M01019 Vježbe koordinacije, korekcije i automatizacije balansa hoda. — 11.07 (Fizikalna terapija)
('breathing-exercises', 8.30, NULL, 'UL_M01020'), -- M01020 Vježbe disanja. — 8.30 (Fizikalna terapija)
('group-exercises-type-b', 1.66, NULL, 'UL_M01021'), -- M01021 Grupne vježbe, po osobi. — 1.66 (Fizikalna terapija)
('high-risk-infant-stimulation-exercises', 24.91, NULL, 'UL_M01022'), -- M01022 Stimulativne vježbe kod riziko beba. — 24.91 (Fizikalna terapija)
('pediatric-play-therapy', 16.61, NULL, 'UL_M01023'), -- M01023 Terapija igrom sa djecom i vježbe na spravama. — 16.61 (Fizikalna terapija)
('passive-and-assisted-exercises', 11.07, NULL, 'UL_M01024'), -- M01024 Pasivne i potpomognute vježbe. — 11.07 (Fizikalna terapija)
('active-and-resistance-exercises', 11.07, NULL, 'UL_M01025'), -- M01025 Aktivne vježbe i vježbe protiv otpora. — 11.07 (Fizikalna terapija)
('segmental-isometric-exercises', 8.30, NULL, 'UL_M01026'), -- M01026 Izometrijske vježbe - segmentne. — 8.30 (Fizikalna terapija)
('kinesiotherapy-for-spine-deformities', 16.61, NULL, 'UL_M01027'), -- M01027 Kineziterapija kod djece sa deformacijom kičmenog stuba i grudnog koša ili sa deformacijom ekstremiteta. — 16.61 (Fizikalna terapija)
('cns-sensorimotor-development-stimulation', 22.14, NULL, 'UL_M01028'), -- M01028 Stimulacija senzomotornog razvoja i oštećenih funkcija CNS specifičnim tehnikama:Vojta, Bobath, Kabath i dr. — 22.14 (Fizikalna terapija)
('activities-of-daily-living-test', 16.61, NULL, 'UL_M01029'), -- M01029 Test aktivnosti svakodnevnog života. — 16.61 (Fizikalna terapija)
('patient-training-in-specific-protective-body-positions', 16.61, NULL, 'UL_M01030'), -- M01030 Obuka pacijenta specifičnim zaštitnim položajima tijela. — 16.61 (Fizikalna terapija)
('interferential-currents', 11.07, NULL, 'UL_M01031'), -- M01031 Interferentne struje — 11.07 (Fizikalna terapija)
('physiotherapist-home-visit-up-to-5-km', 27.68, NULL, 'UL_M01032'), -- M01032 Posjeta fizioterapeuta zbog sprovodjenja fizikalne terapije kod nepokretnih ili teško pokretnih bolesnika po nalogu izabranog doktora na udaljenosti do 5 km od Doma zdravlja — 27.68 (Fizikalna terapija)
('physiotherapist-home-visit-5-to-15-km', 33.21, NULL, 'UL_M01033'), -- M01033 Posjeta fizioterapeuta zbog sprovodjenja fizikalne terapije kod nepokretnih ili teško pokretnih bolesnika po nalogu izabranog doktora na udaljenosti od 5 do 15 km od Doma zdravlja — 33.21 (Fizikalna terapija)
('physiotherapist-home-visit-over-15-km', 38.75, NULL, 'UL_M01034'), -- M01034 Posjeta fizioterapeuta zbog sprovodjenja fizikalne terapije kod nepokretnih ili teško pokretnih bolesnika po nalogu izabranog doktora na udaljenosti više od 15 km od Doma zdravlja — 38.75 (Fizikalna terapija)
('magnetic-therapy', 12.51, NULL, 'UL_M02008'), -- M02008 Magnetoterapija — 12.51 (Fizikalna terapija)
('ultrasound-therapy', 8.34, NULL, 'UL_M02009'), -- M02009 Terapija ultrazvukom — 8.34 (Fizikalna terapija)
('underwater-ultrasound-therapy', 10.02, NULL, 'UL_M02010'), -- M02010 Terapija ultrazvukom u vodi — 10.02 (Fizikalna terapija)
('laser-therapy', 12.51, NULL, 'UL_M02011'), -- M02011 Laser terapija — 12.51 (Fizikalna terapija)
-- ── Без цены (сайт называет услугу, цены нет) ──
('pre-employment-medical-certificate', NULL, NULL, NULL), -- /medicina-rada/ «ljekarsko uvjerenje o sposobnosti za rad, prilikom zasnivanja radnog odnosa»
('medical-certificate-for-high-risk-and-difficult-working-conditions', NULL, NULL, NULL), -- /medicina-rada/ «pri zapošljavanju na radnim mjestima s posebnim zahtjevima radnog mjesta – posebnim uslovima rada (s povećanim rizikom) u našoj službi se obavljaju prethodni pregledi …» + «nakon periodičnog i ciljanog pregleda radnika koji rade na radnim mjestima s posebnim uslovima rada – ljekarsko uvjerenje – mišljenje o daljoj sposobnosti za rad»
('medical-certificate-for-driving-license-category-a-b-c-d-e', NULL, NULL, NULL), -- /medicina-rada/ «ljekarska uvjerenja o sposobnosti za upravljanjem motornim vozilom u drumskom saobraćaju – svih kategorija i specijalnih vozila»
('medical-certificate-for-boat-operation-up-to-12-meters', NULL, NULL, NULL), -- /medicina-rada/ «ljekarsko uvjerenje o ispunjavanju uslova za voditelja čamca»
('medical-certificate-for-firearms-possession', NULL, NULL, NULL), -- /medicina-rada/ «ljekarsko uvjerenje o podobnosti za posjedovanje, kao i za posjedovanje i nošenje vatrenog oružja»
('medical-certificate-for-maritime-workers', NULL, NULL, NULL), -- /medicina-rada/ «ljekarsko uvjerenje o sposobnosti za pomorce»
('medical-certificate-for-underage-marriage', NULL, NULL, NULL), -- /medicina-rada/ «ljekarsko uvjerenje za sklapanje braka – za maloljetne osobe»
('medical-certificate-for-child-adoption', NULL, NULL, NULL), -- /medicina-rada/ «ljekarsko uvjerenje o podobnosti za usvajanje djeteta»
('medical-certificate-for-secondary-school-enrollment', NULL, NULL, NULL), -- /medicina-rada/ «ljekarsko uvjerenje za upis u specifične srednje škole (saobraćajna, građevinska, neki smjerovi medicinske škole)»
('medical-certificate-for-study-abroad-and-visa', NULL, NULL, NULL), -- /medicina-rada/ «ljekarsko uvjerenje za dalji nastavak školovanja i boravak u inostranstvu»
('sanitary-examination-for-food-industry-and-water-supply-workers', NULL, NULL, NULL), -- /centar-za-dijagnostiku/ «Mikrobiološka laboratorija … daje i usluge izdavanja sanitarnih knjižica» — категория работника не уточняется, заведены все три вида санитарного осмотра
('sanitary-examination-for-healthcare-and-educational-workers', NULL, NULL, NULL), -- см. выше — «izdavanja sanitarnih knjižica»
('sanitary-examination-for-hairdressers-and-service-personnel', NULL, NULL, NULL), -- см. выше — «izdavanja sanitarnih knjižica»
('internist-examination', NULL, NULL, NULL), -- RASPORED RADA SPECIJALISTA «Interna medicina – Dr spec. Isat Jakupi – Internista, Dr spec. Teuta Leskovac – Internista, Ponedeljak – Petak 07:00 – 15:00»
('ophthalmological-examination', NULL, NULL, NULL); -- RASPORED RADA SPECIJALISTA «Oftamologija – Dr spec. Nita Hoxha - Oftamolog»

-- Страховка: slug, не найденные в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_service
FROM tmp_dzulcinj_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, NULL, t.price_max, t.code
FROM tmp_dzulcinj_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = VALUES(price), price_min = VALUES(price_min), price_max = VALUES(price_max), code = VALUES(code);

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_dzulcinj_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: АНАЛИЗЫ — КАНОНИЧЕСКИЙ СПИСОК (Centar za dijagnostiku – mikrobiološka dijagnostika
-- + C01002 кариотип из околоплодных вод из раздела гинеколога)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_dzulcinj_labtests;
CREATE TEMPORARY TABLE tmp_dzulcinj_labtests (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL,
	code VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_dzulcinj_labtests (slug, price, price_max, code) VALUES
('karyotype-from-amniotic-fluid', 13.14, NULL, 'UL_C01002'), -- C01002 Prenatalno određivanje kariotipa fetusa iz ćelija plodove vode kod svih trudnica sa 35 i više godina pri začeću — 13.14 (Usluge izabranog ginekologa)
('microscopic-examination-of-swab-for-gonorrhea', 12.37, NULL, 'UL_K01004'), -- K01004 Pregled preparata uretralnog, vaginalnog ili cervikalnog brisa na gonoreju — 12.37 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('amine-test', 2.38, NULL, 'UL_K01005'), -- K01005 Aminski test — 2.38 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('microscopic-examination-for-treponema-pallidum', 12.37, NULL, 'UL_K01006'), -- K01006 Mikroskopski pregled na Treponema pallidum — 12.37 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('throat-swab-bacteria', 13.32, NULL, 'UL_K01007'), -- K01007 Bris ždrijela — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('oral-cavity-swab-bacteria', 13.32, NULL, 'UL_K01008'), -- K01008 Bris usne duplje — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('tongue-swab-bacteria', 13.32, NULL, 'UL_K01009'), -- K01009 Bris jezika — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('nose-swab-bacteria', 13.32, NULL, 'UL_K01010'), -- K01010 Bris nosa — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('eye-swab-bacteria', 13.32, NULL, 'UL_K01011'), -- K01011 Bris oka — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('bacteriological-examination-ear-swab', 13.32, NULL, 'UL_K01012'), -- K01012 Bris uha — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('wound-swab-bacteria', 16.65, NULL, 'UL_K01013'), -- K01013 Bris rane — 16.65 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('umbilicus-swab-bacteria', 13.32, NULL, 'UL_K01014'), -- K01014 Bris pupka — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('skin-swab-bacteria', 13.32, NULL, 'UL_K01015'), -- K01015 Bris kože — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('breast-swab-bacteria', 13.32, NULL, 'UL_K01016'), -- K01016 Bris dojke — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('vaginal-swab-bacteria', 13.32, NULL, 'UL_K01017'), -- K01017 Bris vagine — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('vulvar-swab-bacteria', 13.32, NULL, 'UL_K01018'), -- K01018 Bris vulve — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('glans-swab-bacteria', 13.32, NULL, 'UL_K01019'), -- K01019 Bris glansa — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('prepuce-swab-bacteria', 13.32, NULL, 'UL_K01020'), -- K01020 Bris prepucijuma — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('urethral-swab-bacteria', 13.32, NULL, 'UL_K01021'), -- K01021 Bris uretre — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('urine-culture', 13.32, NULL, 'UL_K01022'), -- K01022 Urinokultura — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('stool-culture', 13.32, NULL, 'UL_K01023'), -- K01023 Koprokultura. — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('perianal-swab', 13.32, NULL, 'UL_K01024'), -- K01024 Bris čmara — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('vibrio-cholerae-culture', 13.32, NULL, 'UL_K01025'), -- K01025 Kultura na Vibrio kolera — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('sputum-bacteria', 13.32, NULL, 'UL_K01026'), -- K01026 Sputum kultura — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('cervical-swab-bacteria', 13.32, NULL, 'UL_K01027'), -- K01027 Cervikalna kultura — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('antibiogram', 7.61, NULL, 'UL_K01028'), -- K01028 Izrada antibiograma (radi se po potrebi) — 7.61 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('mycoplasma-hominis-ureaplasma', 15.23, NULL, 'UL_K01029'), -- K01029 Kultivacija Mycoplasma sa izradom antibiograma — 15.23 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('dermatophytes-nail-scraping', 17.13, NULL, 'UL_K01030'), -- K01030 Pregled preparata na dermatomikoze nokta — 17.13 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('dermatophytes-skin-scraping', 17.13, NULL, 'UL_K01031'), -- K01031 Pregled preparata na dermatomikoze kože — 17.13 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('dermatophytes-hair-scraping', 17.13, NULL, 'UL_K01032'), -- K01032 Pregled preparata na dermatomikoze dlake. — 17.13 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('skin-swab-fungi', 13.32, NULL, 'UL_K01033'), -- K01033 Kultura brisa kože na gljivice — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('hair-swab-fungi', 13.32, NULL, 'UL_K01034'), -- K01034 Kultura brisa dlake na gljivice — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('nail-swab-fungi', 13.32, NULL, 'UL_K01035'), -- K01035 Kultura brisa nokta na gljivice — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('vaginal-swab-fungi', 13.32, NULL, 'UL_K01036'), -- K01036 Kultura vaginalnog sekreta na gljivice — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('vulvar-swab-fungi', 13.32, NULL, 'UL_K01037'), -- K01037 Kultura brisa vulve na gljivice — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('glans-swab-fungi', 13.32, NULL, 'UL_K01038'), -- K01038 Kultura brisa glansa na gljivice — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('prepuce-swab-fungi', 13.32, NULL, 'UL_K01039'), -- K01039 Kultura brisa prepucijuma na gljivice — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('urethral-swab-fungi', 13.32, NULL, 'UL_K01040'), -- K01040 Kultura uretralnog sekreta na gljivice — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('stool-fungi', 13.32, NULL, 'UL_K01041'), -- K01041 Kultura stolice na gljivice — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('urine-fungi', 13.32, NULL, 'UL_K01042'), -- K01042 Kultura urina na gljivice — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('nose-swab-fungi', 13.32, NULL, 'UL_K01043'), -- K01043 Kultura brisa nosa na gljivice — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('sputum-fungi', 13.32, NULL, 'UL_K01044'), -- K01044 Kultura sputuma na gljivice — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('throat-swab-fungi', 13.32, NULL, 'UL_K01045'), -- K01045 Kultura brisa grla na gljivice — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('palate-swab-fungi', 13.32, NULL, 'UL_K01046'), -- K01046 Kultura brisa nepca na gljivice — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('wound-swab-fungi', 16.65, NULL, 'UL_K01047'), -- K01047 Kultura brisa rane na gljivice — 16.65 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('fungal-identification', 21.89, NULL, 'UL_K01048'), -- K01048 Identifikacija gljivica — 21.89 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('antimycogram', 12.37, NULL, 'UL_K01049'), -- K01049 Izrada antimikograma — 12.37 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('trichomonas-test', 12.37, NULL, 'UL_K01050'), -- K01050 Pregled preparata uretralnog ili vaginalnog brisa na Trichomonas vaginalis (stepen) — 12.37 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('perianal-cellophane-tape-test-pinworm', 10.47, NULL, 'UL_K01051'), -- K01051 Mikroskopski pregled perianalnog otiska (ljepljivim celofanom) — 10.47 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('stool-parasites', 17.13, NULL, 'UL_K01052'), -- K01052 Mikroskopski pregled stolice na helminte (metoda koncentracije). — 17.13 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('stool-microscopic-examination-for-protozoa', 17.13, NULL, 'UL_K01053'), -- K01053 Mikroskopski pregled stolice na protozoe (metoda koncentracije) — 17.13 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('native-microscopic-preparation-for-amebae-with-provocation', 12.37, NULL, 'UL_K01054'), -- K01054 Nativni mikroskopski preparat na amebe sa proviokacijom — 12.37 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('cryptosporidium-in-stool-ziehl-neelsen', 12.37, NULL, 'UL_K01055'), -- K01055 Parazitoloski pregled stolice na Cryptosporidium vrste (Ziehl-Neelsen) — 12.37 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('malaria', 33.31, NULL, 'UL_K01056'), -- K01056 Mikroskopski preparat i pregled na malartiju — 33.31 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('skin-ectoparasite-identification', 10.94, NULL, 'UL_K01057'), -- K01057 Pregled i identifikacija ektoparazita kože (larva, lutka ili adult) — 10.94 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('demodex-species', 12.37, NULL, 'UL_K01058'), -- K01058 Uzimanje i pregled otiska kože na Demodex vrste — 12.37 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('vdrl', 7.61, NULL, 'UL_K01060'), -- K01060 VDRL — 7.61 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('asto', 9.52, NULL, 'UL_K01061'), -- K01061 ASTO -LATEX — 9.52 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('monosticon', 9.52, NULL, 'UL_K01062'), -- K01062 Paul Bunel-ova reakcija (monostikon test) — 9.52 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('tpha-treponema-pallidum', 9.52, NULL, 'UL_K01063'), -- K01063 TPHA — 9.52 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('direct-microscopic-preparation', 12.37, NULL, 'UL_K01064'), -- K01064 Mikroskopsko citološki pregled (stepen) — 12.37 (Centar za dijagnostiku – mikrobiološka dijagnostika); как у ДЗ Херцег-Нови и больниц с кодом K01064
('rheumatoid-factor', 9.52, NULL, 'UL_K01067'), -- K01067 REUMA FAKTOR (RF)-LATEX — 9.52 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('waaler-rose-test', 9.52, NULL, 'UL_K01069'), -- K01069 WAALER-ROSE TEST — 9.52 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('tongue-swab-fungi', 13.32, NULL, 'UL_K01070'), -- K01070 Kultura brisa jezika na gljivice — 13.32 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('antimicrobial-antibody-detection-by-elisa', 14.27, NULL, 'UL_K02001'), -- K02001 Detekcija antimikrobnih antitijela ELISA -testom — 14.27 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('microbial-antigen-detection-by-elisa', 14.27, NULL, 'UL_K02002'), -- K02002 Detekcija mikrobnih antigena ELISA-testom — 14.27 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('antimicrobial-antibody-detection-by-indirect-immunofluorescence', 21.41, NULL, 'UL_K02003'), -- K02003 Detekcija antimikrobnih antitijela indirektnom imunofluorescencijom — 21.41 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('microbial-antigen-detection-by-direct-immunofluorescence', 21.41, NULL, 'UL_K02004'), -- K02004 Detekcija mikrobnih antigena direktnom imunofluorescencijom — 21.41 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('antimicrobial-antibody-detection-by-complement-fixation', 14.27, NULL, 'UL_K02005'), -- K02005 Detekcija antimikrobnih antitijela reakcijom vezivanja komplementa — 14.27 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('antimicrobial-antibody-detection-by-hemagglutination', 14.27, NULL, 'UL_K02006'), -- K02006 Detekcija antimikrobnih antitijela - testom hemaglutinacije — 14.27 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('antimicrobial-antibody-detection-by-latex-agglutination', 4.28, NULL, 'UL_K02007'), -- K02007 Detekcija antimikrobnih antitijela latex aglutinacionim testom — 4.28 (Centar za dijagnostiku – mikrobiološka dijagnostika)
('microbial-nucleic-acid-detection-by-hybridization', 47.58, NULL, 'UL_K02009'); -- K02009 Detekcija mikrobnih nukleinskih kisjelina testom hibridizacije nukleinskih kisjelina — 47.58 (Centar za dijagnostiku – mikrobiološka dijagnostika)

-- Страховка: slug, не найденные в каталоге анализов. Ожидается ПУСТО.
SELECT t.slug AS unmatched_lab_test
FROM tmp_dzulcinj_labtests t
LEFT JOIN lab_tests lt ON lt.slug = t.slug
WHERE lt.id IS NULL;

INSERT INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code)
SELECT @clinic_id, lt.id, t.price, t.price_max, t.code
FROM tmp_dzulcinj_labtests t
JOIN lab_tests lt ON lt.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = VALUES(price), price_max = VALUES(price_max), code = VALUES(code);

DELETE clt FROM clinic_lab_tests clt
JOIN lab_tests lt ON lt.id = clt.lab_test_id
LEFT JOIN tmp_dzulcinj_labtests t ON t.slug = lt.slug
WHERE clt.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 277 услуг: с ценой 262, без цены 15, outdated 0, сумма price 7016.21 (после 054: +5 бывших спорных).
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL) AS with_price, SUM(price IS NULL) AS without_price,
	SUM(price_max IS NOT NULL) AS with_range, SUM(is_price_outdated) AS outdated, SUM(price) AS price_sum
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается 72 анализа, все с ценой, сумма price 1006.05 (+ K01064).
SELECT COUNT(*) AS lab_tests_total, SUM(price IS NOT NULL) AS with_price, SUM(is_price_outdated) AS outdated, SUM(price) AS price_sum
FROM clinic_lab_tests WHERE clinic_id = @clinic_id;

SELECT cms.code, ms.slug, ms.name_sr, cms.price, cms.price_max
FROM clinic_medical_services cms JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY cms.code IS NULL, cms.code, ms.slug;

DROP TEMPORARY TABLE IF EXISTS tmp_dzulcinj_services;
DROP TEMPORARY TABLE IF EXISTS tmp_dzulcinj_labtests;
