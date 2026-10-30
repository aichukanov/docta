-- Дубль из импорта отзывов Kliničkog centra: Tamás Kéméndy выложил один и тот же текст
-- (1★, побайтно совпадает) на основной карточке и на карточке Urgentni centra. Обе
-- карточки — одна клиника на сайте, отзыв показывался дважды. Остаётся отзыв основной
-- карточки; всё, что ссылается на дубль, переносится на него до удаления.
-- Строки — по provider_review_id: id отзывов локально и на проде расходятся.
-- Повторное применение безопасно: без дубля все запросы ничего не делают.

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @keep = (SELECT id FROM reviews WHERE provider = 'google_maps'
  AND provider_review_id = 'places/ChIJn5PmYSPrTRMR1bfj5M6l8J8/reviews/ChZDSUhNMG9nS0VJQ0FnSURiaGVhZ0hnEAE');
SET @dup = (SELECT id FROM reviews WHERE provider = 'google_maps'
  AND provider_review_id IN (
    'places/ChIJM4itQLvrTRMRmoHZHfubsaM/reviews/ChZDSUhNMG9nS0VJQ0FnSURiaGNHV0FnEAE',
    'places/undefined/reviews/ChZDSUhNMG9nS0VJQ0FnSURiaGNHV0FnEAE'));

UPDATE clinic_complaints SET review_id = @keep WHERE review_id = @dup AND @keep IS NOT NULL;
UPDATE doctor_complaints SET review_id = @keep WHERE review_id = @dup AND @keep IS NOT NULL;
UPDATE IGNORE review_likes SET review_id = @keep WHERE review_id = @dup AND @keep IS NOT NULL;
UPDATE review_moderation_logs SET review_id = @keep WHERE review_id = @dup AND @keep IS NOT NULL;

DELETE FROM reviews WHERE id = @dup AND @keep IS NOT NULL;
