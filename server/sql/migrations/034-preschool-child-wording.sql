-- «Малый ребёнок» → «дошкольник» в блоке дефектолога.
--
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/034-preschool-child-wording.sql
--
-- В прайсе ФЗОЦГ услуги дефектолога разведены по возрасту: «malo dijete»
-- против «školsko dijete», то есть до школы и школьного возраста. Перевод
-- первой половины сделали покальке — «обследование малого ребёнка», — и
-- по-русски это звучит дико. Вторая половина при этом переведена нормально:
-- «обследование школьника». Правим первую половину под вторую.
--
-- Затронуты ровно три услуги (других «malog djeteta» в каталоге нет):
--   7188 Defektološko ispitivanje malog djeteta
--   7196 Defektološki individualni tretman malog djeteta
--   7197 Defektološki grupni tretman malog djeteta
-- Их пары 7189 / 7198 / 7199 уже верны и не трогаются.
--
-- Правится не только русский: тот же калькированный оборот сидит в трёх
-- языках, и в каждом парная услуга подсказывает правильную форму —
--   en  School Child     → Preschool Child   (было Small Child)
--   de  Schulkind        → Vorschulkind      (было Kleinkind, а это ясли,
--                                             1–3 года, то есть просто неверно)
--   tr  Okul çocuğu      → Okul öncesi çocuk (было Küçük çocuk)
-- Сербский и кириллица не трогаются: «malo dijete» — официальная
-- формулировка прайса, а не перевод.
--
-- Слаги оставлены как есть (…-small-child). Менять их — это ещё один 301 на
-- живых проиндексированных страницах ради латинской строки в адресе, которую
-- пользователь и не читает; текст на странице при этом станет верным.
--
-- Скрипт идемпотентен: присваиваются готовые значения.

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

UPDATE medical_services SET
	name_en = 'Developmental Defectology Assessment Preschool Child',
	name_ru = 'Дефектологическое обследование дошкольника',
	name_de = 'Defektologische Untersuchung des Vorschulkindes',
	name_tr = 'Okul öncesi çocuk defektoloji incelemesi'
 WHERE id = 7188;

UPDATE medical_services SET
	name_en = 'Individual Defectology Treatment Preschool Child',
	name_ru = 'Индивидуальное дефектологическое лечение дошкольника',
	name_de = 'Individuelle defektologische Behandlung Vorschulkind',
	name_tr = 'Okul öncesi çocuk bireysel defektoloji tedavisi'
 WHERE id = 7196;

UPDATE medical_services SET
	name_en = 'Group Defectology Treatment Preschool Child',
	name_ru = 'Групповое дефектологическое лечение дошкольника',
	name_de = 'Defektologische Gruppenbehandlung Vorschulkind',
	name_tr = 'Okul öncesi çocuk grup defektoloji tedavisi'
 WHERE id = 7197;
