# 3. Архитектура

[← Назад к навигации](index.md)

---

## Структура UI-кита

```
components/
├── ui/                          # новый кит (auto-import без префикса пути)
│   ├── app-button.vue           # <AppButton>
│   ├── app-input.vue            # <AppInput> (type=text|password|email|textarea)
│   ├── app-select.vue           # <AppSelect>
│   ├── app-checkbox.vue
│   ├── app-switch.vue
│   ├── app-segmented.vue        # замена el-radio-group + el-radio-button
│   ├── app-tag.vue
│   ├── app-alert.vue
│   ├── app-tooltip.vue
│   ├── app-tabs.vue / app-tab.vue
│   ├── app-collapse.vue
│   ├── app-result.vue
│   ├── app-empty.vue
│   ├── app-skeleton.vue
│   ├── app-table.vue            # простая таблица (одна страница админки)
│   ├── app-time-input.vue
│   ├── app-input-number.vue
│   ├── app-pagination.vue
│   ├── app-loading-overlay.vue
│   ├── app-toaster.vue          # хост тостов (монтируется в app.vue)
│   ├── app-form-field.vue       # label + slot + error + hint
│   └── icons/                   # локальные SVG (~25 шт., копия из EP, MIT)
│       ├── icon-search.vue
│       ├── icon-location.vue
│       └── ...
├── app-dialog.vue               # уже существует — становится частью кита
├── confirm-dialog.vue           # уже существует
├── app-breadcrumbs.vue          # уже существует
└── ...
composables/
└── use-toast.ts                 # замена ElMessage
```

Конфигурация автоимпорта в `nuxt.config.ts`, чтобы имена остались `App*`
(консистентно с AppDialog/AppBreadcrumbs), а не `UiAppButton`:

```ts
components: [
  { path: '~/components/ui', pathPrefix: false },
  '~/components',
],
```

## API ключевых компонентов

Принцип: API проектируется от фактических мест использования (см. инвентаризацию),
а не копированием API Element Plus. Ниже — самые нагруженные.

### AppButton

```vue
<AppButton
  type="primary | default | danger | text"   <!-- покрывает фактические варианты -->
  size="default | large | small"
  :loading="bool" :disabled="bool" :round="bool"
  native-type="button | submit"
  :icon="IconComponent"                       <!-- или слот #icon -->
/>
```

Состояния hover/active/focus/disabled — только токены. Danger сразу строится на
`--color-danger-dark` (фикс контраста из design-tokens.css:169-178 переезжает внутрь
компонента и удаляется из глобального CSS).

### AppSelect

Один компонент закрывает `el-select`, `el-select-v2` и `filterable-select.vue`:

```vue
<AppSelect
  v-model="value"
  :options="{ value, label, disabled? }[]"
  :multiple="bool" :filterable="bool" :clearable="bool"
  :placeholder :no-data-text :aria-label
  size="default | large"
/>
```

Реализация: кнопка-триггер + Teleport-дроп (z-index `--z-dropdown`),
`role="combobox"` / `listbox` / `option`, навигация стрелками, закрытие по
Escape/клику вне/выбору. Позиционирование — без popper: фиксированный дроп под
триггером с flip при нехватке места (одна функция на getBoundingClientRect).
Виртуализации нет — максимальный список в проекте ~130 элементов.

Fallback-решение: если полноценный a11y-combobox съедает больше одной итерации —
подключить Reka UI только для Listbox/Combobox-примитива, стили свои.
Решение принимается в итерации 2, фиксируется в PROGRESS.md.

### useToast (замена ElMessage)

```ts
const toast = useToast();
toast.success(t('profile.saved'));
toast.error(message, { duration: 5000 });
```

- `useToast` пишет в общий reactive-стек (useState), `AppToaster` в `app.vue` рендерит
  стек через Teleport (z-index `--z-tooltip`), `role="status"` + `aria-live="polite"`.
- Миграция механическая: `ElMessage.success(x)` → `useToast().success(x)` (~35 мест).

### Формы (замена el-form)

`el-form` используется в 8 формах (auth, диалоги профиля, отзыв). Вместо движка
правил — явный паттерн:

```ts
// composables/use-form-errors.ts
const { errors, touch, validate } = useFormErrors({
  email: () => (!isValidEmail(email.value) ? t('validation.email') : null),
  password: () => (password.value.length < 8 ? t('validation.password') : null),
});
```

```vue
<AppFormField :label="t('login.email')" :error="errors.email" required>
  <AppInput v-model="email" type="email" @blur="touch('email')" />
</AppFormField>
```

`AppFormField` вешает `aria-invalid` и `aria-describedby` на слотовый инпут через
provide/inject. Сабмит — обычный `<form @submit.prevent>` (бонус: нативный Enter-сабмит,
который с el-form требовал костылей).

### AppTabs

Нужны только админке (6 групп). URL-синхронизация остаётся на стороне страницы.
`role="tablist/tab/tabpanel"`, стрелки для переключения, ленивый рендер панелей
(`v-if` активной) — как у текущего поведения EP.

### AppTable

Используется в одном месте (`admin/user-info.vue`): статичные колонки, без сортировки
и выделения. Достаточно семантической `<table>` + слоты колонок. Не строить
универсальный datagrid.

### AppTimeInput

`el-time-picker` (2 редактора графика работы) заменяется нативным
`<input type="time">` со стилями токенов: на мобильных это строго лучше попапа EP,
формат HH:mm совпадает с текущими данными.

## Иконки

1. Выписать фактический список импортов из `@element-plus/icons-vue` (~25: Search,
   Lock, Message, LocationFilled, ArrowLeft/Right, Plus, Edit, Clock, Star, ...).
2. Скопировать SVG-исходники в `components/ui/icons/icon-*.vue` (MIT, копирование легально).
3. `AppIcon` — тонкая обёртка размера/цвета (`1em`, `currentColor`), использование:
   `<AppIcon :size="16"><IconSearch /></AppIcon>` или напрямую `<IconSearch class="..." />`.
4. После миграции импортов транзитивная зависимость исчезает вместе с element-plus.

## Порядок демонтажа инфраструктуры (строго в конце, итерация 5)

1. Grep-гейт по всему репозиторию: `<el-`, `\bEl[A-Z]`, `v-loading`, `@element-plus` → 0 вхождений.
2. `nuxt.config.ts`: убрать `@element-plus/nuxt` из modules; добавить конфиг `components` для `ui/`.
3. `package.json`: удалить `element-plus`, `@element-plus/nuxt`.
4. `design-tokens.css`: удалить блок моста `:root:root { --el-* }` и фикс `.el-button--danger`.
5. Auth-страницы: удалить локальные `--el-*`-переменные (4 файла).
6. `npm run typecheck` + полный e2e + `nuxt build --analyze` (зафиксировать дельту бандла в PROGRESS.md).

## Стратегия миграции страниц

- Контур = набор каталогов/страниц (см. итерации). Внутри контура страницы мигрируются
  по одной, страница за один присест — без половинчатых состояний в файле.
- Сосуществование двух систем между итерациями безопасно: кит и EP сидят на одних
  токенах, визуального разнобоя нет.
- Обёртки (`pagination.vue`, `filterable-select.vue`, `ApiErrorAlert.vue`,
  `skeleton-card.vue`) мигрируются заменой внутренностей — их потребители не правятся.
