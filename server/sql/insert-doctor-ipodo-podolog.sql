-- Подолог клиники iPODO (clinic 143, Budva / Dukley Gardens)
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-doctor-ipodo-podolog.sql
--
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-ipodo.sql уже применён (клиника 143 существует).
--
-- ИМЯ
-- Настоящее имя: Журавлёва Анюта Геннадьевна. «Anyta Prizer Europa» —
-- профессиональный псевдоним клиники; в поле имени он не используется,
-- потому что «Prizer Europa» = «призёр Европы», а поле имени уходит в
-- `doctors.slug`, <title>, хлебные крошки и schema.org Person, где заявление
-- уже не пометить как чужие слова. Регалии — в описании, с оговоркой.
--
-- Формат по конвенции каталога (сверено по 1317 записям в `doctors`):
--   name_ru      — «Фамилия Имя Отчество», отчество сохраняется
--   name_sr      — «Prezime Ime» латиницей, БЕЗ отчества (Воробьева → Vorobjeva)
--   name_sr_cyrl — то же сербской кириллицей (лё → љо, ю → ју)
--   name_en      — английская транслитерация (Дубровская → Dubrovskaya)
--   slug         — generateSlug(name_sr)
-- Слаг после публикации менять только через `doctor_redirects` (301).

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

SET @doctor_slug     = 'zuravljova-anjuta';
SET @doctor_name_sr  = 'Žuravljova Anjuta';
SET @doctor_name_cyr = 'Журављова Ањута';
SET @doctor_name_ru  = 'Журавлёва Анюта Геннадьевна';
SET @doctor_name_en  = 'Zhuravlyova Anyta';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJZZCl95fVTRMReLlhoR499pY' LIMIT 1);
SET @spec_podiatry = 85;
SET @lang_sr = 1;
SET @lang_ru = 2;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: DOCTOR
-- ═══════════════════════════════════════════════════════════════
-- professional_title пустой: подолог — не врач. Та же конвенция, что у
-- физиотерапевтов (специальность 94) и логопедов (70).
--
-- В описание НЕ вошло из присланного текста, как непроверяемое:
--   «самый известный подолог Черногории», «более 100 000 положительных
--   динамик», «доверие тысяч клиентов», «безупречная репутация»,
--   «трендсеттер», «не имеющий аналогов».
-- Соревновательные регалии и сертификаты брендов (Ez Flow ibd, KART)
-- оставлены, но помечены как заявления клиники и не выданы за медицинскую
-- квалификацию.

SET @doctor_id = (SELECT id FROM doctors WHERE slug = @doctor_slug LIMIT 1);

INSERT INTO doctors (
    slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title,
    photo_url, phone, instagram,
    description_sr, description_sr_cyrl, description_ru,
    description_en, description_de, description_tr,
    created_at
)
SELECT
    @doctor_slug, @doctor_name_sr, @doctor_name_cyr, @doctor_name_ru, @doctor_name_en, '',
    NULL, '+38269295111', '@ipodo_azh',
    'Podolog, osnivač centra iPODO u Budvi (Dukley Gardens). U profesiji od 1995. godine; 2016. otvorila podološki kabinet u Budvi. Od 2003. vodi sopstveni edukativni centar, a od 2025. i akademiju podologije. Prema podacima klinike: laureat Evropskog šampionata (Pariz, 2009), bronza šampionata Rusije (2008), prvo mjesto na Kupu Moskovske oblasti (2007), sertifikovani instruktor Ez Flow ibd (SAD) i KART professional (Izrael). Prijem na ruskom jeziku.',
    'Подолог, оснивач центра iPODO у Будви (Dukley Gardens). У професији од 1995. године; 2016. отворила подолошки кабинет у Будви. Од 2003. води сопствени едукативни центар, а од 2025. и академију подологије. Према подацима клинике: лауреат Европског шампионата (Париз, 2009), бронза шампионата Русије (2008), прво мјесто на Купу Московске области (2007), сертификовани инструктор Ez Flow ibd (САД) и KART professional (Израел). Пријем на руском језику.',
    'Подолог, основатель центра iPODO в Будве (Dukley Gardens). В профессии с 1995 года; в 2016-м открыла подологический кабинет в Будве. С 2003 года ведёт собственный учебный центр, с 2025-го — академию подологии. По данным клиники: призёр чемпионата Европы (Париж, 2009), бронза чемпионата России (2008), первое место на Кубке Московской области (2007), сертифицированный инструктор Ez Flow ibd (США) и KART professional (Израиль). Приём на русском языке.',
    'Podologist, founder of the iPODO centre in Budva (Dukley Gardens). In the profession since 1995; opened a podology cabinet in Budva in 2016. Has run her own training centre since 2003 and a podology academy since 2025. According to the clinic: award winner at the European Championship (Paris, 2009), bronze at the Russian Championship (2008), first place at the Moscow Region Cup (2007), certified instructor for Ez Flow ibd (USA) and KART professional (Israel). Consultations in Russian.',
    'Podologin, Gründerin des Zentrums iPODO in Budva (Dukley Gardens). Seit 1995 im Beruf; 2016 eröffnete sie eine podologische Praxis in Budva. Führt seit 2003 ein eigenes Schulungszentrum und seit 2025 eine Podologie-Akademie. Nach Angaben der Klinik: Preisträgerin der Europameisterschaft (Paris, 2009), Bronze bei der Russischen Meisterschaft (2008), erster Platz beim Cup der Region Moskau (2007), zertifizierte Instruktorin für Ez Flow ibd (USA) und KART professional (Israel). Beratung auf Russisch.',
    'Podolog, Budva''daki (Dukley Gardens) iPODO merkezinin kurucusu. 1995''ten beri meslekte; 2016''da Budva''da bir podoloji kabini açtı. 2003''ten beri kendi eğitim merkezini, 2025''ten beri de bir podoloji akademisini yönetiyor. Kliniğin verdiği bilgilere göre: Avrupa Şampiyonası ödül sahibi (Paris, 2009), Rusya Şampiyonası''nda bronz (2008), Moskova Bölgesi Kupası''nda birincilik (2007), Ez Flow ibd (ABD) ve KART professional (İsrail) sertifikalı eğitmen. Görüşmeler Rusça yapılır.',
    NOW()
FROM dual WHERE @doctor_id IS NULL;

SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- ═══════════════════════════════════════════════════════════════
-- PART 2: SPECIALTY / CLINIC / LANGUAGES
-- ═══════════════════════════════════════════════════════════════

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, @spec_podiatry);

INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id) VALUES (@doctor_id, @clinic_id);

INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, @lang_sr);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, @lang_ru);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: ПРИВЯЗКА ОТЗЫВОВ, НАЗЫВАЮЩИХ ЕЁ ПО ИМЕНИ
-- ═══════════════════════════════════════════════════════════════
-- 25 из 261 отзыва с текстом упоминают Анюту. Остальные говорят о салоне
-- и мастерах маникюра — их к подологу привязывать нельзя.
-- Обновляются только отзывы с ещё не заданным doctor_id, поэтому повторный
-- запуск ничего не портит и ручные правки модератора не перетираются.

UPDATE reviews SET doctor_id = @doctor_id
WHERE clinic_id = @clinic_id
  AND doctor_id IS NULL
  AND original_text IS NOT NULL
  AND (original_text LIKE '%Анют%'
    OR original_text LIKE '%Аню %'
    OR original_text LIKE '%Anyt%'
    OR original_text LIKE '%Anjut%'
    OR original_text LIKE '%Журавл%');

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

SELECT id, slug, name_sr, name_ru, professional_title FROM doctors WHERE id = @doctor_id;
SELECT specialty_id FROM doctor_specialties WHERE doctor_id = @doctor_id;
SELECT clinic_id FROM doctor_clinics WHERE doctor_id = @doctor_id;
SELECT language_id FROM doctor_languages WHERE doctor_id = @doctor_id;
SELECT COUNT(*) AS reviews_linked FROM reviews WHERE doctor_id = @doctor_id;
