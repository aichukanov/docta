# AI-обзоры отзывов: ручной workflow

Сайт **не генерирует** AI-обзоры сам — API-ключа Anthropic на сервере нет
(решение 2026-06-12). `GET /api/reviews/ai-summary` только читает кэш из
`review_ai_summaries`; блок «AI-обзор отзывов» появляется на странице отзывов,
когда в таблице есть строка для сущности и локали.

Сбор запускается вручную, время от времени, в сессии Claude Code:
модель сессии сама анализирует отзывы (без API-ключа) и выдаёт SQL,
который пользователь применяет — как в workflow переводов отзывов
([REVIEWS_TRANSLATION_WORKFLOW.md](REVIEWS_TRANSLATION_WORKFLOW.md)).

## Шаг 1 — найти сущности, которым нужен (ре)генерированный обзор

Критерии (те же, что были в автоматике):

- минимум **3** не-отклонённых отзыва с текстом (`AI_SUMMARY_MIN_REVIEWS`);
- регенерация — когда после последней генерации добавилось **≥5** таких
  отзывов (`reviews_count` в кэше против текущего количества).

```sql
-- Кандидаты: doctor/clinic с ≥3 текстовыми отзывами, без кэша или с устаревшим
SELECT t.entity_type, t.entity_id, t.eligible, s.reviews_count AS cached_count
FROM (
	SELECT 'clinic' AS entity_type, clinic_id AS entity_id, COUNT(*) AS eligible
	FROM reviews
	WHERE clinic_id IS NOT NULL AND status != 'rejected'
		AND original_text IS NOT NULL AND CHAR_LENGTH(original_text) > 0
	GROUP BY clinic_id
	UNION ALL
	SELECT 'doctor', doctor_id, COUNT(*)
	FROM reviews
	WHERE doctor_id IS NOT NULL AND status != 'rejected'
		AND original_text IS NOT NULL AND CHAR_LENGTH(original_text) > 0
	GROUP BY doctor_id
) t
LEFT JOIN review_ai_summaries s
	ON s.entity_type = t.entity_type AND s.entity_id = t.entity_id AND s.language = 'en'
WHERE t.eligible >= 3
	AND (s.id IS NULL OR t.eligible - s.reviews_count >= 5);
```

## Шаг 2 — выгрузить отзывы кандидата

Максимум **100** новейших, текст каждого обрезается до 1000 символов:

```sql
SELECT rating, original_text
FROM reviews
WHERE clinic_id = :id  -- или doctor_id = :id
	AND status != 'rejected'
	AND original_text IS NOT NULL AND CHAR_LENGTH(original_text) > 0
ORDER BY published_at DESC
LIMIT 100;
```

## Шаг 3 — контракт генерации (выполняет модель сессии)

Один обзор на сущность, сразу 6 локалей: `en, ru, sr, sr-cyrl, de, tr`.

- **sentiment** — общий для всех локалей (`positive | neutral | negative`),
  из среднего рейтинга и тона отзывов.
- **positives** — 3–5 коротких конкретных сильных сторон, реально упомянутых
  в отзывах (JSON-массив строк).
- **negatives** — 0–5 конкретных проблем, реально упомянутых (пустой массив,
  если нет).
- **recommendations** — 2–3 предложения потенциальному пациенту: кому
  подходит, что учесть.
- Объективно и конкретно; не выдумывать факты, которых нет в отзывах;
  не упоминать имена авторов и любые персональные данные.
- `sr` — сербский латиницей, **иекавица**; `sr-cyrl` — тот же текст кириллицей.
- Все локали — переводы одного и того же обзора, не разные анализы.

## Шаг 4 — SQL на запись

По строке на локаль (6 строк на сущность), `reviews_count` = количество
отзывов, использованных в шаге 2:

```sql
INSERT INTO review_ai_summaries
	(entity_type, entity_id, language, sentiment, positives, negatives, recommendations, reviews_count, generated_at)
VALUES
	('clinic', 42, 'ru', 'positive',
	 '["Внимательные врачи", "Быстрая запись"]', '[]',
	 'Подойдёт тем, кто ...', 7, NOW())
	-- ... ещё 5 локалей
ON DUPLICATE KEY UPDATE
	sentiment = VALUES(sentiment),
	positives = VALUES(positives),
	negatives = VALUES(negatives),
	recommendations = VALUES(recommendations),
	reviews_count = VALUES(reviews_count),
	regenerated_at = NOW();
```

Файл кладётся в `server/sql/` (например, `insert-ai-summaries-2026-06.sql`),
применяет пользователь:

```bash
mysql -u docta_admin -p --default-character-set=utf8mb4 docta_me < server/sql/insert-ai-summaries-2026-06.sql
```

## Шаг 5 — проверка

Открыть страницу отзывов сущности (`/clinics/<slug>/reviews` или
`/doctors/<slug>/reviews`) в паре локалей — блок «AI-обзор отзывов» должен
показывать сильные/слабые стороны и рекомендации; дата — из
`regenerated_at`/`generated_at`.

## Схема таблицы (миграция 005)

```sql
CREATE TABLE review_ai_summaries (
	id INT AUTO_INCREMENT PRIMARY KEY,
	entity_type ENUM('doctor', 'clinic') NOT NULL,
	entity_id INT NOT NULL,
	language VARCHAR(10) NOT NULL,
	sentiment ENUM('positive', 'neutral', 'negative') NOT NULL,
	positives JSON NOT NULL,
	negatives JSON NOT NULL,
	recommendations TEXT NULL,
	reviews_count INT NOT NULL,
	generated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	regenerated_at DATETIME NULL,
	UNIQUE KEY uq_ai_summary_entity_lang (entity_type, entity_id, language)
);
```
