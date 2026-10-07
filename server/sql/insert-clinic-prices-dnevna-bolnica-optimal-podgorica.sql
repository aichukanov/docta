SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Dnevna bolnica Optimal (Podgorica) — цены к заведённым услугам + 1 услуга и
-- 8 анализов из того же прайса.
--
-- Источник: https://optimalmed.me/wp-content/uploads/2016/02/Cjenovnik.pdf
--   «Cjenovnik usluga», 2 страницы (dijagnostika / operacije). Снимок:
--   data/clinic-pricelists/sources/dnevna-bolnica-optimal-podgorica/2026-10-02.pdf
--   (sha256 a03983a32ca9ed11f8fb5adafea41fcffd8b5e5eaa2dacce6c983419fa772238).
-- Срез: 2026-10-02.
--
-- СТАРЫЙ ПРАЙС. Дата: CreationDate PDF 2016-02-19, Last-Modified 2016-02-24.
--   is_price_outdated = 1 на все строки с ценой > 0 — решение юзера 2026-10-02.
--   За устаревание: сайт не обновляется с 2016 (RSS lastBuildDate 2016-04-12),
--   страница /cjenovnik/ убрана из меню, диагностика на 25–50% дешевле частных
--   коллег каталога (Jovović, Milmedika). Против: скрытая /cjenovnik/ всё ещё
--   ссылается на этот PDF, другого прайса нет нигде (Wayback тоже), осмотр 50 €
--   на уровне рынка, часть операций дороже рынка. Доводы подробно —
--   openQuestions в data/clinic-imports/dnevna-bolnica-optimal-podgorica.json.
--   Две позиции по 0.00 € флаг не получают: «0 € + X%» не имеет смысла.
--
-- Сводка: в PDF 70 строк с ценой = 68 позиций (ISPIRANJE SUZNIH KANALIĆA и
--   UKLANJANJE STRANOG TIJELA IZ ROZNJAČE повторены на второй странице с той же
--   ценой). У клиники 69 услуг, все без цены (локально и на проде, id 25).
--   1. Совпало 66 → цены.
--   2. PREGLED INTERNISTE 30 € → новая связь с internist-examination.
--   3. LABORATORIJSKE ANALIZE (KKS, SE, GLIKEMIJA, UREA, NA, K, VRIJ.KRVARENJA
--      I VRIJ.KOAGULACIJE) 20 € — одна цена на весь набор, поштучных нет →
--      8 анализов без цены (price NULL).
--   Без пары у нас 3 услуги, остаются без цены: Anti-VEGF Injection, Selective
--   Laser Trabeculoplasty SLT, Cataract Surgery Complicated Case.
--   Новых записей каталога нет. Кодов в прайсе нет.
--
-- Сопоставление построчно — data/clinic-imports/dnevna-bolnica-optimal-podgorica.json.
-- Правки цен — с условием «цены ещё нет», вставки — INSERT IGNORE: повторный
-- прогон ничего не меняет, ручные правки не перезаписываются.
--
-- Клиника и записи каталога — по slug (id локально и на проде расходятся).

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'dnevna-bolnica-optimal-podgorica');

-- ═══ 1. Цены к заведённым услугам ═══

-- ─── Страница 1 — dijagnostika ───

-- «OPŠTI OFTALMOLOŠKI PREGLED (ARK,VOU,IOP,SPALT,PAHIMETRIJA)» 50.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'comprehensive-ophthalmological-examination'
   SET r.price = 50.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «KONTROLNI PREGLED» 15.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'follow-up-ophthalmological-examination'
   SET r.price = 15.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «IOL MASTER» 15.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'iol-master-biometry'
   SET r.price = 15.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «BIOMETRIJA ( A-SCAN )» 15.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'a-scan-biometry'
   SET r.price = 15.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «ULTRAZVUK OKA ( B-SCAN )» 15.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'b-scan-ocular-ultrasound'
   SET r.price = 15.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «OCT -OPTIČKA KOHERENTNA TOMOGRAFIJA» 50.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'optical-coherence-tomography-oct'
   SET r.price = 50.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «KOMPJUTERIZOVANO VIDNO POLJE (JEDNO OKO)» 15.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'visual-field-test-single-eye'
   SET r.price = 15.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «KOMPJUTERIZOVANO VIDNO POLJE (OBA OKA)» 25.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'visual-field-test-both-eyes'
   SET r.price = 25.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «FLUORESCEINSKA ANGIOGRAFIJA» 65.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'fluorescein-angiography'
   SET r.price = 65.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «FOTOGRAFIJA FUNDUSA» 15.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'fundus-photography'
   SET r.price = 15.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «KOMPLETNI KOMPJUTERIZOVANI PREGLED ROŽNJAČE "SIRIUS"» 20.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'corneal-topography-sirius'
   SET r.price = 20.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «PANRETINALNA LASER FOTOKOAGULACIJA MREŽNJAČE-JEDNO OKO» 260.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'panretinal-laser-photocoagulation-single-eye'
   SET r.price = 260.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «LASER FOTOKOAGULACIJA MREŽNJAČE - JEDNO OKO» 100.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'focal-laser-photocoagulation-single-eye'
   SET r.price = 100.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «DOPUNSKA LASER FOTOKOAGULACIJA» 50.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'additional-laser-photocoagulation'
   SET r.price = 50.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «LASER TRABEKULOPLASTIKA (LASER ZA LIJEČENJE GLAUKOMA)» 100.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'laser-trabeculoplasty'
   SET r.price = 100.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «ND YAG LASER CAPSULOTOMIJA» 80.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'ndyag-laser-capsulotomy'
   SET r.price = 80.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «ND YAG LASER IRIDOTOMIJA» 100.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'ndyag-laser-iridotomy'
   SET r.price = 100.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «GONIOPLASTIKA» 100.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'gonioplasty'
   SET r.price = 100.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «GONIOPUNKTURA» 50.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'goniopuncture'
   SET r.price = 50.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «LASERSKA STIMULACIJA MAKULE-(5 SEANSA)» 70.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'macular-laser-stimulation-5-sessions'
   SET r.price = 70.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «APLIKACIJA PARAOKULARNE INJEKCIJE» 12.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'paraocular-injection'
   SET r.price = 12.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «TOALETA KAPAKA» 10.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'eyelid-hygiene-care'
   SET r.price = 10.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «ISPIRANJE SUZNIH KANALIĆA» 15.00 € (на обеих страницах, на второй «15,00 €»)
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'lacrimal-duct-irrigation'
   SET r.price = 15.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «UKLANJANJE STRANOG TIJELA IZ ROZNJAČE» 20.00 € (на обеих страницах, на второй «20,00 €»)
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'foreign-body-removal-eye'
   SET r.price = 20.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «LIJEČENJE HALACIONA INJEKCIJAMA» 30.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'chalazion-injection-treatment'
   SET r.price = 30.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «ŠIRMEROV TEST» 6.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'dry-eye-test-schirmer'
   SET r.price = 6.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «KONTROLNI POSTOPERATIVNI PREGLED U MJESECU NAKON OPERACIJE» 10.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'postoperative-follow-up-first-month'
   SET r.price = 10.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «KONTROLA LIJEČENJA U MJESECU NAKON PRVOG PREGLEDA» 10.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'treatment-follow-up-first-month'
   SET r.price = 10.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «PREDOPERATIVNA PRIPREMA (PREGLED INTERNISTE I LABORATORIJSKE ANALIZE)» 52.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'preoperative-examination-package'
   SET r.price = 52.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «PREDOPERATIVNA PRIPREMA ZA REFRAKTIVNU HIRURGIJU (KKS, SE )» 6.50 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'preoperative-examination-for-refractive-surgery'
   SET r.price = 6.50
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «PRVI KONTROLNI POSTOPERATIVNI PREGLED» 0.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'first-postoperative-follow-up'
   SET r.price = 0.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «PRVI KONTROLNI PREGLED NAKON POČETKA LIJEČENJA» 0.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'first-treatment-follow-up'
   SET r.price = 0.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- ─── Страница 2 — operacije ───

-- «EXIMER-LASERSKO SKIDANJE DIOPTRIJE (JEDNO OKO) - LASIK» 790.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'lasik-single-eye'
   SET r.price = 790.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «EXIMER-LASERSKO SKIDANJE DIOPTRIJE (OBA OKA) - LASIK» 1550.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'lasik-both-eyes'
   SET r.price = 1550.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «EXIMER-LASERSKO SKIDANJE DIOPTRIJE (JEDNO OKO) - SUPERLASIK» 800.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'superlasik-single-eye'
   SET r.price = 800.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «EXIMER-LASERSKO SKIDANJE DIOPTRIJE (JEDNO OKO) - PRK» 400.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'prk-single-eye'
   SET r.price = 400.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «IMPLANTACIJA INTRAKORNEALNIH SEGMENATA KOD KERATOKONUSA» 1100.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'intracorneal-ring-segments-keratoconus'
   SET r.price = 1100.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «LIMBALNE RELAKSIRAJUĆE INCIZIJE (LRI)» 300.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'limbal-relaxing-incisions-lri'
   SET r.price = 300.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «UKLANJANJE KATARAKTE SA UGRADNJOM STANDARDNOG SOČIVA» 990.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'cataract-surgery-with-standard-iol'
   SET r.price = 990.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «UKLANJANJE KATARAKTE SA UGRADNJOM TORIČNOG, IQ SOČIVA» 1250.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'cataract-surgery-with-toric-iq-iol'
   SET r.price = 1250.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «UKLANJANJE KATARAKTE SA UGRADNJOM MULTIFOKALNOG SOČIVA» 1590.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'cataract-surgery-with-multifocal-iol'
   SET r.price = 1590.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «ZAMJENA INTRAOKULARNOG SOČIVA» 1100.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'intraocular-lens-exchange'
   SET r.price = 1100.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «SEKUNDARNA IMPLANTACIJA IOL-A» 800.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'secondary-iol-implantation'
   SET r.price = 800.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «FAKOEMULZIFIKACIJA I TRABEKULEKTOMIJA» 1500.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'phacoemulsification-with-trabeculectomy'
   SET r.price = 1500.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «TRABEKULEKTOMIJA» 1200.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'trabeculectomy'
   SET r.price = 1200.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «GLAUKOM BEZ PENETRACIJE-DUBOKA SKLEROTOMIJA» 1300.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'deep-sclerectomy-non-penetrating-glaucoma'
   SET r.price = 1300.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «TRABEKULEKTOMIJA SA IMPLANTOM» 1400.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'trabeculectomy-with-implant'
   SET r.price = 1400.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «CYCLOCRIO APLIKACIJA» 500.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'cyclocryotherapy'
   SET r.price = 500.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «INTRAVITREALNA INJEKCIJA LUCENTIS» 800.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'intravitreal-anti-vegf-injection-lucentis'
   SET r.price = 800.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «VITREKTOMIJA I KATEGORIJE» 1800.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'vitrectomy-category-i'
   SET r.price = 1800.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «VITREKTOMIJA II KATEGORIJE» 2200.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'vitrectomy-category-ii'
   SET r.price = 2200.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «VITREKTOMIJA III KATEGORIJE» 3000.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'vitrectomy-category-iii'
   SET r.price = 3000.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «ZAMJENA SILIKONSKOG ULJA» 1200.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'silicone-oil-exchange'
   SET r.price = 1200.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «EVAKUACIJA SILIKONSKOG ULJA» 800.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'silicone-oil-removal'
   SET r.price = 800.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «EPISKLERALNA OPERACIJA ABLACIJE MREŽNJAČE» 1500.00 € (напечатано «1.500.00 €»)
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'episcleral-retinal-detachment-surgery'
   SET r.price = 1500.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «UKLANJANJE HALACIONA» 100.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'chalazion-removal-local-anesthesia'
   SET r.price = 100.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «UKLANJANJE PTERIGIJUMA» 200.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'pterygium-removal'
   SET r.price = 200.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «UKLANJANJE PTERIGIJUMA SA KALEMOM KONJUNKTIVE» 400.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'pterygium-removal-with-conjunctival-graft'
   SET r.price = 400.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «KOREKCIJA KAPKA» 300.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'eyelid-correction-surgery'
   SET r.price = 300.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «MALI HIRURŠKI ZAHVAT» 115.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'minor-ophthalmic-surgical-procedure'
   SET r.price = 115.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «UKLANJANJE TUMORA KAPKA I KONJUNKTIVE» 200.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'eyelid-tumor-surgical-removal'
   SET r.price = 200.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «OPERACIJA STRABIZMA» 890.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'strabismus-surgery'
   SET r.price = 890.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «REVIZIJA PROSTORA STAKLASTOG TIJELA» 500.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'vitreous-cavity-revision'
   SET r.price = 500.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «OPŠTA ANESTEZIJA» 200.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'general-iv-anesthesia'
   SET r.price = 200.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «DOPLATA ZA IMPLANTACIJU SOČIVA ACRYSOF IQ» 300.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'acrysof-iq-iol-surcharge'
   SET r.price = 300.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «DOPLATA ZA IMPLANTACIJU MULTIFOKALNOG SOČIVA» 700.00 €
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'multifocal-iol-surcharge'
   SET r.price = 700.00
 WHERE r.clinic_id = @clinic_id
   AND r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- ═══ 2. Новая услуга клиники ═══

-- «PREGLED INTERNISTE» 30.00 € (dijagnostika) — отдельной строкой. Он же входит в пакет
-- «Predoperativna priprema (pregled interniste i laboratorijske analize)» 52 €.
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price)
SELECT @clinic_id, e.id, 30.00
  FROM medical_services e
 WHERE e.slug = 'internist-examination' AND @clinic_id IS NOT NULL;

-- ═══ 3. Анализы — без цены ═══

-- «LABORATORIJSKE ANALIZE (KKS, SE, GLIKEMIJA ,UREA, NA, K, VRIJ.KRVARENJA I
-- VRIJ.KOAGULACIJE)» 20.00 € (dijagnostika) — цена на весь набор, поштучно не
-- указана, поэтому price NULL.
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id)
SELECT @clinic_id, e.id
  FROM lab_tests e
 WHERE e.slug IN (
		'complete-blood-count', -- KKS
		'erythrocyte-sedimentation-rate', -- SE
		'glucose', -- GLIKEMIJA
		'urea', -- UREA
		'sodium', -- NA
		'potassium', -- K
		'bleeding-time', -- VRIJ.KRVARENJA
		'coagulation-time'  -- VRIJ.KOAGULACIJE
	) AND @clinic_id IS NOT NULL;

-- ═══ 4. Флаг устаревших цен (решение юзера 2026-10-02) ═══

UPDATE clinic_medical_services r
   SET r.is_price_outdated = 1
 WHERE r.clinic_id = @clinic_id AND r.price > 0 AND r.is_price_outdated = 0;

-- ═══ VERIFICATION ═══

-- Ожидается: total 70, priced 67, unpriced 3, outdated 65 (две позиции
-- по 0.00 € без флага), obsolete 0.
SELECT COUNT(*) AS total,
       SUM(r.price IS NOT NULL) AS priced,
       SUM(r.price IS NULL AND r.price_min IS NULL) AS unpriced,
       SUM(r.is_price_outdated = 1) AS outdated,
       SUM(r.is_obsolete = 1) AS obsolete
  FROM clinic_medical_services r
 WHERE r.clinic_id = @clinic_id;

-- Ожидается 3 строки: anti-vegf-injection, cataract-surgery-complicated-case,
-- selective-laser-trabeculoplasty-slt.
SELECT e.slug, e.name_en
  FROM clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id
 WHERE r.clinic_id = @clinic_id AND r.price IS NULL
 ORDER BY e.slug;

-- Сумма цен для сверки: 33186.50.
SELECT SUM(r.price) AS price_sum
  FROM clinic_medical_services r
 WHERE r.clinic_id = @clinic_id;

-- Ожидается 8 строк, все price NULL.
SELECT e.slug, r.price
  FROM clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id
 WHERE r.clinic_id = @clinic_id
 ORDER BY e.slug;

SELECT e.slug, r.price, r.is_price_outdated
  FROM clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id
 WHERE r.clinic_id = @clinic_id
 ORDER BY r.price DESC, e.slug;
