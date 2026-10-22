# Итерация 1. Закреплённые и редакционно-верифицированные отзывы

[← итерации](README.md) | Статус: **Not Started**

**Цель:** админ может закрепить любой approved-отзыв и верифицировать отзыв без файла автора;
закреплённые всегда первые на странице клиники и на странице отзывов.

## Задачи

1. **Миграция `server/sql/migrations/059-clinic-reputation.sql`** — целиком по
   [04-database.md](../04-database.md) (включая `clinic_complaints` — таблица общая с итерацией 2,
   миграция одна). Дать обе команды применения (локалка/прод) по навыку migration-commands;
   применяет пользователь.
2. **Сортировка:** `server/common/reviews.ts` —
   - в список SELECT-полей добавить `r.is_pinned as isPinned`;
   - в `fetchReviews()` перед префиксом `boostMinRating` добавить безусловный префикс
     `r.is_pinned DESC, (CASE WHEN r.is_pinned = 1 THEN r.pinned_at END) DESC`.
3. **Эндпоинт `server/api/admin/reviews/pin.post.ts`** `{ reviewId, pinned }`:
   `requireAdmin`; 404 если отзыва нет; 400 если `pinned = true` и `status != 'approved'`;
   UPDATE + лог `pinned`/`unpinned` в `review_moderation_logs`.
4. **Эндпоинт `server/api/admin/reviews/editorial-verify.post.ts`** `{ reviewId, verified, comment }`:
   `comment` обязателен (это запись «какие документы видела редакция»); UPDATE `is_verified`;
   лог `editorial_verified`/`editorial_unverified` с `comment`.
5. **Снятие закрепления при реджекте:** `server/api/admin/reviews/moderate.post.ts` — при
   `action = 'reject'` дополнительно `is_pinned = 0, pinned_at = NULL`.
6. **Админка:** `components/admin/review-info.vue` (подвкладка «Найти») — после загрузки отзыва
   показать тумблеры «Закреплён» и «Верифицирован», для верификации — диалог с обязательным
   комментарием (по образцу диалога отклонения в `review-moderation.vue`). Контролы из Element Plus
   (конвенция admin-контуров).
7. **Карточка отзыва:** `components/review/item.vue` — маркер «Закреплено» (иконка pin +
   `t('PinnedReview')`) в шапке рядом с `ReviewVerifiedBadge`; `interfaces/review.ts` +
   `isPinned?: boolean`.
8. **i18n:** в `i18n/reviews.ts` добавить `PinnedReview` и обобщить `VerifiedReview`
   («Подтверждено документами») и `VerifiedReviewHint` («Документы по этому отзыву проверены
   модерацией docta.me») — все 6 локалей, sr/sr-cyrl иекавицей.

## Критерии приёмки

- AC-1: после `POST /api/admin/reviews/pin {pinned: true}` отзыв первый в
  `/api/clinics/details` и в `/api/clinics/reviews` при каждой из 5 сортировок (проверить curl'ом
  локально, `?lang=` для локали).
- AC-2: у закреплённого отзыва в UI маркер «Закреплено»; у верифицированного — бейдж с новым текстом.
- AC-3: реджект закреплённого отзыва снимает закрепление (строка в `review_moderation_logs`).
- AC-4: editorial-verify без `comment` → 400; verify.post.ts (файловый путь) работает как раньше.
- AC-5: рейтинг клиники не изменился от закрепления (SQL `fetchRating` не трогали).
- AC-6: `npx nuxt typecheck` зелёный; `npx playwright test tests/unit` зелёный.

## Проверка вручную

Локально: закрепить негативный отзыв у клиники с >5 отзывами → он первый на
`/clinics/<slug>` и на `/clinics/<slug>/reviews` при сортировке «по рейтингу (сначала высокие)»;
свой отзыв текущего пользователя по-прежнему показывается отдельным блоком сверху (поведение
не меняем).
