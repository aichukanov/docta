# Итерация 2. Раздел «Репутация»

[← итерации](README.md) | Статус: **Not Started**

**Цель:** у клиники с жалобами на странице появляется секция «Репутация» со стандартными
формулировками и статусами; админ управляет жалобами из админки.

Зависимость: миграция 059 применена (итерация 1, таблица `clinic_complaints` уже в ней).

## Задачи

1. **Enum и типы:** `enums/clinic-complaint-type.ts` (коды 1–6 из
   [02-requirements.md](../02-requirements.md)), `interfaces/clinic-reputation.ts`.
2. **i18n:** новый `i18n/clinic-reputation.ts`, 6 локалей: формулировки `Complaint1..6`,
   ярлыки `Complaint1Short..6Short`, `ReputationTitle`, чипы статусов с tooltip'ами,
   `ReputationFooter` (текст из FR-3.5, email `contact@docta.me` латиницей во всех локалях),
   `ClinicResponseTitle`, `SeePinnedReview`, `SeeArticle`. Без символа `|`.
3. **Админские эндпоинты** `complaints.get.ts` / `complaints.post.ts` по
   [03-architecture.md](../03-architecture.md). В ответе get — всё, включая `source_note`;
   upsert по `(clinic_id, complaint_type)`.
4. **Публичные данные:** `server/api/clinics/details.ts` — поле `reputation` (активные жалобы,
   **без** `source_note`) и `cautionTypes` (активные confirmed).
5. **Компонент `components/clinic/reputation-section.vue`:** список жалоб (формулировка, чип
   статуса KitTag, ссылки на отзыв-якорь `#reviews` и статью при наличии), блок ответа клиники,
   подвал-дисклеймер. Никакого свободного текста жалоб — только словарь.
6. **Страница клиники** `pages/clinics/[clinicSlug]/index.vue`: секция `reputation` после Reviews +
   пункт в `tabs` (условие `reputation.length > 0`).
7. **Админка:** в `components/admin/clinic-find.vue` при выбранной клинике — блок «Репутация»:
   таблица жалоб (тип — select по словарю, статус, активность, отзыв id, слаг статьи, дата,
   `source_note`, `clinic_response`), добавление/правка через `complaints.post.ts`.
8. **Аналитика:** событие `reputation_viewed` `{ clinic_id, source }` при попадании секции во
   вьюпорт (паттерн `entity_viewed`) и при клике по табу.

## Критерии приёмки

- AC-1: у клиники без жалоб секция и таб отсутствуют (и в SSR-HTML их нет).
- AC-2: добавление жалобы через админку → секция появляется со статусом и формулировкой на всех
  6 локалях (`?lang=`); `source_note` в публичном API-ответе отсутствует (проверить curl'ом).
- AC-3: деактивация жалобы убирает её из секции; ссылки на отзыв/статью рендерятся только если заполнены.
- AC-4: `reputation_viewed` уходит один раз на просмотр (как `entity_viewed`).
- AC-5: typecheck и unit-тесты зелёные; формулировки sr — иекавица; `|` нигде не используется.

## Проверка вручную

Локально создать клинике 2 жалобы (confirmed + unconfirmed), проверить секцию, табы, чипы и
tooltip'ы, мобильную ширину (без горизонтального скролла), контраст чипов.
