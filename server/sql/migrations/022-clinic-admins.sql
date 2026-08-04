-- Миграция 022: администраторы клиники (M:N вместо clinics.created_by)
--
-- До этой миграции доступ к кабинету клиники давала одна колонка
-- clinics.created_by, то есть у клиники мог быть ровно один управляющий
-- аккаунт. В реальной клинике их несколько (владелец, администратор
-- ресепшена, маркетолог), и передача доступа означала перезапись владения.
--
-- clinics.created_by ОСТАЁТСЯ, но только как история «кто создал запись»:
-- ни авторизация, ни выборки кабинета его больше не читают. Единственный
-- источник правды по доступу — clinic_admins.
--
-- collation указываем явно: utf8mb4 без COLLATE берёт дефолт сервера
-- (utf8mb4_0900_ai_ci) и ломает JOIN с существующими таблицами.
SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS clinic_admins (
	id INT AUTO_INCREMENT PRIMARY KEY,
	clinic_id INT NOT NULL,
	user_id INT NOT NULL,
	created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	-- UNIQUE обязателен: без него повторный запуск импорта или двойной клик
	-- в админке молча плодят дубли, как это случилось с clinic_languages
	UNIQUE KEY uq_clinic_admins_clinic_user (clinic_id, user_id),
	KEY idx_clinic_admins_user (user_id),
	CONSTRAINT fk_clinic_admins_clinic FOREIGN KEY (clinic_id)
		REFERENCES clinics (id) ON DELETE CASCADE,
	CONSTRAINT fk_clinic_admins_user FOREIGN KEY (user_id)
		REFERENCES auth_users (id) ON DELETE CASCADE
) ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Администраторы клиники (M:N). Единственный источник прав на кабинет клиники.';

-- Перенос текущих владельцев. INSERT IGNORE делает миграцию идемпотентной
-- вместе с CREATE TABLE IF NOT EXISTS выше.
INSERT IGNORE INTO clinic_admins (clinic_id, user_id)
SELECT id, created_by FROM clinics WHERE created_by IS NOT NULL;
