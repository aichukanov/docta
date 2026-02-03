# Шаблон для создания файлов переводов

## Быстрый старт

Используйте этот шаблон для создания новых файлов переводов в папке `i18n/`.

## Шаблон файла

**⚠️ ВАЖНО:** Все ключи локализации должны начинаться с **ЗАГЛАВНОЙ буквы**.

```typescript
/**
 * [Component Name] Translations
 * Описание назначения переводов
 */

export default {
	messages: {
		'en': {
			// English translations
			ExampleKey: 'Example text',
		},
		'ru': {
			// Русские переводы
			ExampleKey: 'Пример текста',
		},
		'sr': {
			// Srpski prevodi (latinica)
			ExampleKey: 'Primer teksta',
		},
		'de': {
			// Deutsche Übersetzungen
			ExampleKey: 'Beispieltext',
		},
		'tr': {
			// Türkçe çeviriler
			ExampleKey: 'Örnek metin',
		},
		'sr-cyrl': {
			// Српски преводи (ћирилица)
			ExampleKey: 'Пример текста',
		},
	},
};
```

**Примеры правильного именования ключей:**

- ✅ `PageTitle`, `BtnSave`, `SuccessMessage`, `ErrorSaving`
- ❌ `pageTitle`, `btnSave`, `successMessage`, `errorSaving`

## Использование в компоненте

### Вариант 1: Один файл переводов

```vue
<script setup lang="ts">
import componentMessages from '~/i18n/[file-name]';

const { t } = useI18n({
	useScope: 'local',
	messages: componentMessages.messages,
});
</script>

<template>
	<div>
		<h1>{{ t('ExampleKey') }}</h1>
	</div>
</template>
```

### Вариант 2: Комбинирование нескольких файлов

Когда компоненту нужны переводы из нескольких файлов (например, общие + специфичные):

```vue
<script setup lang="ts">
import { combineI18nMessages } from '~/i18n/utils';
import componentMessages from '~/i18n/[component-name]';
import breadcrumbI18n from '~/i18n/breadcrumb';
import cityI18n from '~/i18n/city';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([componentMessages, breadcrumbI18n, cityI18n]),
});
</script>

<template>
	<div>
		<!-- Доступны ключи из всех файлов -->
		<h1>{{ t('ComponentTitle') }}</h1>
		<nav>{{ t('BreadcrumbHome') }}</nav>
		<span>{{ t('City_podgorica') }}</span>
	</div>
</template>
```

**Примеры использования combineI18nMessages:**

- Страницы со списками городов/специальностей/услуг
- Страницы со статьями, использующие breadcrumbs
- Компоненты, работающие с несколькими доменами данных

**Важно:** `combineI18nMessages` принимает массив объектов с полем `messages`, а не сами messages напрямую.

## Чек-лист для нового файла переводов

- [ ] Создан файл `i18n/[name].ts`
- [ ] Структура экспорта: `export default { messages: { ... } }`
- [ ] Добавлены переводы на все 6 языков: en, ru, sr, de, tr, sr-cyrl
- [ ] Все ключи идентичны во всех языках
- [ ] **Все ключи начинаются с заглавной буквы** (например, `PageTitle`, `BtnSave`)
- [ ] Добавлен комментарий с описанием
- [ ] Компонент импортирует переводы: `import messages from '~/i18n/[name]'`
- [ ] Инициализирован `useI18n` с `messages: messages.messages`
- [ ] Все жестко закодированные тексты заменены на `t('key')`
- [ ] Проверено отсутствие ошибок линтера
- [ ] Протестирована смена языка

## Категории ключей (рекомендуемые префиксы)

**⚠️ ВАЖНОЕ ПРАВИЛО:** Все ключи локализации должны начинаться с **ЗАГЛАВНОЙ буквы**.

Для лучшей организации используйте префиксы в ключах:

- **Заголовки:** `Title`, `Heading`, `PageTitle`
- **Кнопки:** `Btn[Action]`, например `BtnSave`, `BtnCancel`
- **Сообщения успеха:** `Success[Action]`, например `SuccessSaved`
- **Сообщения ошибок:** `Error[Action]`, например `ErrorSaving`
- **Подтверждения:** `Confirm[Action]`, например `ConfirmDelete`
- **Описания:** `Description`, `Hint`, `Tooltip`
- **Placeholder'ы:** `Placeholder[Field]`, например `PlaceholderEmail`
- **Метки полей:** `Label[Field]`, например `LabelName`
- **Валидация:** `Validation[Rule]`, например `ValidationRequired`

**Примеры правильного именования:**

- ✅ `PageTitle`, `BtnSubmit`, `SuccessMessage`, `ErrorSaving`
- ❌ `pageTitle`, `btnSubmit`, `successMessage`, `errorSaving`

## Пример структурированного файла

**⚠️ ВАЖНО:** Все ключи должны начинаться с заглавной буквы!

```typescript
export default {
	messages: {
		en: {
			// Page headers
			PageTitle: 'Page Title',
			PageDescription: 'Page description',

			// Form fields
			LabelEmail: 'Email',
			LabelPassword: 'Password',
			PlaceholderEmail: 'Enter your email',
			PlaceholderPassword: 'Enter your password',

			// Buttons
			BtnSubmit: 'Submit',
			BtnCancel: 'Cancel',
			BtnSave: 'Save',

			// Messages
			SuccessSaved: 'Successfully saved',
			ErrorSaving: 'Error saving',
			ConfirmDelete: 'Are you sure you want to delete?',

			// Validation
			ValidationRequired: 'This field is required',
			ValidationEmail: 'Invalid email format',
		},
		ru: {
			// Заголовки страницы
			PageTitle: 'Заголовок страницы',
			PageDescription: 'Описание страницы',

			// Поля формы
			LabelEmail: 'Email',
			LabelPassword: 'Пароль',
			PlaceholderEmail: 'Введите ваш email',
			PlaceholderPassword: 'Введите ваш пароль',

			// Кнопки
			BtnSubmit: 'Отправить',
			BtnCancel: 'Отмена',
			BtnSave: 'Сохранить',

			// Сообщения
			SuccessSaved: 'Успешно сохранено',
			ErrorSaving: 'Ошибка сохранения',
			ConfirmDelete: 'Вы уверены, что хотите удалить?',

			// Валидация
			ValidationRequired: 'Это поле обязательно',
			ValidationEmail: 'Неверный формат email',
		},
		// ... остальные языки (sr, de, tr, sr-cyrl)
	},
};
```

## Инструменты для перевода

Для ускорения создания переводов на sr, de, tr можно использовать:

- Google Translate
- DeepL (более качественные переводы для de)
- ChatGPT / Claude (для проверки и улучшения переводов)

**Важно:** Всегда проверяйте автоматические переводы, особенно для специфичных терминов и контекста приложения.

## Реальные примеры из проекта

### Пример 1: Простой компонент (один файл)

`pages/profile.vue` использует только `i18n/profile.ts`:

```typescript
import profileMessages from '~/i18n/profile';

const { t } = useI18n({
	useScope: 'local',
	messages: profileMessages.messages,
});
```

### Пример 2: Сложная страница (несколько файлов)

`pages/articles/russian-speaking-doctors-in-montenegro.vue` комбинирует 4 файла:

```typescript
import { combineI18nMessages } from '~/i18n/utils';
import articlesI18n from '~/i18n/articles';
import breadcrumbI18n from '~/i18n/breadcrumb';
import specialtyI18n from '~/i18n/specialty';
import cityI18n from '~/i18n/city';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		articlesI18n, // Тексты статей
		breadcrumbI18n, // Хлебные крошки
		specialtyI18n, // Названия специальностей врачей
		cityI18n, // Названия городов
	]),
});
```

Это позволяет использовать переводы специальностей и городов, которые используются во всем приложении, без дублирования.

### Когда что использовать?

| Ситуация                            | Решение             | Пример                                     |
| ----------------------------------- | ------------------- | ------------------------------------------ |
| Все тексты уникальны для компонента | Один файл переводов | `profile.vue` + `profile.ts`               |
| Используются города/специальности   | Комбинирование      | `articles.ts` + `city.ts` + `specialty.ts` |
| Нужны breadcrumbs                   | Комбинирование      | `page.ts` + `breadcrumb.ts`                |
| Общие UI элементы                   | Комбинирование      | `page.ts` + `common.ts`                    |
