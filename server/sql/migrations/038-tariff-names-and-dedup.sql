-- 038: тарифы FZOCG и дубли каталога, найденные вычиткой названий услуг.
--
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/038-tariff-names-and-dedup.sql
--
-- Собрано scripts/services/build-catalog-fixes-sql.mjs — руками не править.
-- Разбор: docs/audit/service-names-2026-09.md, раздел «038». Применять ПОСЛЕ 036/037.
--
-- 1. ИМЕНА И ЦЕНЫ ТАРИФОВ (140 строк). При слиянии OCR и LLM-разбора прайса
--    в FINAL.json часть строк LLM съехала на соседнюю позицию: у X01036
--    («биопсия щитовидной железы») стояла «катетеризация у мужчин», у X10001
--    «manjih» вместо «malignih», у E09004/E09005 имена переставлены. Где съехала
--    строка целиком (22), неверной была и цена. Каждое исправление
--    подтверждено независимо: построчным OCR, названием услуги по прайсу клиники,
--    ценами клиник 88/137 (FZOCG × 2,5) и прайсом Данило (× 3 к «ambulanta»).
--    UPDATE идёт только если в БД всё ещё старое имя.
--
-- 2. PZZ-ТАРИФЫ НА ЧУЖИХ УСЛУГАХ (18). Коды первичного и секундарного прайсов
--    пересекаются: X01025 в PZZ — «Stavljanje IUD», в секундарном — биопсия
--    лимфоузла; L01001 — патронаж новорождённого против гистологии аппендикса.
--    PZZ-позиция переносится на свою услугу или отвязывается.
--
-- 3. ПЕРЕНОС ПО КОДУ. panoramic-x-ray смешивал ОПТГ частных клиник (J11003) и
--    позицию J11001 «Panoramska dentalna radiografija» (~3 €): строки и тарифы
--    J11001 уезжают на panoramic-dental-radiography.
--
-- 4. СЛИЯНИЯ (46) и 5. ОТКАЗЫ (11). Правило 027–034: решает код прайса.
--    Названия дубля остаются синонимами, старые слаги — 301 на основную.
--
-- Процедуры создаются и удаляются внутри файла. CREATE PROCEDURE делает неявный
-- COMMIT, поэтому транзакции нет; повторный прогон безопасен (слияние
-- проверяет, что обе половинки ещё на месте).

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';


-- ═══ 1. Имена и цены тарифов ═══

-- Y04003: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Nemedicinski dio BO dana - opšte i specijalne bolnice'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'Y04003' AND name_sr_latin = 'Nemedicinski dio BO dana - stacionar u DZ';
-- Y04004: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Nemedicinski dio BO dana u intenzivnoj njezi, koronarnoj jedinici i neonatologiji-opšte i specijalne bolnice'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'Y04004' AND name_sr_latin = 'Nemedicinski dio BO dana u Centru za rizičnu novorodjenčad';
-- Y04007: без клиник: OCR и донор согласны, цена из OCR
UPDATE medical_service_tariffs SET name_sr_latin = 'Nemedicinski dio BO dana - Klinički centar'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'Y04007' AND name_sr_latin = 'Nemedicinski dio BO dana - opšte i specijalne bolnice';
-- Y04009: без клиник: OCR и донор согласны, цена из OCR
UPDATE medical_service_tariffs SET name_sr_latin = 'Nemedicinski dio BO dana u Centru za rizičnu novorođenčad'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'Y04009' AND name_sr_latin = 'Nemedicinski dio BO dana u intenzivnoj njezi, koronarnoj jedinici i neonatologiji - Klinički centar';
-- Y04010: без клиник: OCR и донор согласны, цена из OCR
UPDATE medical_service_tariffs SET name_sr_latin = 'Nemedicinski dio BO dana - za kardiohirurgiju'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'Y04010' AND name_sr_latin = 'Nemedicinski dio BO dana u intenzivnoj njezi, koronarnoj jedinici - opšte i specijalne bolnice';
-- X19003: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Ispitivanje funkcije i građe ženskog reproduktivnog sistema'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X19003' AND name_sr_latin = 'Izvođenje dinamskih testova za ispitivanje nadbubrežnih žljezda';
-- X19005: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Ispitivanje endokrinog pankreasa'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X19005' AND name_sr_latin = 'Ispitivanje funkcije i grade muškog reproduktivnog sistema';
-- X19006: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Davanje insulinske terapije'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X19006' AND name_sr_latin = 'Ispitivanje endokrinog pankreasa';
-- H01026: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Dnevna seansa okupaciono - radne terapije u bolnici'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'H01026' AND name_sr_latin = 'Elektrošok u opštoj anesteziji i miorelaksaciji (bilateralni ili unilateralni)';
-- Z02021: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'CEA (Karcinoembrionalni antigen)'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'Z02021' AND name_sr_latin = 'Insulin';
-- X10008: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Obrada većih lacerokontuznih rana'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X10008' AND name_sr_latin = 'Obrada većih lezija kože suturom rane';
-- K03091: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Bakteriološko ispitivanje sadržaja drena - aerobno'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'K03091' AND name_sr_latin = 'Ispitivanje prisustva Echinococcus spp. - bojeni preparat';
-- K03095: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Ispitivanje prisustva Babesia spp. - bojeni preparat krvnog razmaza'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'K03095' AND name_sr_latin = 'Ispitivanje prisustva Cryptococcus spp. - kultivacija';
-- K03098: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Ispitivanje prisustva Cryptococcus spp. - tuš preparat'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'K03098' AND name_sr_latin = 'Ispitivanje prisustva krvnih i tkivnih parazita - bojeni preparat guste kapi';
-- K03118: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Anti Coxsackie B virus IgM antitijela - ELISA'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'K03118' AND name_sr_latin = 'Anti Coxiella burnetii IgA antitijela faza 2 - ELISA';
-- K03124: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Anti Hanta virus IgM antitijela - ELISA'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'K03124' AND name_sr_latin = 'Anti Echinococcus granulosus antitijela - indirektna hemaglutinacija';
-- K03130: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Anti Hepatitis C virus antitijela - IMUNO BLOT'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'K03130' AND name_sr_latin = 'Anti HBsAg antitijela - ELISA';
-- K03135: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Anti HIV 1 antitijela - potvrdni test - VESTERN BLOT'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'K03135' AND name_sr_latin = 'Anti Hepatitis E virus IgG antitijela - ELISA';
-- X07026: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Repozicija svježeg preloma nosnih kostiju sa imobilizacijom'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X07026' AND name_sr_latin = 'Instalacija lijeka kroz bubnu opnu u bubnu duplju';
-- X07028: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Laringofaringoskopija indirektna sa biopsijom'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X07028' AND name_sr_latin = 'Kateterizacija Eustahijeve tube';
-- X07038: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Epifaringoskopija direktna'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X07038' AND name_sr_latin = 'Akumetrijski ispitivanja sluha';
-- X07091: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Pozicioni test'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X07091' AND name_sr_latin = 'Vestibulokalorički testovi';
-- X07097: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Traženje simptoma fistule'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X07097' AND name_sr_latin = 'Repozicija svježeg preloma nosnih kostiju sa imobilizacijom';
-- X07098: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Instilacija lijeka kroz bubnu opnu u bubnu duplju'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X07098' AND name_sr_latin = 'Endoskopski pregled nosa';
-- X07102: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Kateterizacija Eustahijeve tube'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X07102' AND name_sr_latin = 'Laringofaringoskopija indirektna sa biopsijom';
-- X07112: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Elektrokohleografija odraslih'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X07112' AND name_sr_latin = 'Aspiraciona biopsija tankom iglom';
-- X07114: съехала строка целиком — имя и цены из X07116 (цена клиник = 2,5 × цена донора)
UPDATE medical_service_tariffs SET name_sr_latin = 'Ezofagoskopija sa biopsijom, odstranjivanjem tumora ili dilatacijom', price_eur = NULL, price_odjeljenje_eur = 23.4, price_ambulanta_eur = 50.04, price_operacija_eur = NULL, price_anestezija_eur = NULL, price_ukupno_eur = NULL
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X07114' AND name_sr_latin = 'Elektrokohleografija djece';
-- X07116: съехала строка целиком — имя и цены из X07118 (цена клиник = 2,5 × цена донора)
UPDATE medical_service_tariffs SET name_sr_latin = 'Osnovni fonijatrijski pregled', price_eur = NULL, price_odjeljenje_eur = 3.9, price_ambulanta_eur = 8.34, price_operacija_eur = NULL, price_anestezija_eur = NULL, price_ukupno_eur = NULL
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X07116' AND name_sr_latin = 'Ezofagoskopija sa biopsijom, odstranjenjem tumora ili dilatacijom';
-- X07119: съехала строка целиком — имя и цены из X07120 (цена клиник = 2,5 × цена донора)
UPDATE medical_service_tariffs SET name_sr_latin = 'Vježbe fonacije', price_eur = NULL, price_odjeljenje_eur = 6.5, price_ambulanta_eur = 13.9, price_operacija_eur = NULL, price_anestezija_eur = NULL, price_ukupno_eur = NULL
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X07119' AND name_sr_latin = 'Inicijalni fonijatrijski pregled';
-- X07125: съехала строка целиком — имя и цены из X07126 (цена клиник = 2,5 × цена донора)
UPDATE medical_service_tariffs SET name_sr_latin = 'Uvježbavanje ezofagusnog govora', price_eur = NULL, price_odjeljenje_eur = 3.9, price_ambulanta_eur = 8.34, price_operacija_eur = NULL, price_anestezija_eur = NULL, price_ukupno_eur = NULL
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X07125' AND name_sr_latin = 'Vježbe artikulacije';
-- X06007: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Ekstrakcija stranog tijela rožnjače sa siderozom (abrazija)'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X06007' AND name_sr_latin = 'Pregled fundusa biomikroskopom i Goldman-kupom sa 3 ogledala';
-- X06029: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Epilacija elektrolizom ili elektrokoagulacijom - seansa'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X06029' AND name_sr_latin = 'Eutiskopija u Cupersu i etapama';
-- X06030: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Eutiskopija po Cupersu u etapama'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X06030' AND name_sr_latin = 'Vježbe na koordinatoru';
-- X06031: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Vježbe na koordinatoru'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X06031' AND name_sr_latin = 'Vježbe u prostoru';
-- X06032: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Vježbe fuzije u prostoru'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X06032' AND name_sr_latin = 'Vježbe elastičnosti akomodacije - konvergencije kod akomodativnih strabizama';
-- X06033: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Vježbe elasticiteta akomodacije-konvergencije kod akomodativnih strabizama'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X06033' AND name_sr_latin = 'Pregled ortoraktorom i interpretacija nalaza svih funkcija';
-- X06034: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Pregled ortorajterom i interpretacija nalaza svih funkcija'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X06034' AND name_sr_latin = 'Egzoftalmometrija';
-- X06074: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Skijaskopija kod djece'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X06074' AND name_sr_latin = 'Ekzoftalmo chalazionis kod djece';
-- X06079: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Indirektna oftalmoskopija pomoću binokularnog oftalmoskopa'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X06079' AND name_sr_latin = 'OCT (optička koherentna tomografija)';
-- X06080: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'OCT (optička koherentna tomografija)'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X06080' AND name_sr_latin = 'Skijaskopija kod djece';
-- X04007: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Elektrokoagulacija cerviksa uterusa-površina po seansi (max. tri seanse)'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X04007' AND name_sr_latin = 'CTG-kardiotokografija u trudnoći';
-- X04010: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'CTG-kardiotokografija u trudnoći'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X04010' AND name_sr_latin = 'Amnioskopija u trudnoći';
-- X04061: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Histerometrija'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X04061' AND name_sr_latin = 'Elektrokoagulacija cerviksa uterusa-površina po seansi (max. tri seanse)';
-- X04065: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Uklanjanje tumora vaginalnog zida'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X04065' AND name_sr_latin = 'Uklanjanje vaginalnih septuma';
-- D02003: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Veća resekcija vene saphene externe i susjednih vena, unilateralna'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'D02003' AND name_sr_latin = 'Splenektomija obična ili kod traumatske rupture';
-- D02094: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Ekscizija komplikovane analne fistule'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'D02094' AND name_sr_latin = 'Laparoskopska eksploracija trbušne duplje';
-- D02216: съехала строка целиком — имя и цены из D02263 (цена клиник = 2,5 × цена донора)
UPDATE medical_service_tariffs SET name_sr_latin = 'Supraselektivna vagotomija-laparoskopska op.', price_eur = NULL, price_odjeljenje_eur = NULL, price_ambulanta_eur = NULL, price_operacija_eur = 130, price_anestezija_eur = 26, price_ukupno_eur = 156
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'D02216' AND name_sr_latin = 'Vađenje stranog tijela iz rektuma rektalnim putem (pomoću regionalne ili opšte anestezije)';
-- D02226: съехала строка целиком — имя и цены из D02266 (цена клиник = 2,5 × цена донора)
UPDATE medical_service_tariffs SET name_sr_latin = 'Transversokolektomija laparoskopska', price_eur = NULL, price_odjeljenje_eur = NULL, price_ambulanta_eur = NULL, price_operacija_eur = 156, price_anestezija_eur = 31.2, price_ukupno_eur = 187.2
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'D02226' AND name_sr_latin = 'Sutura srca kod povrede';
-- D02233: съехала строка целиком — имя и цены из D02234 (цена клиник = 2,5 × цена донора)
UPDATE medical_service_tariffs SET name_sr_latin = 'Lijeva lobektomija jetre-laparoskopska op.', price_eur = NULL, price_odjeljenje_eur = NULL, price_ambulanta_eur = NULL, price_operacija_eur = 195, price_anestezija_eur = 39, price_ukupno_eur = 234
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'D02233' AND name_sr_latin = 'Izvođenje derivacione stome kolona bez resekcije';
-- D02242: без клиник: OCR и донор согласны, цена из OCR
UPDATE medical_service_tariffs SET name_sr_latin = 'Cefalična duodenopankreatektomija (Whipplae) - laparoskopska'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'D02242' AND name_sr_latin = 'Desna lobektomija jetre-laparoskopska op.';
-- D03010: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Cistolitotomija bez resekcije vrata'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'D03010' AND name_sr_latin = 'Cistolitotomija (samo patrijak)';
-- D05032: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Amputacija noge kroz tibiju i fibulu'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'D05032' AND name_sr_latin = 'Fasciotomija, plantarna i/ili prsta subkutana';
-- D05033: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Fasciotomija, plantarna i/ili prsta subkutana'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'D05033' AND name_sr_latin = 'Tenoliza fleksora stopala, više (kroz isti rez)';
-- L01085: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Pregled totalne resekcije debelog crijeva'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'L01085' AND name_sr_latin = 'Resekovano crijevo kod Whipple-ove bolesti';
-- L01086: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Resekovano crijevo kod Whipple-ove bolesti'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'L01086' AND name_sr_latin = 'Pregled blok resekcije crijeva';
-- L01093: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Pregled biopsije pljuvačne žlijezde'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'L01093' AND name_sr_latin = 'Pregled tumora pljuvačnih žlijezda';
-- J06059: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Intravenozna cistografija'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'J06059' AND name_sr_latin = 'Cistografija (uretrocistografija) standardna';
-- J09025: без клиник: OCR и донор согласны, цена из OCR
UPDATE medical_service_tariffs SET name_sr_latin = 'MR toraksa/medijastinuma - bez kontrasta'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'J09025' AND name_sr_latin = 'MR dojke - sa kontrastom';
-- D23021: без клиник: OCR и донор согласны, цена из OCR
UPDATE medical_service_tariffs SET name_sr_latin = 'Mortalna amputacija'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'D23021' AND name_sr_latin = 'Mortalna ekstirpacija';
-- X01006: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Davanje kiseonika'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X01006' AND name_sr_latin = 'Davanje klizme za ispiranje';
-- X01010: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Inhalaciona terapija'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X01010' AND name_sr_latin = 'Tuberkulinsko testiranje';
-- X01011: съехала строка целиком — имя и цены из X01012 (цена клиник = 2,5 × цена донора)
UPDATE medical_service_tariffs SET name_sr_latin = 'Aspiraciona punkcija abscesa ili hematoma', price_eur = NULL, price_odjeljenje_eur = 1.95, price_ambulanta_eur = 4.17, price_operacija_eur = NULL, price_anestezija_eur = NULL, price_ukupno_eur = NULL
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X01011' AND name_sr_latin = 'Inhalaciona terapija';
-- X01012: съехала строка целиком — имя и цены из X01013 (цена клиник = 2,5 × цена донора)
UPDATE medical_service_tariffs SET name_sr_latin = 'Toaleta i održavanje stome', price_eur = NULL, price_odjeljenje_eur = 0.65, price_ambulanta_eur = 1.39, price_operacija_eur = NULL, price_anestezija_eur = NULL, price_ukupno_eur = NULL
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X01012' AND name_sr_latin = 'Aspiraciona punkcija abscesa ili hematoma';
-- X01013: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Toaleta vještačkog anusa'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X01013' AND name_sr_latin = 'Toaleta i održavanje stome';
-- X01014: съехала строка целиком — имя и цены из X01015 (цена клиник = 2,5 × цена донора)
UPDATE medical_service_tariffs SET name_sr_latin = 'Primarna obrada rane (bez šavova)', price_eur = NULL, price_odjeljenje_eur = 1.3, price_ambulanta_eur = 2.78, price_operacija_eur = NULL, price_anestezija_eur = NULL, price_ukupno_eur = NULL
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X01014' AND name_sr_latin = 'Toaleta vještačkog anusa';
-- X01015: съехала строка целиком — имя и цены из X01016 (цена клиник = 2,5 × цена донора)
UPDATE medical_service_tariffs SET name_sr_latin = 'Skidanje hirurških konaca', price_eur = NULL, price_odjeljenje_eur = 0.65, price_ambulanta_eur = 1.39, price_operacija_eur = NULL, price_anestezija_eur = NULL, price_ukupno_eur = NULL
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X01015' AND name_sr_latin = 'Primarna obrada rane (bez šavova)';
-- X01034: съехала строка целиком — имя и цены из X01035 (цена клиник = 2,5 × цена донора)
UPDATE medical_service_tariffs SET name_sr_latin = 'Određivanje glikemije glukometrom', price_eur = NULL, price_odjeljenje_eur = 0.65, price_ambulanta_eur = 1.39, price_operacija_eur = NULL, price_anestezija_eur = NULL, price_ukupno_eur = NULL
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X01034' AND name_sr_latin = 'Postavljanje kanile i uključivanje infuzije';
-- X01036: съехала строка целиком — имя и цены из X01038 (цена клиник = 2,5 × цена донора)
UPDATE medical_service_tariffs SET name_sr_latin = 'Punkciona biopsija štitne žlijezde', price_eur = NULL, price_odjeljenje_eur = 1.3, price_ambulanta_eur = 2.78, price_operacija_eur = NULL, price_anestezija_eur = NULL, price_ukupno_eur = NULL
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X01036' AND name_sr_latin = 'Kateterizacija mokraćne bešike kod muškarca sa ili bez ispiranja';
-- X01047: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Endotrahealna intubacija'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X01047' AND name_sr_latin = 'Hirurško zbrinjavanje uraslog nokta';
-- X01049: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Incizija i drenaža furunkula, karbunkula, zagnojenih cista, manjeg kožnog ili potkožnog abscesa, paronihije ili hematoma'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X01049' AND name_sr_latin = 'Punkcija u terapijske ili dijagnostičke svrhe';
-- X01050: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Punkcija zgloba u terapijske ili dijagnostičke svrhe'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X01050' AND name_sr_latin = 'Toaleta veće rane mokrim oblogama, jedan dnevno';
-- X01051: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Transfuzija krvi i krvnih derivata'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X01051' AND name_sr_latin = 'Lokalna anestezija - regionalna';
-- X01055: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Ishrana bolesnika preko sonde, jedan obrok'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X01055' AND name_sr_latin = 'Lokalna anestezija';
-- X01058: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Lokalna anestezija - manja'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X01058' AND name_sr_latin = 'Plasiranje/evakuacija nazogastrične ili orogastrične sonde sa ispiranjem';
-- X17005: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Testovi funkcije disanja - test višekratnog udaha'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X17005' AND name_sr_latin = 'Tjelesna pletismografija';
-- X17006: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Tjelesna pletismografija'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X17006' AND name_sr_latin = 'Test arterijsko-alveolarnog gradijenta CO2';
-- X17007: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Test arterijsko-alveolarnog gradijenta CO2'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X17007' AND name_sr_latin = 'Transbronhijalna punkcija';
-- X19002: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Izvođenje dinamskih testova za ispitivanje nadbubrežnih žljezda'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X19002' AND name_sr_latin = 'Izvođenje dinamskih testova HHN';
-- X19004: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Ispitivanje funkcije i građe muškog reproduktivnog sistema'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X19004' AND name_sr_latin = 'Ispitivanje funkcije i grade ženskog reproduktivnog sistema';
-- X10001: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Ekscizija malignih lezija kože suturom rane'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X10001' AND name_sr_latin = 'Ekscizija manjih lezija kože suturom rane';
-- X10006: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Ekscizija nokatne ploče sa matriksom'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X10006' AND name_sr_latin = 'Ekscizija nokatne ploče sa otklanjanjem mostova';
-- X10048: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Ekstirpacija hemangioma'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X10048' AND name_sr_latin = 'Ekstirpacija ksengioma';
-- X10051: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Incizija pljuvačne žlijezde ili kanala'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X10051' AND name_sr_latin = 'Ligatura pljuvačne žljezde ili kanala';
-- X10053: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Sklerozacija manjih hemangioma'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X10053' AND name_sr_latin = 'Sklerozaglajenje krvnih hemangioma';
-- X24002: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Torakoskopska biopsija pluća'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X24002' AND name_sr_latin = 'Torakoskopska biopsija pleure';
-- X11021: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Punkcija i evakuacija sadržaja hidrocele, funikulocele, spermatocele ili abscesne kolekcije'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X11021' AND name_sr_latin = 'Punkcija i evakuacija sadržaja hidrocele, varikokele, spermatocele ili abscesne kolekcije';
-- K03056: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Bakteriološko ispitivanje perikardijalne tečnosti - aerobno'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'K03056' AND name_sr_latin = 'Bakteriološko ispitivanje likvora - aerobno';
-- K03068: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Bakteriološko ispitivanje sinovijalne tečnosti - aerobno'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'K03068' AND name_sr_latin = 'Bakteriološko ispitivanje žuči - aerobno';
-- K03070: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Bakteriološko ispitivanje dijalizne tečnosti - aerobno'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'K03070' AND name_sr_latin = 'Bakteriološko ispitivanje dilatacione tečnosti - aerobno';
-- K03092: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Ispitivanje prisustva Echinococcus spp. - bojeni preparat'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'K03092' AND name_sr_latin = 'Ispitivanje prisustva Echinococcus spp. - nativni preparat';
-- K03093: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Ispitivanje prisustva Echinococcus spp. - nativni preparat'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'K03093' AND name_sr_latin = 'Ispitivanje prisustva Babesia spp. - bojeni preparat guste kapi';
-- K03094: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Ispitivanje prisustva Babesia spp. - bojeni preparat guste kapi'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'K03094' AND name_sr_latin = 'Ispitivanje prisustva Babesia spp. - bojeni preparat krvnog razmaza';
-- K03096: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Ispitivanje prisustva Cryptococcus spp. - kultivacija'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'K03096' AND name_sr_latin = 'Ispitivanje prisustva Cryptococcus spp. - bojeni preparat';
-- K03097: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Ispitivanje prisustva Cryptococcus spp. - bojeni preparat'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'K03097' AND name_sr_latin = 'Ispitivanje prisustva Cryptococcus spp. - tuš preparat';
-- K03126: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Anti HBc antitijela - ELISA'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'K03126' AND name_sr_latin = 'Anti Hanta virus IgG antitijela - ELISA';
-- K03128: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Anti HBeAg antitijela - ELISA'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'K03128' AND name_sr_latin = 'Anti HBc IgM antitijela - ELISA';
-- X07060: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Ekscizija benignih tumora jezika sa primarnom plastikom'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X07060' AND name_sr_latin = 'Ekscizija (biopsija) limfnog čvora vrata sa primarnom plastikom';
-- X07111: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Subjektivna olfaktometrija'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X07111' AND name_sr_latin = 'Subjektivna otitakonarrija';
-- X07113: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Elektrokohleografija djece'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X07113' AND name_sr_latin = 'Elektrokohleografija odraslih';
-- X07120: съехала строка целиком — имя и цены из X07125 (цена клиник = 2,5 × цена донора)
UPDATE medical_service_tariffs SET name_sr_latin = 'Vježbe artikulacije', price_eur = NULL, price_odjeljenje_eur = 7.8, price_ambulanta_eur = 16.68, price_operacija_eur = NULL, price_anestezija_eur = NULL, price_ukupno_eur = NULL
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X07120' AND name_sr_latin = 'Vježbe fonacije';
-- X06011: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Hirurški tretman hordeoluma, abscesa ili flegmone kapka ili obrve'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X06011' AND name_sr_latin = 'Hrvatski tetreni hordeolumi, abscesa ili flegmone kapka ili obrve';
-- X06057: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Određivanje refrakcije na široku zjenicu bez astigmatizma'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X06057' AND name_sr_latin = 'Određivanje naočara na usku zjenicu bez astigmatizma';
-- X06058: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Određivanje naočara na usku zjenicu bez astigmatizma'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X06058' AND name_sr_latin = 'Određivanje naočara na široku zjenicu bez astigmatizma';
-- X06094: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Vježbe vida, protiv supresije'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X06094' AND name_sr_latin = 'Vježbe vida, opšti supresije';
-- X04055: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Uklanjanje vaginalnih septuma'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X04055' AND name_sr_latin = 'Uklanjanje tumora vaginalnog zida';
-- X15001: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Spinalna anestezija/analgezija'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X15001' AND name_sr_latin = 'Specijalna anestezija/analgezija';
-- D02041: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Derivacija pseudociste pankreasa izdvojenom crijevnom vijugom'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'D02041' AND name_sr_latin = 'Derivacija pseudociste pankreasa izvođenjem crijevnom vijugom';
-- D02223: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Atipične resekcije jetre - laparoskopska op.'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'D02223' AND name_sr_latin = 'Atipične resekcije jetre unilateralno';
-- D02247: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Evakuacija hidatidne ciste abdominalnih organa izvan jetre'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'D02247' AND name_sr_latin = 'Laparoskopska evakuacija ciste abdominalnih organa izvan jetre';
-- K05034: без клиник: OCR и донор согласны, цена из OCR
UPDATE medical_service_tariffs SET name_sr_latin = 'Preparacija i citogenetička analiza: kultivisani limfociti fetalne krvi-tehnika G traka - 30 metafaza'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'K05034' AND name_sr_latin = 'Preparacija i citogenetička analiza: kultivisane ćelije fetalne krvi - tehnika G traka -30 metafaza';
-- D26097: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Resekcija i autovenski graft vene cave inferior'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'D26097' AND name_sr_latin = 'Resekcija i sintetski graft vene cave inferior';
-- D04068: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Miringoplastika, retroaurikularni pristup'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'D04068' AND name_sr_latin = 'Miringoplastika, transmeatalni pristup';
-- D05034: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Tenoliza fleksora stopala, više (kroz isti rez)'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'D05034' AND name_sr_latin = 'Tenoliza ekstenzora stopala, više (kroz isti rez)';
-- D05061: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Tenotomija ekstenzora šake i stopala'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'D05061' AND name_sr_latin = 'Tenotomija ekstenzora jedan ili više';
-- L01080: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Pregled totalne resekcije prostate'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'L01080' AND name_sr_latin = 'Pregled totalne resekcije želuca sa omentumom';
-- F01014: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Zbrinjavanje krvavljenja i šoka u porođaju'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'F01014' AND name_sr_latin = 'Zbrinjavanje rupture materice i šoka u porođaju';
-- F01027: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Zbrinjavanje rupture uterusa'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'F01027' AND name_sr_latin = 'Zbrinjavanje pukotine uterusa';
-- D23020: без клиник: OCR и донор согласны, цена из OCR
UPDATE medical_service_tariffs SET name_sr_latin = 'Mortalna ekstirpacija'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'D23020' AND name_sr_latin = 'Mortalna amputacija';
-- D23031: без клиник: OCR и донор согласны, цена из OCR
UPDATE medical_service_tariffs SET name_sr_latin = 'Brušenje zuba u terapeutske svrhe'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'D23031' AND name_sr_latin = 'Liječenje zuba u terapeutske svrhe';
-- X01070: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Terapija flebomat aparatom'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X01070' AND name_sr_latin = 'Terapija febrolnat aparatom';
-- X02038: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Ekscizija manjih benignih tumoroznih ožiljaka, fibroznih, cističnih kongenitalnih lezija kože, potkožnog tkiva sa direktnom suturom rane'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X02038' AND name_sr_latin = 'Ekscizija manjih benignih multiroznih ožiljaka, fibroznih, cističnih kongenitalnih lezija i sluznica, potkožnog tkiva sa direktnom suturom rane';
-- X17004: съехало только имя — цена клиник подтверждает цену тарифа
UPDATE medical_service_tariffs SET name_sr_latin = 'Testovi funkcije disanja - test jednokratnog udaha'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X17004' AND name_sr_latin = 'Testovi funkcije disanja - test višekratnog udaha';
-- X10044: вручную: OCR и прайс Данило; цена подтверждена клиниками (22,75 = 2,5 × 9,10)
UPDATE medical_service_tariffs SET name_sr_latin = 'Ekscizija i direktna sutura većih benignih lezija (ožiljastih, fibroznih, cističnih) kože, potkožnog tkiva'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X10044' AND name_sr_latin = 'Ekscizija dehiscentih sutura sekundarnim šavom (cijiljanih, fibroznih, dišljivih) kožih, potkožnog tkiva';
-- X06073: вручную: OCR и прайс Данило; цена подтверждена (32,50 = 2,5 × 13,00)
UPDATE medical_service_tariffs SET name_sr_latin = 'Excochleatio chalazionis kod djece'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X06073' AND name_sr_latin = 'Indirektna oftalmoskopija pomoću binokularnog oftalmoskopa';
-- D03003: вручную: OCR и прайс Данило; цена подтверждена (260 = 2,5 × 104)
UPDATE medical_service_tariffs SET name_sr_latin = 'Ureterolitotomija'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'D03003' AND name_sr_latin = 'Uretrofiksacija';
-- X01046: вручную: прайс Данило «DIJAGNOST ILI TERAP PUNKCIJA PERITON ŠUPLJINE SA UZIMANJ UZO», хвост OCR «…uzorka»; цена подтверждена (6,50 = 2,5 × 2,60)
UPDATE medical_service_tariffs SET name_sr_latin = 'Dijagnostička ili terapijska punkcija peritonealne šupljine sa uzimanjem uzorka'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X01046' AND name_sr_latin = 'Endotrahealna intubacija';
-- D05083: вручную: в FINAL скопировано имя D05082 (tarzalnih); OCR и Данило — metatarzalnih
UPDATE medical_service_tariffs SET name_sr_latin = 'Fraktura metatarzalnih kostiju - zatvorena ili otvorena (složena) repozicija sa ili bez unutrašnje ili spoljašnje fiksacije'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'D05083' AND name_sr_latin = 'Fraktura tarzalnih kostiju - zatvorena ili otvorena (složena) repozicija sa ili bez unutrašnje ili spoljašnje fiksacije';
-- D05114: вручную: OCR и Данило — «do jedne polovine»; «više od polovine» в FINAL — соседняя позиция
UPDATE medical_service_tariffs SET name_sr_latin = 'Fasciektomija, ekscizija do jedne polovine palmarne fascije uključujući vertikalne trake i digitalne produžetke'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'D05114' AND name_sr_latin = 'Fasciektomija, koja zahtijeva više od jedne polovine palmarne fascije uključujući vertikalne trake i digitalne procetke';
-- D05115: вручную: в FINAL обрезано на «unutrašnj»; полный текст по OCR
UPDATE medical_service_tariffs SET name_sr_latin = 'Suprakondilarna ili transkondilarna fraktura humerusa - zatvorena ili otvorena (složena) repozicija sa ili bez unutrašnje fiksacije klinom'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'D05115' AND name_sr_latin = 'Suprakondilarna ili transkondilarna fraktura humerusa - zatvorena ili otvorena (složena) repozicija sa ili bez unutrašnje ili spoljašnje fiksacije klinom';
-- J09020: вручную: OCR и Данило «MR PREGLED VRATA-BEZ KONTRASTA»; цену по клиникам проверить нечем — не трогаем
UPDATE medical_service_tariffs SET name_sr_latin = 'MR pregled vrata - bez kontrasta'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'J09020' AND name_sr_latin = 'MR hipofize - sa kontrastom';
-- X07115: вручную: съехала строка целиком: клиника 16,25 = 2,5 × 6,50, Данило 41,70 = 3 × 13,90
UPDATE medical_service_tariffs SET name_sr_latin = 'Retrogradna dilatacija jednjaka po Tucker-u', price_eur = NULL, price_odjeljenje_eur = 6.5, price_ambulanta_eur = 13.9, price_operacija_eur = NULL, price_anestezija_eur = NULL, price_ukupno_eur = NULL
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X07115' AND name_sr_latin = 'Hirurška ekstirpacija rinolita ili stranog tijela u kao lateralnom rinotomijom';
-- X07117: вручную: съехала строка целиком: клиника 4,88 = 2,5 × 1,95, Данило 12,51 = 3 × 4,17
UPDATE medical_service_tariffs SET name_sr_latin = 'Kontrolni fonijatrijski pregled', price_eur = NULL, price_odjeljenje_eur = 1.95, price_ambulanta_eur = 4.17, price_operacija_eur = NULL, price_anestezija_eur = NULL, price_ukupno_eur = NULL
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X07117' AND name_sr_latin = 'Retrogradna ezofagoskopija po Tucker-u';
-- X07118: вручную: съехала строка целиком: клиника 16,25 = 2,5 × 6,50, Данило 41,70 = 3 × 13,90
UPDATE medical_service_tariffs SET name_sr_latin = 'Fonijatrijske vježbe', price_eur = NULL, price_odjeljenje_eur = 6.5, price_ambulanta_eur = 13.9, price_operacija_eur = NULL, price_anestezija_eur = NULL, price_ukupno_eur = NULL
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X07118' AND name_sr_latin = 'Osnovni fonijatrijski pregled';
-- X15025: вручную: съехала строка целиком: клиника 32,50 = 2,5 × 13,00, Данило 83,40 = 3 × 27,80
UPDATE medical_service_tariffs SET name_sr_latin = 'Kombinovana spinalna i epiduralna anestezija', price_eur = NULL, price_odjeljenje_eur = 13, price_ambulanta_eur = 27.8, price_operacija_eur = NULL, price_anestezija_eur = NULL, price_ukupno_eur = NULL
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X15025' AND name_sr_latin = 'Kaudalna anestezija/analgezija';
-- X01032: вручную: съехала строка целиком: клиника 1,63 = 2,5 × 0,65, Данило 4,17 = 3 × 1,39
UPDATE medical_service_tariffs SET name_sr_latin = 'Kateterizacija mokraćne bešike kod žene sa ili bez ispiranja', price_eur = NULL, price_odjeljenje_eur = 0.65, price_ambulanta_eur = 1.39, price_operacija_eur = NULL, price_anestezija_eur = NULL, price_ukupno_eur = NULL
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X01032' AND name_sr_latin = 'Uzimanje sputuma za citološku analizu';
-- Y10012: вручную: в FINAL имя соседа Y10011 («od ramena do šake»); OCR и Данило — podlaktice; цены у позиции нет
UPDATE medical_service_tariffs SET name_sr_latin = 'Longeta podlaktice i šake ispod 10 godina'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'Y10012' AND name_sr_latin = 'Longeta od ramena do šake ispod 10 godina';
-- E09004: вручную: имена E09004/E09005 переставлены, цены чужие: OCR 8,34, Данило 25,02 = 3 × 8,34
UPDATE medical_service_tariffs SET name_sr_latin = 'Prvi pregled djeteta - dječiji nefrolog', price_eur = NULL, price_odjeljenje_eur = NULL, price_ambulanta_eur = 8.34, price_operacija_eur = NULL, price_anestezija_eur = NULL, price_ukupno_eur = NULL
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'E09004' AND name_sr_latin = 'Ponovni (kontrolni) pregled odojčeta - dječiji nefrolog';
-- E09005: вручную: имена E09004/E09005 переставлены, цены чужие: OCR 2,78, Данило 8,34 = 3 × 2,78
UPDATE medical_service_tariffs SET name_sr_latin = 'Ponovni (kontrolni) pregled odojčeta - dječiji nefrolog', price_eur = NULL, price_odjeljenje_eur = NULL, price_ambulanta_eur = 2.78, price_operacija_eur = NULL, price_anestezija_eur = NULL, price_ukupno_eur = NULL
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'E09005' AND name_sr_latin = 'Prvi pregled djeteta - dječiji nefrolog';
-- X07121: вручную: хвост сдвига блока X07: OCR «Artikulacioni tretman», клиника 16,25 = 2,5 × 6,50, Данило 41,70 = 3 × 13,90
UPDATE medical_service_tariffs SET name_sr_latin = 'Artikulacioni tretman', price_eur = NULL, price_odjeljenje_eur = 6.5, price_ambulanta_eur = 13.9, price_operacija_eur = NULL, price_anestezija_eur = NULL, price_ukupno_eur = NULL
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X07121' AND name_sr_latin = 'Artikulacioni pregled';
-- X07105: вручную: имя донора в БД с мусором («u kao»); прайс Данило «HIRUŠ EKSTIRP RINOL ILI STR TIJEL IZ NOSA LATER RINOTOMIJOM»; цена подтверждена клиниками
UPDATE medical_service_tariffs SET name_sr_latin = 'Hirurška ekstirpacija rinolita ili stranog tijela iz nosa lateralnom rinotomijom'
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X07105' AND name_sr_latin = 'Paracenteza bubne opne';

-- ═══ 2. PZZ-тарифы на чужих услугах ═══

-- A01001: вручную: по названию автомат выбрал соседа «u 2. godini»; «до 1 года» подтверждают и смысл, и коды ДЗ 80 (A01001) и 127 (MO_A01001)
UPDATE medical_service_tariffs SET medical_service_id = (SELECT id FROM medical_services WHERE slug = 'preventive-examination-up-to-age-1')
 WHERE tariff_source = 'fzocg-pzz' AND code = 'A01001' AND medical_service_id = (SELECT id FROM medical_services WHERE slug = 'first-anesthesiologist-examination') AND EXISTS (SELECT 1 FROM medical_services WHERE slug = 'preventive-examination-up-to-age-1');
-- H01005: PZZ-позиция не о «Individualna seansa kognitivno ili bihejvioralno baziranih psihoterapijskih tehnika» (сходство 0.30), подходящей услуги в каталоге нет — отвязываем
UPDATE medical_service_tariffs SET medical_service_id = NULL WHERE tariff_source = 'fzocg-pzz' AND code = 'H01005' AND medical_service_id = (SELECT id FROM medical_services WHERE slug = 'individual-cognitive-or-behavioral-psychotherapy-session');
-- H01006: PZZ-позиция не о «Dnevna seansa grupne psihoterapije pacijenata sa anksioznim, depresivnim ili psihotičnim poremećajem» (сходство 0.29); по названию это «Grupna psihoterapija psihodinamičkih i sociodinamičkih konflikata» (0.70)
UPDATE medical_service_tariffs SET medical_service_id = (SELECT id FROM medical_services WHERE slug = 'group-psychodynamic-and-sociodynamic-therapy')
 WHERE tariff_source = 'fzocg-pzz' AND code = 'H01006' AND medical_service_id = (SELECT id FROM medical_services WHERE slug = 'group-psychotherapy-session-for-anxiety-depression-or-psychotic-disorders') AND EXISTS (SELECT 1 FROM medical_services WHERE slug = 'group-psychodynamic-and-sociodynamic-therapy');
-- I01001: PZZ-позиция не о «Prvi pregled - infektolog» (сходство 0.28); по названию это «Preventivni pregled rizičnog neonatusa i odojčeta» (1.00)
UPDATE medical_service_tariffs SET medical_service_id = (SELECT id FROM medical_services WHERE slug = 'high-risk-neonate-and-infant-preventive-examination')
 WHERE tariff_source = 'fzocg-pzz' AND code = 'I01001' AND medical_service_id = (SELECT id FROM medical_services WHERE slug = 'first-infectious-disease-specialist-examination') AND EXISTS (SELECT 1 FROM medical_services WHERE slug = 'high-risk-neonate-and-infant-preventive-examination');
-- I01002: PZZ-позиция не о «Ponovni pregled - infektolog» (сходство 0.26); по названию это «Kontrolni preventivni pregled rizičnog neonatusa i odojčeta» (1.00)
UPDATE medical_service_tariffs SET medical_service_id = (SELECT id FROM medical_services WHERE slug = 'high-risk-neonate-and-infant-follow-up-examination')
 WHERE tariff_source = 'fzocg-pzz' AND code = 'I01002' AND medical_service_id = (SELECT id FROM medical_services WHERE slug = 'follow-up-infectious-disease-specialist-examination') AND EXISTS (SELECT 1 FROM medical_services WHERE slug = 'high-risk-neonate-and-infant-follow-up-examination');
-- J06001: PZZ-позиция не о «Rendgen glave (Kraniogram)» (сходство 0.00); по названию это «Snimanje skeleta lobanje i lica za svaki snimak» (1.00)
UPDATE medical_service_tariffs SET medical_service_id = (SELECT id FROM medical_services WHERE slug = 'skull-and-face-x-ray-per-image')
 WHERE tariff_source = 'fzocg-pzz' AND code = 'J06001' AND medical_service_id = (SELECT id FROM medical_services WHERE slug = 'x-ray-head-craniogram') AND EXISTS (SELECT 1 FROM medical_services WHERE slug = 'skull-and-face-x-ray-per-image');
-- L01001: вручную: смысл совпадает, формулировка короче порога; коды ДЗ 80 (HN_L01001) и 127 (MO_HN_L01001)
UPDATE medical_service_tariffs SET medical_service_id = (SELECT id FROM medical_services WHERE slug = 'newborn-and-family-home-patronage-visit')
 WHERE tariff_source = 'fzocg-pzz' AND code = 'L01001' AND medical_service_id = (SELECT id FROM medical_services WHERE slug = 'histopathology-of-appendectomy-specimen') AND EXISTS (SELECT 1 FROM medical_services WHERE slug = 'newborn-and-family-home-patronage-visit');
-- L01002: PZZ-позиция не о «Pregled endoskopske biopsije kolona» (сходство 0.07); по названию это «Patronažna posjeta djetetu u drugoj godini života» (0.88)
UPDATE medical_service_tariffs SET medical_service_id = (SELECT id FROM medical_services WHERE slug = 'home-patronage-visit-child-age-2')
 WHERE tariff_source = 'fzocg-pzz' AND code = 'L01002' AND medical_service_id = (SELECT id FROM medical_services WHERE slug = 'histopathology-of-colon-endoscopic-biopsy') AND EXISTS (SELECT 1 FROM medical_services WHERE slug = 'home-patronage-visit-child-age-2');
-- L01003: PZZ-позиция не о «Pregled biopsije usne (labium oris)» (сходство 0.00); по названию это «Patronažna posjeta djetetu u četvrtoj godini života» (0.89)
UPDATE medical_service_tariffs SET medical_service_id = (SELECT id FROM medical_services WHERE slug = 'home-patronage-visit-child-age-4')
 WHERE tariff_source = 'fzocg-pzz' AND code = 'L01003' AND medical_service_id = (SELECT id FROM medical_services WHERE slug = 'histopathology-of-lip-biopsy') AND EXISTS (SELECT 1 FROM medical_services WHERE slug = 'home-patronage-visit-child-age-4');
-- L01007: вручную: смысл совпадает; коды ДЗ 80 и 127 (HN_L01007)
UPDATE medical_service_tariffs SET medical_service_id = (SELECT id FROM medical_services WHERE slug = 'pregnancy-patronage-visit-birth-and-newborn-care-preparation')
 WHERE tariff_source = 'fzocg-pzz' AND code = 'L01007' AND medical_service_id = (SELECT id FROM medical_services WHERE slug = 'histopathology-of-hemorrhoidectomy-specimen') AND EXISTS (SELECT 1 FROM medical_services WHERE slug = 'pregnancy-patronage-visit-birth-and-newborn-care-preparation');
-- L01008: вручную: смысл совпадает; коды ДЗ 80 и 127 (HN_L01008)
UPDATE medical_service_tariffs SET medical_service_id = (SELECT id FROM medical_services WHERE slug = 'postpartum-patronage-visit')
 WHERE tariff_source = 'fzocg-pzz' AND code = 'L01008' AND medical_service_id = (SELECT id FROM medical_services WHERE slug = 'histopathology-of-colon-polyp-endoscopic-resection') AND EXISTS (SELECT 1 FROM medical_services WHERE slug = 'postpartum-patronage-visit');
-- L01009: PZZ-позиция не о «Pregled parcijalne resekcije želuca sa ulkusom» (сходство 0.07); по названию это «Patronažna posjeta ženama koje 3 godine nisu bile kod ginekologa» (0.86)
UPDATE medical_service_tariffs SET medical_service_id = (SELECT id FROM medical_services WHERE slug = 'patronage-visit-for-women-without-gynecological-visit-3-years')
 WHERE tariff_source = 'fzocg-pzz' AND code = 'L01009' AND medical_service_id = (SELECT id FROM medical_services WHERE slug = 'histopathology-of-partial-gastrectomy-with-ulcer') AND EXISTS (SELECT 1 FROM medical_services WHERE slug = 'patronage-visit-for-women-without-gynecological-visit-3-years');
-- L01012: вручную: смысл совпадает; коды ДЗ 80 и 127 (HN_L01012)
UPDATE medical_service_tariffs SET medical_service_id = (SELECT id FROM medical_services WHERE slug = 'senior-patronage-visit-over-65')
 WHERE tariff_source = 'fzocg-pzz' AND code = 'L01012' AND medical_service_id = (SELECT id FROM medical_services WHERE slug = 'histopathology-of-myoma') AND EXISTS (SELECT 1 FROM medical_services WHERE slug = 'senior-patronage-visit-over-65');
-- X01023: PZZ-позиция не о «Plasiranje nazogastrične sonde» (сходство 0.13); по названию это «Davanje metadona» (1.00)
UPDATE medical_service_tariffs SET medical_service_id = (SELECT id FROM medical_services WHERE slug = 'methadone-administration')
 WHERE tariff_source = 'fzocg-pzz' AND code = 'X01023' AND medical_service_id = (SELECT id FROM medical_services WHERE slug = 'nasogastric-tube-placement') AND EXISTS (SELECT 1 FROM medical_services WHERE slug = 'methadone-administration');
-- X01024: PZZ-позиция не о «Pregled, kontrola i previjanje nekomplikovane rane» (сходство 0.12); по названию это «Lokalno apliciranje lijeka vaginalete» (0.77)
UPDATE medical_service_tariffs SET medical_service_id = (SELECT id FROM medical_services WHERE slug = 'vaginal-suppository-application')
 WHERE tariff_source = 'fzocg-pzz' AND code = 'X01024' AND medical_service_id = (SELECT id FROM medical_services WHERE slug = 'uncomplicated-wound-examination-and-dressing') AND EXISTS (SELECT 1 FROM medical_services WHERE slug = 'vaginal-suppository-application');
-- X01025: PZZ-позиция не о «Ekstirpacija ili biopsija limfne žlijezde» (сходство 0.00); по названию это «Postavljanje IUD» (0.87) (intrauterine-device-insertion сливается в iud-insertion)
UPDATE medical_service_tariffs SET medical_service_id = (SELECT id FROM medical_services WHERE slug = 'iud-insertion')
 WHERE tariff_source = 'fzocg-pzz' AND code = 'X01025' AND medical_service_id = (SELECT id FROM medical_services WHERE slug = 'lymph-node-biopsy-or-excision') AND EXISTS (SELECT 1 FROM medical_services WHERE slug = 'iud-insertion');
-- X02003: PZZ-позиция не о «Incizija i drenaža većeg kožnog ili potkožnog apscesa, karbunkula, flegmone ili hematoma» (сходство 0.24); по названию это «Incizija apscesa» (0.81)
UPDATE medical_service_tariffs SET medical_service_id = (SELECT id FROM medical_services WHERE slug = 'abscess-incision')
 WHERE tariff_source = 'fzocg-pzz' AND code = 'X02003' AND medical_service_id = (SELECT id FROM medical_services WHERE slug = 'incision-and-drainage-of-larger-skin-or-subcutaneous-abscess-carbuncle-or-hematoma') AND EXISTS (SELECT 1 FROM medical_services WHERE slug = 'abscess-incision');

-- ═══ 3. Перенос строк клиник и тарифов по коду ═══

-- panoramic-x-ray → panoramic-dental-radiography, код J11001: panoramic-x-ray смешивал две позиции: частные «Ortopan snimak» за 20–45 € — это ОПТГ (J11003), а строки FZOCG J11001 «Panoramska dentalna radiografija» за ~3 € — другая позиция: у клиники 85 J11001 стоит 3,42 €, а J11003 — 27,36 €. Строки и тарифы J11001 переезжают на 7227, где этот код уже держат ДЗ 80 и 127.
SET @move_from = (SELECT id FROM medical_services WHERE slug = 'panoramic-x-ray');
SET @move_to = (SELECT id FROM medical_services WHERE slug = 'panoramic-dental-radiography');
UPDATE IGNORE clinic_medical_service_doctors d
  JOIN clinic_medical_services c ON c.clinic_id = d.clinic_id AND c.medical_service_id = d.medical_service_id
   SET d.medical_service_id = @move_to
 WHERE d.medical_service_id = @move_from AND c.code = 'J11001' AND @move_to IS NOT NULL;
UPDATE IGNORE clinic_medical_services SET medical_service_id = @move_to
 WHERE medical_service_id = @move_from AND code = 'J11001' AND @move_to IS NOT NULL;
UPDATE medical_service_tariffs SET medical_service_id = @move_to
 WHERE medical_service_id = @move_from AND code = 'J11001' AND @move_to IS NOT NULL;

-- ═══ 4. Слияния ═══

-- Процедура слияния — дословно из 030 (там же разобрано, что и в каком порядке она переносит).
DROP PROCEDURE IF EXISTS dedup_merge_medical_service;
DROP PROCEDURE IF EXISTS dedup_merge_medical_service_by_slug;

DELIMITER $$

CREATE PROCEDURE dedup_merge_medical_service(IN p_primary INT, IN p_secondary INT)
BEGIN
	-- Обе половинки на месте? Иначе слияние уже применяли.
	IF (SELECT COUNT(*) FROM medical_services WHERE id IN (p_primary, p_secondary)) = 2 THEN

		-- 1. Связи с клиниками, которых у основной услуги ещё нет
		INSERT IGNORE INTO clinic_medical_services
			(medical_service_id, clinic_id, price, price_min, price_max, code, is_price_outdated)
		SELECT p_primary, clinic_id, price, price_min, price_max, code, is_price_outdated
		  FROM clinic_medical_services
		 WHERE medical_service_id = p_secondary;

		-- 1.1 Клиника висела на обеих услугах — дозаполняем пустые поля основной.
		-- is_price_outdated присваивается ПЕРВЫМ: MySQL вычисляет SET слева
		-- направо, и после присвоения p.price условие уже не сработает.
		UPDATE clinic_medical_services p
		  JOIN clinic_medical_services s
		    ON s.clinic_id = p.clinic_id AND s.medical_service_id = p_secondary
		   SET p.is_price_outdated = CASE
		           WHEN p.price IS NULL AND s.price IS NOT NULL THEN s.is_price_outdated
		           ELSE p.is_price_outdated
		       END,
		       p.price     = COALESCE(p.price, s.price),
		       p.price_min = COALESCE(p.price_min, s.price_min),
		       p.price_max = COALESCE(p.price_max, s.price_max),
		       p.code      = COALESCE(p.code, s.code)
		 WHERE p.medical_service_id = p_primary;

		-- 2. Специальности
		INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
		SELECT p_primary, specialty_id
		  FROM medical_services_specialties
		 WHERE medical_service_id = p_secondary;

		-- 3. Категории
		INSERT IGNORE INTO medical_service_categories_relations
			(medical_service_id, medical_service_category_id)
		SELECT p_primary, medical_service_category_id
		  FROM medical_service_categories_relations
		 WHERE medical_service_id = p_secondary;

		-- 4. Врачи, оказывающие услугу в клинике
		INSERT IGNORE INTO clinic_medical_service_doctors
			(clinic_id, medical_service_id, doctor_id, price, price_max)
		SELECT clinic_id, p_primary, doctor_id, price, price_max
		  FROM clinic_medical_service_doctors
		 WHERE medical_service_id = p_secondary;

		-- 4.1 Справочный контент. На medical_service_id стоит UNIQUE, поэтому
		-- UPDATE IGNORE перенесёт справку только если у основной услуги её ещё
		-- нет; иначе она останется на дубликате и уйдёт по CASCADE.
		UPDATE IGNORE medical_service_reference_info
		   SET medical_service_id = p_primary
		 WHERE medical_service_id = p_secondary;

		-- 4.2 Тарифы ФЗОЦГ (FK стоит на SET NULL — без переноса коды молча
		-- отвязались бы от каталога)
		UPDATE medical_service_tariffs
		   SET medical_service_id = p_primary
		 WHERE medical_service_id = p_secondary;

		-- 4.3 Отзывы (FK стоит на CASCADE — без переноса удалились бы)
		UPDATE reviews
		   SET medical_service_id = p_primary
		 WHERE medical_service_id = p_secondary;

		-- 4.4 Синонимы дубликата
		UPDATE IGNORE medical_service_synonyms
		   SET medical_service_id = p_primary
		 WHERE medical_service_id = p_secondary;

		-- 4.5 Названия дубликата — в синонимы основной услуги.
		-- Совпало с названием основной — синоним не нужен.
		INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
		SELECT p_primary, TRIM(s.name_en), 'en'
		  FROM medical_services s JOIN medical_services p ON p.id = p_primary
		 WHERE s.id = p_secondary
		   AND TRIM(COALESCE(s.name_en, '')) NOT IN ('', TRIM(COALESCE(p.name_en, '')));

		INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
		SELECT p_primary, TRIM(s.name_sr), 'sr'
		  FROM medical_services s JOIN medical_services p ON p.id = p_primary
		 WHERE s.id = p_secondary
		   AND TRIM(COALESCE(s.name_sr, '')) NOT IN ('', TRIM(COALESCE(p.name_sr, '')));

		INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
		SELECT p_primary, TRIM(s.name_sr_cyrl), 'sr-cyrl'
		  FROM medical_services s JOIN medical_services p ON p.id = p_primary
		 WHERE s.id = p_secondary
		   AND TRIM(COALESCE(s.name_sr_cyrl, '')) NOT IN ('', TRIM(COALESCE(p.name_sr_cyrl, '')));

		INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
		SELECT p_primary, TRIM(s.name_ru), 'ru'
		  FROM medical_services s JOIN medical_services p ON p.id = p_primary
		 WHERE s.id = p_secondary
		   AND TRIM(COALESCE(s.name_ru, '')) NOT IN ('', TRIM(COALESCE(p.name_ru, '')));

		INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
		SELECT p_primary, TRIM(s.name_de), 'de'
		  FROM medical_services s JOIN medical_services p ON p.id = p_primary
		 WHERE s.id = p_secondary
		   AND TRIM(COALESCE(s.name_de, '')) NOT IN ('', TRIM(COALESCE(p.name_de, '')));

		INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
		SELECT p_primary, TRIM(s.name_tr), 'tr'
		  FROM medical_services s JOIN medical_services p ON p.id = p_primary
		 WHERE s.id = p_secondary
		   AND TRIM(COALESCE(s.name_tr, '')) NOT IN ('', TRIM(COALESCE(p.name_tr, '')));

		-- 5. Связи дубликата
		DELETE FROM clinic_medical_services WHERE medical_service_id = p_secondary;
		DELETE FROM medical_services_specialties WHERE medical_service_id = p_secondary;
		DELETE FROM medical_service_categories_relations WHERE medical_service_id = p_secondary;
		DELETE FROM clinic_medical_service_doctors WHERE medical_service_id = p_secondary;

		-- 6. Редиректы: сначала перецеливаем существующие, потом заводим новый
		UPDATE medical_service_redirects SET new_id = p_primary WHERE new_id = p_secondary;
		INSERT IGNORE INTO medical_service_redirects (old_id, new_id) VALUES (p_secondary, p_primary);

		-- 6.1 Слаг дубликата
		INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
		SELECT 'services', slug, p_primary
		  FROM medical_services
		 WHERE id = p_secondary AND slug IS NOT NULL AND slug <> '';

		-- 7. Удаляем дубликат
		DELETE FROM medical_services WHERE id = p_secondary;
	END IF;
END$$

-- Вызов по слагу: id на проде и локально могут не совпадать.
CREATE PROCEDURE dedup_merge_medical_service_by_slug(IN p_primary VARCHAR(280), IN p_secondary VARCHAR(280))
BEGIN
	DECLARE v_primary INT DEFAULT NULL;
	DECLARE v_secondary INT DEFAULT NULL;
	-- SET, а не SELECT … INTO: пустая выборка в INTO поднимает условие NOT FOUND
	SET v_primary = (SELECT id FROM medical_services WHERE slug = p_primary COLLATE utf8mb4_unicode_ci);
	SET v_secondary = (SELECT id FROM medical_services WHERE slug = p_secondary COLLATE utf8mb4_unicode_ci);
	IF v_primary IS NOT NULL AND v_secondary IS NOT NULL AND v_primary <> v_secondary THEN
		CALL dedup_merge_medical_service(v_primary, v_secondary);
	END IF;
END$$

DELIMITER ;

-- ручной лимфодренаж: PZZ M01002 и секундарный M02002 — одна процедура «Manuelna limfna drenaža»
CALL dedup_merge_medical_service_by_slug('lymphatic-drainage-complete', 'manual-lymphatic-drainage');
-- криотерапия: PZZ M01004 и секундарный M02004 — «Krioterapija i kriomasaža»
CALL dedup_merge_medical_service_by_slug('thermotherapy-cryotherapy', 'cryotherapy-and-cryomassage');
-- парафанго: PZZ M01007 и секундарный M02019 — «Parafin i fango terapija»
CALL dedup_merge_medical_service_by_slug('thermotherapy-parafango', 'paraffin-and-mud-therapy');
-- косыночная повязка (митела): одно средство иммобилизации, конфликта кодов нет
CALL dedup_merge_medical_service_by_slug('shoulder-sling-mitella', 'arm-sling-immobilization');
-- тотальное эндопротезирование колена = артропластика; клиника 131 висела на обеих без цены
CALL dedup_merge_medical_service_by_slug('total-knee-replacement', 'total-knee-arthroplasty');
-- УЗИ молочных желёз: ДЗ держали его в гинекологическом блоке (HN_GX03010) по той же цене, что и J07008
CALL dedup_merge_medical_service_by_slug('breast-ultrasound', 'breast-ultrasound-examination');
-- один код J07012 (у ДЗ 80 — HN_J07012)
CALL dedup_merge_medical_service_by_slug('blood-vessels-doppler', 'major-blood-vessels-doppler-ultrasound');
-- один код J07004 (у ДЗ — HN_J07004)
CALL dedup_merge_medical_service_by_slug('pediatric-hip-ultrasound', 'infant-hip-ultrasound');
-- пункционная биопсия щитовидной железы: X01036 по OCR и прайсу Данило — «Punkciona biopsija štitne žlijezde»; «пункция щитовидной железы» — она же
CALL dedup_merge_medical_service_by_slug('thyroid-biopsy', 'thyroid-puncture');
-- тонкоигольная биопсия щитовидной железы — та же пункционная биопсия X01036
CALL dedup_merge_medical_service_by_slug('thyroid-biopsy', 'thyroid-fine-needle-biopsy');
-- керамика на золоте — это металлокерамика на золотом сплаве; прошлый отказ (030) опирался на правило «разные материалы», а материал здесь один
CALL dedup_merge_medical_service_by_slug('metal-ceramic-crown-gold', 'ceramic-crown-on-gold');
-- ретроальвеолярный снимок = внутриротовой (у 1652 это уже синоним)
CALL dedup_merge_medical_service_by_slug('intraoral-x-ray', 'retroalveolar-radiography');
-- один код J11002 (у ДЗ — HN_J11002)
CALL dedup_merge_medical_service_by_slug('intraoral-x-ray', 'standard-intraoral-dental-radiograph');
-- ОПТГ J11003 «Ortopantomografski snimak» — после выноса J11001 (moves) panoramic-x-ray и есть ОПТГ; прошлый отказ снят, потому что снята причина — J11001 на 1678 больше нет
CALL dedup_merge_medical_service_by_slug('panoramic-x-ray', 'panoramic-jaw-x-ray');
-- ОПТГ, код J11003 у ДЗ 80 и 127
CALL dedup_merge_medical_service_by_slug('panoramic-x-ray', 'orthopantomography');
-- один код X02001 (у ДЗ — HN_TBCX02001)
CALL dedup_merge_medical_service_by_slug('prick-test-inhalation-allergens', 'inhalation-allergen-skin-prick-test');
-- операция при синдроме карпального канала = декомпрессия нерва в канале (D05011); клиника 131 висела на обеих
CALL dedup_merge_medical_service_by_slug('carpal-tunnel-surgery', 'carpal-tunnel-decompression');
-- один код J07009 (у ДЗ — HN_J07009)
CALL dedup_merge_medical_service_by_slug('doppler-neck-blood-vessels', 'carotid-doppler-ultrasound');
-- цветной допплер сонных артерий — то же исследование сосудов шеи; конфликта кодов нет
CALL dedup_merge_medical_service_by_slug('doppler-neck-blood-vessels', 'carotid-artery-color-doppler');
-- установка катетера = катетеризация мочевого пузыря; конфликта кодов нет
CALL dedup_merge_medical_service_by_slug('urinary-catheter-placement', 'bladder-catheterization');
-- промывание уха в прайсах клиник — это промывание от серы; клиники не пересекаются
CALL dedup_merge_medical_service_by_slug('cerumen-ear-irrigation', 'ear-irrigation');
-- один код X02013 (у ДЗ — HN_TBCX02013P)
CALL dedup_merge_medical_service_by_slug('pleural-puncture', 'diagnostic-pleural-puncture');
-- один код X02014 (у ДЗ — HN_TBCX02014)
CALL dedup_merge_medical_service_by_slug('thoracentesis', 'therapeutic-pleural-puncture');
-- название ДЗ — дословно FZOCG X02011 «Snimanje i čitanje spirometrije»; код ДЗ HN_X02012 сдвинут на единицу, как весь их блок X02
CALL dedup_merge_medical_service_by_slug('spirometry', 'spirometry-recording-and-reading');
-- один код и одно название: J06015 «Nativni snimak abdomena»
CALL dedup_merge_medical_service_by_slug('x-ray-abdomen-native', 'plain-abdominal-x-ray');
-- рентген бедра и рентген бедренной кости — одна кость; конфликта кодов нет, прошлый отказ снят
CALL dedup_merge_medical_service_by_slug('x-ray-thigh', 'x-ray-femur-thigh');
-- один код и одно название: J06013 «Nativni snimak urotrakta»
CALL dedup_merge_medical_service_by_slug('x-ray-urinary-tract-native', 'plain-urinary-tract-x-ray');
-- МРТ гипофиза; конфликта кодов нет
CALL dedup_merge_medical_service_by_slug('mri-pituitary-gland-sella-turcica', 'mri-pituitary-gland');
-- электрокардиоверсия; конфликта кодов нет
CALL dedup_merge_medical_service_by_slug('electric-cardioversion', 'cardiac-rhythm-cardioversion');
-- запись ЭКГ; код ДЗ HN_X02011 сдвинут на единицу (X02011 в PZZ — спирометрия), название — «Snimanje i očitavanje EKG-a»
CALL dedup_merge_medical_service_by_slug('ecg', 'ecg-recording-and-interpretation');
-- один код X14002
CALL dedup_merge_medical_service_by_slug('echocardiography-heart-ultrasound', 'echocardiography');
-- эргометрия всегда идёт с ЭКГ под нагрузкой; клиники не пересекаются, прошлый отказ снят
CALL dedup_merge_medical_service_by_slug('ergometry-stress-test', 'ergometry-ecg-stress-test');
-- один код X14008 (клиника 131)
CALL dedup_merge_medical_service_by_slug('holter-blood-pressure-24h', 'holter-blood-pressure-monitoring');
-- один код X14001 (клиника 131)
CALL dedup_merge_medical_service_by_slug('holter-ecg-24h', 'holter-ecg-monitoring');
-- один код X01010 (у ДЗ — HN_X01010)
CALL dedup_merge_medical_service_by_slug('inhalation-therapy', 'inhalation-administration');
-- внутрисуставное введение препарата; клиники не пересекаются
CALL dedup_merge_medical_service_by_slug('intra-articular-injection', 'local-joint-medication-injection');
-- внутримышечная инъекция; клиники не пересекаются
CALL dedup_merge_medical_service_by_slug('intramuscular-injection', 'intramuscular-medication-application');
-- внутривенное введение препарата; клиники не пересекаются
CALL dedup_merge_medical_service_by_slug('intravenous-medication-application', 'intravenous-injection-administration');
-- один код X01015 (у ДЗ — HN_X01015)
CALL dedup_merge_medical_service_by_slug('suture-removal', 'surgical-suture-removal');
-- кольпоскопия: PZZ X02016 «Kolposkopski pregled» и секундарный X04023 — одно название
CALL dedup_merge_medical_service_by_slug('colposcopy', 'colposcopy-examination');
-- КТГ; конфликта кодов нет
CALL dedup_merge_medical_service_by_slug('ctg-fetal-monitoring', 'cardiotocography-ctg');
-- установка ВМС; конфликта кодов нет
CALL dedup_merge_medical_service_by_slug('iud-insertion', 'intrauterine-device-insertion');
-- удаление ВМС; конфликта кодов нет
CALL dedup_merge_medical_service_by_slug('iud-removal', 'intrauterine-device-removal');
-- общий «Botox tretman» без зоны = инъекция ботокса; специализированные (гипергидроз, по зонам) остаются отдельно
CALL dedup_merge_medical_service_by_slug('botox-injection', 'botox-treatment');
-- гиалуроновый филлер
CALL dedup_merge_medical_service_by_slug('hyaluronic-acid-filler', 'hyaluronic-filler');
-- «вампирский лифтинг» — маркетинговое имя PRP-терапии лица
CALL dedup_merge_medical_service_by_slug('prp-facial-treatment', 'prp-vampire-facelift-own-plasma');

-- ═══ 5. Отказы — чтобы детектор дублей не поднимал эти пары снова ═══

-- ophthalmological-ultrasound ≠ ophthalmic-ultrasound-a-scan-and-b-scan: клиника 115 держит обе по разной цене (30 и 50 €) — обычное УЗИ глаза и A+B-скан
INSERT INTO medical_service_duplicate_candidates (service_id_a, service_id_b, tier, score, signals, status, decided_at)
SELECT LEAST(a.id, b.id), GREATEST(a.id, b.id), 'C', 0, 'manual:service-names-2026-09', 'dismissed', NOW()
  FROM medical_services a JOIN medical_services b ON a.slug = 'ophthalmological-ultrasound' AND b.slug = 'ophthalmic-ultrasound-a-scan-and-b-scan'
ON DUPLICATE KEY UPDATE status = 'dismissed', decided_at = NOW();
-- epigastric-hernia-operation ≠ epigastric-hernia-repair: клиники 88 и 137 держат обе с разными кодами (D02028 и D02189) и ценами
INSERT INTO medical_service_duplicate_candidates (service_id_a, service_id_b, tier, score, signals, status, decided_at)
SELECT LEAST(a.id, b.id), GREATEST(a.id, b.id), 'C', 0, 'manual:service-names-2026-09', 'dismissed', NOW()
  FROM medical_services a JOIN medical_services b ON a.slug = 'epigastric-hernia-operation' AND b.slug = 'epigastric-hernia-repair'
ON DUPLICATE KEY UPDATE status = 'dismissed', decided_at = NOW();
-- x-ray-chest-heart ≠ x-ray-chest-and-heart: клиники 88 и 137 держат обе: J06010 (телерентгенография сердца) и J06051 (лёгких и сердца)
INSERT INTO medical_service_duplicate_candidates (service_id_a, service_id_b, tier, score, signals, status, decided_at)
SELECT LEAST(a.id, b.id), GREATEST(a.id, b.id), 'C', 0, 'manual:service-names-2026-09', 'dismissed', NOW()
  FROM medical_services a JOIN medical_services b ON a.slug = 'x-ray-chest-heart' AND b.slug = 'x-ray-chest-and-heart'
ON DUPLICATE KEY UPDATE status = 'dismissed', decided_at = NOW();
-- mri-pelvic-organs ≠ mri-pelvis: клиника 137: J09017 (без контраста) на 3171, J09018 на 3812
INSERT INTO medical_service_duplicate_candidates (service_id_a, service_id_b, tier, score, signals, status, decided_at)
SELECT LEAST(a.id, b.id), GREATEST(a.id, b.id), 'C', 0, 'manual:service-names-2026-09', 'dismissed', NOW()
  FROM medical_services a JOIN medical_services b ON a.slug = 'mri-pelvic-organs' AND b.slug = 'mri-pelvis'
ON DUPLICATE KEY UPDATE status = 'dismissed', decided_at = NOW();
-- hysteroscopy-asherman-syndrome ≠ hysteroscopic-adhesiolysis: клиники 88 и 137: D01030 (диагностическая гистероскопия) и D01032 (адгезиолизис)
INSERT INTO medical_service_duplicate_candidates (service_id_a, service_id_b, tier, score, signals, status, decided_at)
SELECT LEAST(a.id, b.id), GREATEST(a.id, b.id), 'C', 0, 'manual:service-names-2026-09', 'dismissed', NOW()
  FROM medical_services a JOIN medical_services b ON a.slug = 'hysteroscopy-asherman-syndrome' AND b.slug = 'hysteroscopic-adhesiolysis'
ON DUPLICATE KEY UPDATE status = 'dismissed', decided_at = NOW();
-- venous-blood-draw ≠ venipuncture: клиники 88 и 137: Z04001 (забор крови) и X12033 (венопункция в трансфузиологии)
INSERT INTO medical_service_duplicate_candidates (service_id_a, service_id_b, tier, score, signals, status, decided_at)
SELECT LEAST(a.id, b.id), GREATEST(a.id, b.id), 'C', 0, 'manual:service-names-2026-09', 'dismissed', NOW()
  FROM medical_services a JOIN medical_services b ON a.slug = 'venous-blood-draw' AND b.slug = 'venipuncture'
ON DUPLICATE KEY UPDATE status = 'dismissed', decided_at = NOW();
-- stoma-care ≠ artificial-anus-care: клиники 88 и 137: X01012 (стома) и X01013 (искусственный анус)
INSERT INTO medical_service_duplicate_candidates (service_id_a, service_id_b, tier, score, signals, status, decided_at)
SELECT LEAST(a.id, b.id), GREATEST(a.id, b.id), 'C', 0, 'manual:service-names-2026-09', 'dismissed', NOW()
  FROM medical_services a JOIN medical_services b ON a.slug = 'stoma-care' AND b.slug = 'artificial-anus-care'
ON DUPLICATE KEY UPDATE status = 'dismissed', decided_at = NOW();
-- medical-certificate-for-general-work ≠ pre-employment-medical-certificate: клиника 126 держит обе по разной цене (35 и 20 €)
INSERT INTO medical_service_duplicate_candidates (service_id_a, service_id_b, tier, score, signals, status, decided_at)
SELECT LEAST(a.id, b.id), GREATEST(a.id, b.id), 'C', 0, 'manual:service-names-2026-09', 'dismissed', NOW()
  FROM medical_services a JOIN medical_services b ON a.slug = 'medical-certificate-for-general-work' AND b.slug = 'pre-employment-medical-certificate'
ON DUPLICATE KEY UPDATE status = 'dismissed', decided_at = NOW();
-- bone-augmentation-biooss ≠ bone-augmentation: Bio-Oss — конкретный материал; общая аугментация может быть на другом
INSERT INTO medical_service_duplicate_candidates (service_id_a, service_id_b, tier, score, signals, status, decided_at)
SELECT LEAST(a.id, b.id), GREATEST(a.id, b.id), 'C', 0, 'manual:service-names-2026-09', 'dismissed', NOW()
  FROM medical_services a JOIN medical_services b ON a.slug = 'bone-augmentation-biooss' AND b.slug = 'bone-augmentation'
ON DUPLICATE KEY UPDATE status = 'dismissed', decided_at = NOW();
-- sinus-lift-with-augmentation ≠ dental-sinus-lift: клиника 117 держит обе
INSERT INTO medical_service_duplicate_candidates (service_id_a, service_id_b, tier, score, signals, status, decided_at)
SELECT LEAST(a.id, b.id), GREATEST(a.id, b.id), 'C', 0, 'manual:service-names-2026-09', 'dismissed', NOW()
  FROM medical_services a JOIN medical_services b ON a.slug = 'sinus-lift-with-augmentation' AND b.slug = 'dental-sinus-lift'
ON DUPLICATE KEY UPDATE status = 'dismissed', decided_at = NOW();
-- aesthetic-nose-and-septum-correction ≠ septorhinoplasty: эстетическая коррекция (3000 €, частная) против функциональной септоринопластики FZOCG (130 €)
INSERT INTO medical_service_duplicate_candidates (service_id_a, service_id_b, tier, score, signals, status, decided_at)
SELECT LEAST(a.id, b.id), GREATEST(a.id, b.id), 'C', 0, 'manual:service-names-2026-09', 'dismissed', NOW()
  FROM medical_services a JOIN medical_services b ON a.slug = 'aesthetic-nose-and-septum-correction' AND b.slug = 'septorhinoplasty'
ON DUPLICATE KEY UPDATE status = 'dismissed', decided_at = NOW();

-- ═══ 6. Синонимы, совпавшие с собственным названием после слияний (как 031) ═══

DELETE syn FROM medical_service_synonyms syn
  JOIN medical_services m ON m.id = syn.medical_service_id
 WHERE syn.another_name COLLATE utf8mb4_unicode_ci = CASE syn.language
           WHEN 'en' THEN m.name_en
           WHEN 'sr' THEN m.name_sr
           WHEN 'sr-cyrl' THEN m.name_sr_cyrl
           WHEN 'ru' THEN m.name_ru
           WHEN 'de' THEN m.name_de
           WHEN 'tr' THEN m.name_tr
           ELSE NULL
       END;

DROP PROCEDURE IF EXISTS dedup_merge_medical_service_by_slug;
DROP PROCEDURE IF EXISTS dedup_merge_medical_service;

