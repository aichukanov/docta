-- Каталог клиник, итерация 2 (геолокация): сохранение выбранного города
-- для авторизованных пользователей (composable useUserLocation).
-- Применение:
-- mysql -u docta_admin -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/004-add-auth-users-preferred-city.sql

ALTER TABLE auth_users
	ADD COLUMN preferred_city_id INT NULL,
	ADD CONSTRAINT fk_auth_users_preferred_city
		FOREIGN KEY (preferred_city_id) REFERENCES cities(id) ON DELETE SET NULL;
