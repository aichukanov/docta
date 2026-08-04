-- Миграция 023: популярность лекарств (med_medicines.rank_score)
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/023-medicine-rank-score.sql
--
-- Зачем: /medicines сортировался по алфавиту, и первая страница реестра
-- состояла из онкологических и стационарных препаратов (5-FLUOROURACIL,
-- ABIRATERON, ABRAXANE, ADCETRIS) — ни одного лекарства, которое человек
-- может искать сам. Обычное ранжирование сайта (цена, рейтинг, близость)
-- к реестру неприменимо: лекарства не привязаны ни к клиникам, ни к ценам.
--
-- Решение: скалярный rank_score, как clinics.rank_score/doctors.rank_score,
-- считается скриптом (server/sql/migrations/recalc-med-rank-score.sql), а не
-- в запросе — формула стоит ~130 мс на 3553 строках (два regexp-прохода и
-- три оконных функции), это неприемлемо для каждого запроса списка.
--
-- Данные меняются только при рескрейпе CInMED, поэтому периодического
-- пересчёта (как у клиник каждые 6 часов) здесь нет: recalc запускается
-- вручную после импорта реестра.
--
-- collation указываем явно: utf8mb4 без COLLATE берёт дефолт сервера
-- (utf8mb4_0900_ai_ci) и ломает JOIN с существующими таблицами.
SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: вес ATC-группы — насколько препараты группы нужны обычному
-- человеку в аптеке. Единственный ручной вход в формулу: 14 чисел.
-- ═══════════════════════════════════════════════════════════════
-- Веса лежат в БД, а не в коде, именно потому что это данные, а не логика:
-- их правят, не пересобирая приложение (после правки — перезапустить recalc).
--
-- Нужен он из-за одного перекоса: число зарегистрированных брендов внутри
-- ATC-подгруппы — хороший прокси спроса (ибупрофен 19 брендов, парацетамол
-- 23, пантопразол 14), но в онкологии брендов тоже много (CABOMETYX 25,
-- DASATINIB, ADCETRIS) — там дженериков много из-за цены препарата, а не
-- из-за спроса. Вес группы L = 0 снимает ровно это.

ALTER TABLE med_atc_groups
	ADD COLUMN popularity_weight TINYINT UNSIGNED NOT NULL DEFAULT 1
	COMMENT 'Спрос группы у обычного покупателя (0-3). Вход в med_medicines.rank_score';

UPDATE med_atc_groups SET popularity_weight = CASE code
	-- Аптечный ходовой ассортимент: ЖКТ, сердце/давление, кожа,
	-- антибиотики, обезболивающие, простуда/дыхание
	WHEN 'A' THEN 3  -- Alimentary tract and metabolism
	WHEN 'C' THEN 3  -- Cardiovascular system
	WHEN 'D' THEN 3  -- Dermatologicals
	WHEN 'J' THEN 3  -- Anti-infectives for systemic use
	WHEN 'M' THEN 3  -- Musculo-skeletal system
	WHEN 'N' THEN 3  -- Nervous system
	WHEN 'R' THEN 3  -- Respiratory system
	-- Нужны регулярно, но узкой части людей
	WHEN 'B' THEN 2  -- Blood and blood forming organs (антикоагулянты)
	WHEN 'G' THEN 2  -- Genito-urinary system and sex hormones
	WHEN 'H' THEN 2  -- Systemic hormonal preparations (тиреоид, кортикостероиды)
	WHEN 'S' THEN 2  -- Sensory organs (капли для глаз/ушей)
	-- Редкий или не потребительский спрос
	WHEN 'P' THEN 1  -- Antiparasitic products (4 препарата в реестре)
	WHEN 'V' THEN 1  -- Various (контрасты, антидоты, диагностика)
	WHEN 'L' THEN 0  -- Antineoplastic and immunomodulating agents
	ELSE 1
END;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: колонка под скор
-- ═══════════════════════════════════════════════════════════════
-- SMALLINT signed: формула даёт от -615 (дубль фасовки в стационарной
-- группе) до 450 (безрецептурный препарат мирового бренда).
-- DEFAULT 0 безопасен: до первого recalc список выродится в алфавитный —
-- то есть в поведение до этой миграции, а не в пустую страницу.

ALTER TABLE med_medicines
	ADD COLUMN rank_score SMALLINT NOT NULL DEFAULT 0
	COMMENT 'Популярность для сортировки /medicines. Считается recalc-med-rank-score.sql',
	ADD KEY idx_med_medicines_rank (is_active, rank_score);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

SELECT code, name_en, popularity_weight FROM med_atc_groups ORDER BY code;
SELECT COUNT(*) AS medicines_with_zero_score FROM med_medicines WHERE rank_score = 0;
