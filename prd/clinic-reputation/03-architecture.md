# 03. Архитектура

[← index](index.md)

Все пути и строки сверены с кодом 2026-10-19.

## Сервер

### Сортировка закреплённых — `server/common/reviews.ts`

- В SELECT-поля (`строки ~142–178`) добавить `r.is_pinned as isPinned`.
- В `fetchReviews()` перед существующим префиксом `boostMinRating` (строки ~242–246) добавить
  безусловный префикс: `r.is_pinned DESC, (CASE WHEN r.is_pinned = 1 THEN r.pinned_at END) DESC`.
  Итоговый ORDER BY: `pinned → boost → выбранная сортировка`. Так закрепление работает во всех
  четырёх эндпоинтах чтения (clinics/doctors/insurance × details/reviews) без их изменения.
- `fetchRating()` не трогаем — закрепление на рейтинг не влияет.

### Новые админские эндпоинты (все через `requireAdmin`)

| Файл | Body | Действие |
| --- | --- | --- |
| `server/api/admin/reviews/pin.post.ts` | `{ reviewId, pinned: boolean }` | `UPDATE reviews SET is_pinned, pinned_at = NOW()/NULL`; отказ, если `status = 'rejected'`; лог `pinned`/`unpinned` |
| `server/api/admin/reviews/editorial-verify.post.ts` | `{ reviewId, verified: boolean, comment }` | `UPDATE reviews SET is_verified`; `comment` обязателен; лог `editorial_verified`/`editorial_unverified` |
| `server/api/admin/reputation/complaints.get.ts` | `?entity=clinic\|doctor&entityId=` | полный список жалоб сущности (вкл. `source_note`, неактивные) |
| `server/api/admin/reputation/complaints.post.ts` | upsert `{ entity, entityId, complaintType, status, isActive, reviewId?, articleSlug?, sourceNote?, incidentDate?, response? }` | INSERT/UPDATE по `(clinic_id\|doctor_id, complaint_type)` |

Пути и форма тела изменены в итерации 5 (было `admin/clinics/complaints` с `clinicId`
и `clinicResponse`): один эндпоинт обслуживает и клиники, и врачей.

В `moderate.post.ts` при `action = 'reject'` добавить сброс `is_pinned = 0, pinned_at = NULL` (FR-1.3).

### Публичные данные репутации

- **`server/api/clinics/list.ts`** (`getClinicList()`): в SELECT (строки ~371–428) подзапрос
  `GROUP_CONCAT` активных **подтверждённых** типов жалоб; в маппер (строки ~449–501) — поле
  `cautionTypes: number[]` (пустой массив, если нет). Покрывает каталог, стор, страницы
  услуг/анализов/врача, `list-card`, поиск, карты, статью про языки.
- **`server/api/clinics/details.ts`**: `cautionTypes` (для hero) + `reputation:
  Array<{ type, status, reviewId?, articleSlug?, incidentDate?, clinicResponse? }>` — только
  активные, **без** `source_note`.
- **`server/api/clinics/reviews.ts`**: `cautionTypes` (для алерта на странице отзывов, FR-3.6).
- **`server/api/clinics/public-slugs.ts`**: добавить `cautionSlugs: string[]` (слаги клиник с
  активными подтверждёнными жалобами) — питает `ClinicRouteLink` во всех статьях одним запросом.
- **`server/api/clinics/items-summary.ts`**: `cautionTypes` — если решим показывать бейдж в шапках
  подстраниц (FR-4.3.7).
- Страница врача: в карту `clinicInfo` (`pages/doctors/[doctorSlug]/index.vue:199–206` и
  `reviews/index.vue:124`) добавить флаг `caution: boolean` для ссылки на клинику в отзыве.

## Типы

- `interfaces/review.ts`: `isPinned?: boolean`.
- `interfaces/clinic.ts` (`ClinicData`): `cautionTypes?: number[]`.
- Новый `interfaces/clinic-reputation.ts`: `ClinicComplaint { type: ClinicComplaintType;
  status: 'confirmed' | 'unconfirmed'; reviewId?: number; articleSlug?: string;
  incidentDate?: string; clinicResponse?: string }`.
- Новый `enums/clinic-complaint-type.ts` (см. 02).

## Фронтенд

### Новые компоненты

| Компонент | Описание |
| --- | --- |
| `components/clinic/caution-badge.vue` | По образцу `approved-badge.vue`: пропсы `cautionTypes: number[]`, `small?`, `iconOnly?`, `link?` (RouteLocation на `#reputation`). KitTag warning light small + иконка alert-triangle (иконки в проекте нет — взять из ui-kit `src/icons` или добавить в `components/icon/`; помнить про fill=none и пропс-передачу). el-tooltip light: «Осторожно: {ярлыки через запятую}». i18n внутри компонента, 6 локалей |
| `components/clinic/reputation-section.vue` | Список жалоб (формулировка + чип статуса + ссылки на отзыв/статью), ответ клиники, подвал-дисклеймер. Чипы — KitTag (`warning` для confirmed, `default` для unconfirmed) |
| Маркер «Закреплено» | внутри `components/review/item.vue`, рядом с `ReviewVerifiedBadge` (строка ~110) |

### Точки встраивания бейджа

| Место | Файл | Данные |
| --- | --- | --- |
| Карточка клиники (везде) | `components/clinic/summary-header.vue` — в `.clinic-name-wrapper` после `ClinicApprovedBadge` (строка 150) | `clinic.cautionTypes` уже в `ClinicData` |
| Hero страницы клиники | `components/clinic/hero.vue` — в `.clinic-hero__title-row` после ApprovedBadge (строка 36), с `link` на `#reputation` | из details |
| Попап карты | `components/map/clinic-popup.vue` (строки 73–81) | `clinic.cautionTypes`, `iconOnly` |
| Глобальный поиск | `components/global-search.vue:847–870` — слот `#aside` в `SearchResultRow` | из стора, `iconOnly` |
| Отзыв о враче, ссылка на клинику | `components/review/item.vue:137–145` | флаг в `clinicInfo` |
| Статьи | `components/clinic/route-link.vue` — иконка после текста при `cautionSlugs.includes(slug)`; карточки `pages/articles/clinics-with-language-support.vue:241–252` | `public-slugs` |

### Страница клиники — `pages/clinics/[clinicSlug]/index.vue`

- В `computed tabs` (строки ~367–413) после `reviews` добавить `reputation` (условие:
  `details.reputation?.length`).
- После секции Reviews (строки ~1003–1040) — `<EntityPageSection sectionId="reputation">` с
  `ClinicReputationSection`.
- В hero-зоне ничего дополнительно не делаем: сигнал даёт бейдж в `ClinicHero` (альтернатива —
  KitAlert под hero — отклонена, чтобы не дублировать сводку, см. конвенцию «одна сводка данных»).

### Страница отзывов — `components/reviews-page.vue`

KitAlert warning над списком (после `RatingSummary`), текст одно предложение + ссылка
«Подробнее — в разделе „Репутация“» на `/clinics/<slug>#reputation`. Показывается при
`cautionTypes.length > 0`.

### i18n

Новый `i18n/clinic-reputation.ts` (6 локалей): `Caution`, `CautionTooltip` (шаблон с
перечислением), ярлыки/формулировки по кодам (`Complaint1`…`Complaint6`, `Complaint1Short`…),
`ReputationTitle`, `ConfirmedByEditors` + tooltip, `Unconfirmed` + tooltip, `ReputationFooter`,
`ClinicResponseTitle`, `SeePinnedReview`, `SeeArticle`, `ReviewsCautionNotice`, `PinnedReview`.
В `i18n/reviews.ts` обобщить `VerifiedReview`/`VerifiedReviewHint` (FR-2.2).

## Аналитика (Mixpanel, конвенции `prd/analytics/events-catalog.md`)

- `caution_badge_shown` не шлём (шум); вместо этого:
- клик/переход на `#reputation` — событие `reputation_viewed` `{ entity_type, entity_id }`
  (с итерации 5; до неё было `{ clinic_id }`, `source` так и не завели);
- по нему же решаем судьбу фичи (см. 05).

## Кэш

HTML кэшируется на Cloudflare (edge cache). После применения SQL с жалобами/закреплением — purge
затронутых URL (страница клиники, страница отзывов, листинги, где клиника на первой странице),
как при любом контент-изменении. Процедура — `docs/rules/EDGE_LOCALE_CACHE.md`.
