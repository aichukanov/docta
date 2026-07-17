# 2. Требования

[← Назад к навигации](index.md)

---

## Инвентаризация использования (срез 2026-06-12)

~95 файлов содержат `el-*` / `ElMessage` / импорты `@element-plus`.

### Компоненты в шаблонах

| EP-компонент | Вхождений | Зона | Замена |
|---|---:|---|---|
| `el-button` | 140 | везде | `AppButton` |
| `el-input` | 63 | везде | `AppInput` (+ textarea-режим) |
| `el-select` + `el-option` | 47 | везде | `AppSelect` |
| `el-icon` | 22 | везде | `AppIcon` + локальные SVG |
| `el-tabs` + `el-tab-pane` | 26 | только админка | `AppTabs` |
| `el-form` + `el-form-item` | 24 | auth, профиль, отзывы | `AppForm`/`AppFormField` + composable |
| `el-tag` | 10 | каталоги, биллинг, админка | `AppTag` |
| `el-radio-group` / `el-radio-button` / `el-radio` | 16 | /clinics (вид список/карта), биллинг, админка | `AppSegmented` (кнопочная группа) / `AppRadio` |
| `el-alert` | 10 | везде | `AppAlert` |
| `el-table` + `el-table-column` | 9 | только админка (user-info) | `AppTable` (простая, без сортировок) |
| `el-result` | 7 | auth-страницы | `AppResult` |
| `el-tooltip` | 6 | контакты, бейджи, профиль | `AppTooltip` |
| `el-time-picker` | 4 | график работы (профиль + админка) | `<input type="time">` в `AppTimeInput` |
| `el-select-v2` | 4 | filterable-select, reviews-page, фильтры услуг | `AppSelect` с поиском (виртуализация не нужна: max ~130 элементов) |
| `el-skeleton` + `el-skeleton-item` | 5 | skeleton-card | `AppSkeleton` |
| `el-input-number` | 4 | админка | `AppInputNumber` |
| `el-empty` | 4 | каталоги, отзывы, админка | `AppEmpty` |
| `el-checkbox` | 4 | фильтр «открыто сейчас», биллинг, админка | `AppCheckbox` |
| `el-collapse` + `el-collapse-item` | 5 | сводка клиники, попап карты | `AppCollapse` (на `<details>` или v-show) |
| `el-card` | 3 | verify-email, админка | обычный div + токены (паттерн карточек уже есть) |
| `el-pagination` | 2 | pagination.vue (обёртка), админка | `AppPagination` — меняется только внутренность обёртки |
| `el-switch` | 2 | профиль, админка | `AppSwitch` |
| `el-dialog` | 1 | админка (модерация) | `AppDialog` (уже существует) |
| `el-link` | 1 | route-button | стилизованный `<a>` |
| `el-divider` | 1 | login | CSS |

### Императивные API и директивы

| API | Вхождений | Замена |
|---|---:|---|
| `ElMessage` | ~35 вызовов | `useToast()` + `AppToaster` |
| `v-loading` | 1 (clinic/items-page) | `AppLoadingOverlay` / модификатор класса |
| `@element-plus/icons-vue` | импорты в 27 файлах, ~25 уникальных иконок | локальные SVG-компоненты `components/ui/icons/` |

### Инфраструктура

- `@element-plus/nuxt` в `modules` (nuxt.config.ts:4)
- Мост токенов `:root:root { --el-* }` + фикс danger-кнопок в `assets/css/design-tokens.css:130-178`
- `--el-*`-переменные локально в 4 auth-страницах (verify/reset/forgot/confirm-email)
- `@element-plus/icons-vue` НЕ объявлен в package.json — транзитивная зависимость

## Функциональные требования

- **FR-1.** UI-кит в `components/ui/` покрывает все компоненты из таблицы выше; API максимально близок к месту использования (не к API EP).
- **FR-2.** Каждый компонент кита стилизуется ТОЛЬКО токенами из `design-tokens.css`; ни одного hex-значения в стилях компонентов (кроме обоснованных, с комментарием).
- **FR-3.** `useToast()` поддерживает типы success/error/warning/info, автозакрытие, очередь; хост монтируется один раз в `app.vue`.
- **FR-4.** `AppSelect`: одиночный и множественный выбор, фильтрация по вводу, clearable, placeholder, `no-data`-текст, закрытие по выбору/Escape/клику вне — паритет с текущим использованием `el-select`/`el-select-v2`.
- **FR-5.** Формы: замена правил `el-form` — лёгкий паттерн «поле + computed-ошибка + показ после touch/submit»; единый `AppFormField` (label, ошибка, hint, обязательность).
- **FR-6.** Существующие обёртки (`pagination.vue`, `filterable-select.vue`, `ApiErrorAlert.vue`, `skeleton-card.vue`) сохраняют свои внешние API — меняется только реализация внутри. Страницы-потребители этих обёрток не трогаются.
- **FR-7.** Иконки: используемые ~25 SVG копируются локально (MIT-лицензия EP позволяет), визуальный дифф нулевой; замена набора — отдельное решение вне scope.
- **FR-8.** По завершении контура в нём не остаётся ни одного `el-*`, `El*`-импорта, `v-loading`, `@element-plus/*` (grep-гейт).
- **FR-9.** Финал: удаление `element-plus`, `@element-plus/nuxt` из package.json, модуля из nuxt.config.ts, моста `--el-*` из design-tokens.css и локальных `--el-*` из auth-страниц.

## Нефункциональные требования

- **NFR-1. Доступность (планка WCAG-аудита 2026-06):**
  - управление с клавиатуры: select (стрелки/Enter/Escape/Tab, type-ahead не обязателен), tabs (стрелки), dialog (фокус-ловушка — у AppDialog уже есть inert), switch/checkbox (Space);
  - роли/aria: `role="listbox/option"`, `aria-expanded`, `aria-selected`, `aria-invalid` + `aria-describedby` на ошибках полей, `role="status"`/`aria-live="polite"` на тостах;
  - контраст всех состояний ≥ 4.5:1 (текст) / 3:1 (UI) — наследуем уже выверенные токены;
  - фокус-индикаторы видимы на всех интерактивных элементах.
- **NFR-2. SSR-безопасность:** компоненты публичного контура рендерятся на сервере без обращения к `window`/`document` вне `onMounted`; никакого мерцания гидрации (особенно select/collapse).
- **NFR-3. i18n:** все видимые строки и aria-label — через props; дефолтов на конкретном языке в ките нет.
- **NFR-4. Производительность:** клиентский JS публичных страниц после итерации 3 меньше базового замера минимум на размер EP-чанков (точная цель фиксируется после baseline в итерации 1); CSS кита < 30 KB суммарно.
- **NFR-5. Без визуальной регрессии по умолчанию:** до/после-скриншоты ключевых страниц совпадают с точностью до сознательно принятых отличий.
- **NFR-6. Мобильность:** тач-цели ≥ 44px, select на мобильных не ломает прокрутку страницы, инпуты 16px (анти-зум iOS — уже в токенах).

## Вне scope

- Редизайн (цвета, типографика, отступы остаются как есть).
- Тёмная тема (отдельная работа ПОСЛЕ миграции, кит обязан ей не мешать: только токены).
- Замена `md-editor-v3` (markdown-редактор админки — независимая зависимость).
- Виртуализация списков в select.
- Storybook/витрина компонентов (по желанию — простая страница `/dev/ui` вне прода).
