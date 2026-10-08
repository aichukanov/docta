SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 053: ссылка на график приёма врачей на сайте клиники.
--
-- КОД ПОСЛЕ МИГРАЦИИ. /api/clinics/details и админка читают новую колонку —
-- выкатывать код до этой миграции нельзя, запросы упадут.
--
-- Сам график не храним: он недельный или месячный, без автоматической
-- записи в прод устареет через неделю. Показываем ссылку в секции «Часы
-- работы» на странице клиники. Почему не парсим — prd/doctor-schedules/.
--
-- Заполнены только постоянные адреса. ДЗ Херцег-Нови и Masoničić публикуют
-- график новым постом каждую неделю/месяц в общей рубрике новостей —
-- постоянной страницы нет, ссылка на пост устареет. ДЗ Тиват держит график
-- на главной — она и так есть в поле website.
--
-- Клиники — по slug (id локально и на проде расходятся).

SET @ddl = IF(
	(SELECT COUNT(*) FROM information_schema.COLUMNS
	  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'clinics' AND COLUMN_NAME = 'doctor_schedule_url') = 0,
	'ALTER TABLE clinics ADD COLUMN doctor_schedule_url VARCHAR(500) NULL DEFAULT NULL AFTER website',
	'DO 0');
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- Недельный график по филиалам (сегодня + 6 дней)
UPDATE clinics SET doctor_schedule_url = 'https://www.hipokrat.me/hipokrat/raspored'
WHERE slug IN (
	'hipokrat-poliklinika-podgorica',
	'hipokrat-poliklinika-radanovici',
	'hipokrat-poliklinika-niksic'
);

-- Raspored ordiniranja po ambulantama
UPDATE clinics SET doctor_schedule_url = 'https://www.kccg.me/poliklinika/poliklinika-kccg/'
WHERE slug = 'klinicki-centar-crne-gore-podgorica';

-- Помесячные PDF по службам
UPDATE clinics SET doctor_schedule_url = 'https://www.dzpg.me/rasporedi-rada-zs/'
WHERE slug = 'dom-zdravlja-podgorica';

UPDATE clinics SET doctor_schedule_url = 'https://brezovik.me/raspored-rada-ljekara-u-ambulanti/'
WHERE slug = 'specijalna-bolnica-za-plucne-bolesti-dr-jovan-bulajic-brezovik';

SELECT id, slug, doctor_schedule_url FROM clinics
WHERE doctor_schedule_url IS NOT NULL ORDER BY id;
