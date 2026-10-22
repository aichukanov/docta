# Итерация 3. Бейдж «Осторожно» во всей выдаче

[← итерации](README.md) | Статус: **Not Started**

**Цель:** клиника с активными подтверждёнными жалобами получает бейдж «Осторожно» рядом с
названием во всех местах выдачи.

Зависимость: итерация 2 (таблица заполняема, `details.ts` уже отдаёт `cautionTypes`).

## Задачи

1. **Данные:**
   - `server/api/clinics/list.ts` — подзапрос `GROUP_CONCAT` активных confirmed-типов →
     `cautionTypes: number[]` в маппере; `interfaces/clinic.ts` → `ClinicData.cautionTypes?`;
   - `server/api/clinics/reviews.ts` — `cautionTypes` в ответ;
   - `server/api/clinics/public-slugs.ts` — `cautionSlugs: string[]`;
   - `pages/doctors/[doctorSlug]/index.vue` и `.../reviews/index.vue` — флаг `caution` в `clinicInfo`.
2. **Компонент `components/clinic/caution-badge.vue`** по образцу `approved-badge.vue`:
   пропсы `cautionTypes`, `small`, `iconOnly`, `link?`; KitTag warning light small + иконка
   alert-triangle (добавить в `components/icon/` с `fill="none"`, иконка приходит и пропсом —
   см. грабли своих SVG); tooltip «Осторожно: {ярлыки}» — одно предложение.
   Текст тултипа — только `--kit-color-warning-dark`/`-solid` поверх бледных заливок (контраст расчётом).
3. **Встраивание** (таблица точек — в [03-architecture.md](../03-architecture.md)):
   `summary-header.vue` (после ApprovedBadge, с `small`), `hero.vue` (с `link` на `#reputation`),
   `map/clinic-popup.vue` (`iconOnly`), `global-search.vue` (слот `#aside`, `iconOnly`),
   `review/item.vue` (иконка у ссылки на клинику), `clinic/route-link.vue` (+ использование
   `cautionSlugs`), карточки в `pages/articles/clinics-with-language-support.vue`.
4. **Алерт на странице отзывов:** `components/reviews-page.vue` — KitAlert warning после
   `RatingSummary` при `cautionTypes.length > 0`, одно предложение + ссылка на
   `/clinics/<slug>#reputation` (ключ `ReviewsCautionNotice`).
5. **Открытые вопросы по месту:** бейдж в шапках подстраниц клиники (items-summary) — решить и
   зафиксировать в PROGRESS; маркер карты не красим.

## Критерии приёмки

- AC-1: у клиники с confirmed-жалобой бейдж виден: каталог, страница услуги (карточка клиники),
  страница анализа, карточка `list-card`, страница врача, попап обеих карт, глобальный поиск,
  hero. У клиники только с unconfirmed-жалобами бейджа нет нигде.
- AC-2: в статьях `ClinicRouteLink` показывает иконку у «плохого» слага; скрытая клиника
  по-прежнему рендерится текстом без ссылки.
- AC-3: tooltip перечисляет именно активные confirmed-ярлыки; деактивация жалобы убирает бейдж
  после обновления данных.
- AC-4: бейдж не ломает раскладку карточки на мобильном (помнить про minmax/min-width:auto/
  неразрывные строки — проверять не по scrollWidth) и не создаёт переноса имени в попапе карты.
- AC-5: schema.org без изменений (сравнить JSON-LD до/после на странице клиники).
- AC-6: typecheck зелёный; клиентские гонки проверять на билде, не на `nuxt dev`.

## Проверка вручную

Локально: включить confirmed-жалобу тестовой клинике → пройти все 8 точек из AC-1 глазами на
двух локалях (ru + sr) и на ширине 375px.
