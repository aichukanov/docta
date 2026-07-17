# Итерация 2: Контролы фильтров и каталоги

[← Все итерации](README.md) | [← Навигация](../index.md)

**Статус:** 🔴 Not Started
**Зависимости:** итерация 1

---

## Цель

Самая сложная часть кита — `AppSelect` — плюс остальные контролы форм, и миграция
всех шести каталожных страниц. После итерации списочные страницы (основной
SEO-трафик) не тянут EP-селекты/инпуты.

## Контур

- `pages/clinics/index.vue`, `pages/doctors/index.vue`, `pages/services/index.vue`,
  `pages/medications/index.vue`, `pages/medicines/index.vue`, `pages/labtests/index.vue`
- `components/filter/*` (city-select, language-select, clinic-type-select, rating-select, name, open-now)
- `components/filterable-select.vue`, `components/location-selector.vue`, `components/pagination.vue`
- `components/list-page.vue`, `components/list-card.vue`

## Задачи

- [ ] **`AppSelect`** (см. [архитектуру](../03-architecture.md)): одиночный/множественный, filterable, clearable, клавиатура (стрелки/Enter/Escape), `role=combobox/listbox/option`, Teleport-дроп на `--z-dropdown`, SSR-безопасный триггер. Без виртуализации.
  - ⚠️ Чек-поинт Q-1: если к середине итерации полноценный a11y не складывается — переход на Reka UI Listbox/Combobox как headless-основу, решение записать в PROGRESS.md.
- [ ] `AppInput` (text/email/password/textarea, prefix-иконка, clearable) — здесь нужен для фильтра по имени; полноценная обкатка форм — в итерации 4.
- [ ] `AppCheckbox` (фильтр «открыто сейчас»).
- [ ] `AppSegmented` — кнопочная группа (переключатель список/карта на /clinics).
- [ ] `AppPagination` (prev/pager/next, до 5 страниц, disabled) — заменить внутренности `pagination.vue`, API обёртки не менять.
- [ ] Заменить внутренности `filterable-select.vue` на `AppSelect` (API обёртки не менять — потребители reviews-page и items-page-filters не трогаются до итерации 3).
- [ ] Мигрировать `components/filter/*`, `location-selector.vue`, шесть каталожных страниц.

## Критерии приёмки

- **AC-1.** Grep-гейт контура (список файлов выше) → 0 вхождений EP.
- **AC-2.** Клавиатурный сценарий на /clinics: Tab до фильтра города → Enter/стрелки → выбор → Escape; фокус не теряется, видим индикатор.
- **AC-3.** Мобильная проверка (DevTools + реальный телефон): открытие селекта не скроллит страницу, тач-цели ≥ 44px, нет зума при фокусе инпута.
- **AC-4.** Мультивыбор (языки) — паритет: выбранные значения видны, снятие работает, clearable очищает.
- **AC-5.** Фильтры по-прежнему синхронизируются с URL-параметрами и срабатывают (e2e каталогов зелёные).
- **AC-6.** SSR: `npm run build && npm run preview` → каталог рендерится сервером с триггерами селектов, без гидрационных ворнингов.
- **AC-7.** Визуальное сравнение до/после на /clinics и /services — отличия только осознанные.

## Проверка

1. e2e: `npm run test:e2e` (каталожные сценарии).
2. Ручной прогон всех шести каталогов: каждый фильтр, пагинация, переключатель вид/карта.
3. Скрин-ридер smoke-тест (NVDA): селект города объявляет роль, состояние и выбранное значение.
