# Итерация 3: Публичный контур до нуля EP

[← Все итерации](README.md) | [← Навигация](../index.md)

**Статус:** 🔴 Not Started
**Зависимости:** итерации 1–2

---

## Цель

Добить весь публичный SSR-контур: детальные страницы, отзывы, карта, контакты.
**Контрольная точка ценности:** ни одна публичная страница не грузит EP;
зафиксировать дельту бандла против baseline.

## Контур

- Детальные страницы: `pages/clinics/[clinicSlug]`, `pages/doctors/[doctorSlug]`, `pages/services/[serviceSlug]`, `pages/medications/...`, `pages/medicines/...`, `pages/labtests/...`, статьи
- Клиника: `clinic/summary.vue`, `clinic/summary-header.vue`, `clinic/items-page*.vue`, `clinic/show-on-map-button.vue`, `clinic/route-button.vue`, `clinic/approved-badge.vue`, `clinic/logo.vue`, `clinic/hero.vue`, `clinic/header.vue`
- Карта: `map/clinic-popup.vue`, `clinics-map-view.vue`, `clinic-services-map.vue`
- Контакты: `contacts/*` (line, copy-button и пр.)
- Отзывы (публичная часть): `reviews-page.vue`, `review/form.vue`, `review/item.vue`, `review/login-prompt.vue`, `review/verification-upload.vue`, `review/own-item.vue`, `doctor-reviews.vue`, `rating-summary.vue`
- Прочее: `details-page.vue`, `entity-page/index.vue`, `service-info.vue`, `priced-item-card.vue`, `category-tag.vue`

## Задачи

- [ ] `AppTooltip`: hover + focus (клавиатура!), Teleport, `--z-tooltip`, `role="tooltip"` + `aria-describedby`. Использование: контакты (copy-button, line), approved-badge.
- [ ] `AppCollapse`: на `<details>/<summary>` или v-show + кнопка с `aria-expanded`. Использование: сводка клиники, попап карты.
- [ ] `AppResult` не нужен в этом контуре — НЕ делать раньше времени.
- [ ] Мигрировать формы отзывов (`review/form.vue`, `review/own-item.vue`, `review/item.vue`): textarea через `AppInput`, селект оценки через `AppSelect`, алерты/кнопки уже готовы. Паттерн `AppFormField` обкатывается здесь на небольшой форме (до auth-форм итерации 4).
- [ ] Мигрировать остальные файлы контура (точечные замены button/icon/tag/link/empty).
- [ ] `el-link` в `route-button.vue` → стилизованный `<a>`.
- [ ] Замер бандла: повторить анализ из итерации 1, записать дельту в PROGRESS.md.

## Критерии приёмки

- **AC-1.** Grep-гейт: во всех `pages/**` КРОМЕ `admin/`, `profile*`, `login`, auth-страниц и во всех публичных компонентах → 0 вхождений EP.
- **AC-2.** В клиентском бандле публичных страниц нет EP-чанков (проверка по analyze/network-табу на `/clinics`, `/doctors/[slug]`, `/services/[slug]`).
- **AC-3.** Отзыв подаётся end-to-end: форма → валидация → отправка → тост; верификация (загрузка файла) работает.
- **AC-4.** Тултипы контактов доступны с клавиатуры (focus показывает, Escape скрывает).
- **AC-5.** Сводка клиники и попап карты раскрываются/сворачиваются, состояние aria корректно.
- **AC-6.** Дельта бандла зафиксирована в PROGRESS.md.
- **AC-7.** typecheck + e2e зелёные; Lighthouse mobile на /clinics не хуже baseline.

## Проверка

1. Полный клик-прогон публичного сайта на мобильном вьюпорте: каталог → детальная клиника → услуги/цены → контакты (копирование) → карта → отзыв.
2. `npm run build && npm run preview` + Network: убедиться, что element-plus отсутствует в загружаемых чанках публичных страниц.
3. Lighthouse (mobile) на /clinics и детальной странице врача.
