# i18n Шпаргалка

Быстрая справка по интернационализации в проекте.

## 🚀 Быстрый старт

### 1. Один файл переводов

**⚠️ ВАЖНО:** Все ключи должны начинаться с заглавной буквы!

```typescript
// i18n/my-component.ts
export default {
	messages: {
		'en': { Greeting: 'Hello' },
		'ru': { Greeting: 'Привет' },
		'sr': { Greeting: 'Zdravo' },
		'de': { Greeting: 'Hallo' },
		'tr': { Greeting: 'Merhaba' },
		'sr-cyrl': { Greeting: 'Здраво' },
	},
};
```

```vue
<!-- pages/my-component.vue -->
<script setup lang="ts">
import messages from '~/i18n/my-component';
const { t } = useI18n({ useScope: 'local', messages: messages.messages });
</script>

<template>
	<h1>{{ t('Greeting') }}</h1>
</template>
```

### 2. Несколько файлов переводов

```vue
<script setup lang="ts">
import { combineI18nMessages } from '~/i18n/utils';
import pageMessages from '~/i18n/my-page';
import cityI18n from '~/i18n/city';
import breadcrumbI18n from '~/i18n/breadcrumb';

const { t } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([pageMessages, cityI18n, breadcrumbI18n]),
});
</script>

<template>
	<h1>{{ t('PageTitle') }}</h1>
	<span>{{ t('City_podgorica') }}</span>
	<nav>{{ t('BreadcrumbHome') }}</nav>
</template>
```

## 📋 Обязательные языки

Всегда включайте ВСЕ 6 языков:

| Код       | Язык         | Пример  |
| --------- | ------------ | ------- |
| `en`      | English      | Hello   |
| `ru`      | Русский      | Привет  |
| `sr`      | Srpski (lat) | Zdravo  |
| `de`      | Deutsch      | Hallo   |
| `tr`      | Türkçe       | Merhaba |
| `sr-cyrl` | Српски (ћир) | Здраво  |

## 🎯 Импорт

```typescript
// ✅ ПРАВИЛЬНО
import messages from '~/i18n/profile';
const { t } = useI18n({ useScope: 'local', messages: messages.messages });

// ❌ НЕПРАВИЛЬНО
import { messages } from '~/i18n/profile'; // named export
const { t } = useI18n({ useScope: 'local', messages }); // забыли .messages
```

## 🔧 Структура файла

```typescript
// ✅ ПРАВИЛЬНО
export default {
	messages: {
		en: { Key: 'value' },
		ru: { Key: 'значение' },
		// ... остальные языки
	},
};

// ❌ НЕПРАВИЛЬНО - ключи с маленькой буквы
export default {
	messages: {
		en: { key: 'value' },
		ru: { key: 'значение' },
	},
};

// ❌ НЕПРАВИЛЬНО - named export
export const messages = {
	en: { Key: 'value' },
	ru: { Key: 'значение' },
};
```

## 💡 Использование в коде

```typescript
// Сообщения
ElMessage.success(t('SuccessMessage'));
ElMessage.error(t('ErrorMessage'));
ElMessage.warning(t('WarningMessage'));

// Confirm диалоги
if (confirm(t('ConfirmDelete'))) { ... }

// Placeholder
<el-input :placeholder="t('PlaceholderEmail')" />

// Label
<el-form-item :label="t('LabelName')">

// Динамический текст
const statusText = computed(() => t(status.value ? 'Active' : 'Inactive'));
```

## 🔄 combineI18nMessages

**Когда использовать:**

- ✅ Нужны города/специальности/etc из существующих файлов
- ✅ Нужны breadcrumbs + тексты страницы
- ✅ Общие переводы + специфичные для страницы

**Когда НЕ использовать:**

- ❌ Все тексты уникальны для одного компонента
- ❌ Можно обойтись одним файлом

## 📦 Именование ключей

**⚠️ ВАЖНОЕ ПРАВИЛО:** Все ключи локализации должны начинаться с **ЗАГЛАВНОЙ буквы**.

Рекомендуемые префиксы:

```typescript
{
	// Заголовки (с заглавной буквы)
	PageTitle: '...',
	SectionTitle: '...',

	// Кнопки (с заглавной буквы)
	BtnSave: '...',
	BtnCancel: '...',

	// Сообщения (с заглавной буквы)
	SuccessSaved: '...',
	ErrorSaving: '...',

	// Подтверждения (с заглавной буквы)
	ConfirmDelete: '...',

	// Формы (с заглавной буквы)
	LabelEmail: '...',
	PlaceholderEmail: '...',

	// Валидация (с заглавной буквы)
	ValidationRequired: '...',
	ValidationEmail: '...',
}
```

**Примеры:**

- ✅ `PageTitle`, `BtnSave`, `SuccessMessage`
- ❌ `pageTitle`, `btnSave`, `successMessage`

## ⚡ Чек-лист

- [ ] Файл экспортирует `export default { messages: {...} }`
- [ ] Все 6 языков присутствуют (en, ru, sr, de, tr, sr-cyrl)
- [ ] Все ключи идентичны во всех языках
- [ ] **Все ключи начинаются с заглавной буквы** (например, `PageTitle`, `BtnSave`)
- [ ] Импорт в компоненте: `import messages from '~/i18n/[name]'`
- [ ] Инициализация: `messages: messages.messages` или `combineI18nMessages([...])`
- [ ] Все тексты заменены на `t('key')` или `{{ t('key') }}`
- [ ] Нет ошибок линтера
- [ ] Протестирована смена языка

## 📚 Документация

- `docs/PROFILE_I18N.md` - Подробная документация
- `docs/I18N_TEMPLATE.md` - Шаблоны и примеры
- `docs/I18N_CHEATSHEET.md` - Эта шпаргалка

## 🔗 Примеры в проекте

| Файл                                                        | Тип              |
| ----------------------------------------------------------- | ---------------- |
| `pages/profile.vue`                                         | Один файл        |
| `pages/articles/russian-speaking-doctors-in-montenegro.vue` | Комбинирование   |
| `i18n/profile.ts`                                           | Шаблон структуры |
