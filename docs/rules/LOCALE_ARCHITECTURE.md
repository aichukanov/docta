# Архитектура локализации

## ⚠️ ВАЖНО: НЕ ТРОГАТЬ

Система локализации настроена и работает. **Не переносите конфигурацию из `i18n.config.ts` в `nuxt.config.ts`** - это сломает работу.

Это про runtime-конфиг vue-i18n (сообщения, форматы, `fallbackLocale`).
Опции самого модуля — другое дело: в `nuxt.config.ts` под ключом `i18n`
стоит `detectBrowserLanguage: false`, и стоит он там намеренно (см. ниже).

**Серверная часть ниже описана по состоянию до 2026-08-31.** С тех пор
сервер выбирает локаль ТОЛЬКО по адресу, cookie на ответ не влияет, а
предпочтение посетителя восстанавливает Cloudflare Worker. Актуальное описание
и причины — `docs/rules/EDGE_LOCALE_CACHE.md`; этот документ остаётся как
описание клиентской части и список запретов.

## Как работает система

### 1. Server-side (SSR)

**Файл:** `server/common/redirect/regional-settings.ts`

Обрабатывает локализацию на сервере при каждом HTTP запросе:

```typescript
function getLocaleForQuery(event): {
	locale: Locale;
	redirectStatus: 301 | 302 | null;
};
```

**Логика:**

- Читает cookie `locale` (НЕ `i18n_redirected`)
- Читает query параметр `?lang=XX`
- Делает редиректы при необходимости:
  - 301: если `?lang=sr` (дефолтная локаль) или устаревшие локали (ME, BA)
  - 302: если cookie отличается от query параметра

**Приоритет:**

1. Cookie `locale`
2. Query параметр `?lang=XX`
3. Дефолт: `sr`

### 2. Client-side (Vue/i18n)

**Файл:** `app.vue`

Устанавливает локаль для Vue компонентов:

```typescript
const queryLocale = getLocaleFromQuery(route.query.lang as string | string[]);
locale.value = queryLocale || defaultLocale;
```

**Локаль устанавливается явно в app.vue**, не через плагины или middleware.

### 3. i18n конфигурация

**Файл:** `i18n/i18n.config.ts`

```typescript
export default defineI18nConfig(() => ({
	locales,
	defaultLocale,
	fallbackLocale: 'sr',
	locale: defaultLocale,
	legacy: false,
	// ...
}));
```

**Cookie ровно одна — `locale`.** Её пишет переключатель языка, читает
`plugins/locale-preference.client.ts`.

Раньше рядом жила вторая, `i18n_redirected`: её писал `@nuxtjs/i18n` по
своему дефолту `detectBrowserLanguage.useCookie`, наш код её никогда не читал,
и этот документ называл такое соседство нормой. Это было терпимо до тех пор,
пока HTML не начали кэшировать на Cloudflare: **ответ с `Set-Cookie` не
кэшируется никогда**, и лишняя cookie в каждом первом ответе выключала кэш
для всех, кто приходит без cookie — то есть для каждого бота. С 2026-09-08 в
`nuxt.config.ts` стоит `detectBrowserLanguage: false`, а e2e-тест
`caching.spec.ts` следит, чтобы на кэшируемых маршрутах `Set-Cookie` не
появлялся. Подробно — `docs/rules/EDGE_LOCALE_CACHE.md`.

## Что НЕ нужно делать

❌ **НЕ создавайте плагины** для установки локали (типа `plugins/01.locale.client.ts`)
❌ **НЕ создавайте middleware** для установки локали (типа `middleware/locale.global.ts`)
❌ **НЕ переносите** настройки из `i18n.config.ts` в `nuxt.config.ts`
❌ **НЕ включайте** `detectBrowserLanguage` обратно — его `Set-Cookie` выключает кэш HTML на Cloudflare
❌ **НЕ используйте** `useI18n()` в плагинах - это вызовет ошибки

## Приоритет определения локали

### На сервере (regional-settings.ts):

1. **Локаль из профиля пользователя** (если залогинен) - запрос к БД
2. Cookie `locale`
3. Query `?lang=XX`
4. Дефолт `sr`

**✅ Важно:** Локаль определяется на сервере для SSR и передаётся клиенту - это решает проблему гидратации.

### На клиенте (app.vue):

Локаль просто читается из query параметра (установленного на сервере):

```typescript
const queryLocale = getLocaleFromQuery(route.query.lang);
locale.value = queryLocale || defaultLocale;
```

### Для залогиненных пользователей:

**Приоритет максимальный!** Если пользователь залогинен, его предпочитаемая локаль из БД (`auth_users.preferred_locale`) имеет наивысший приоритет и игнорирует cookie и query параметры.

**Проверка на сервере** (`regional-settings.ts`):

```typescript
const user = await getCurrentUser(event);
if (user?.id) {
	const userLocale = await getUserLocale(user.id, event);
	if (userLocale) {
		// Используем локаль из профиля
		// Cookie и query параметры игнорируются
		return { locale: userLocale, redirectStatus: null };
	}
}
```

**Сохранение через компонент** (`language-switcher.vue`):

- Сохраняет выбранную локаль в БД через API
- Обновляет cookie `locale`
- Обновляет `i18n.locale`

## Файлы системы локализации

```
server/
  common/redirect/
    regional-settings.ts      # ✅ Редиректы и логика на сервере
  middleware/
    redirect-routes.ts        # ✅ Вызывает fixUrlRegionalParams
  utils/
    user-locale.ts            # ✅ Утилиты для email (server-side)

i18n/
  i18n.config.ts              # ✅ Конфигурация @nuxtjs/i18n

app.vue                       # ✅ Установка locale для клиента

components/
  language-switcher.vue       # ✅ Переключатель языка (сохранение в БД)

composables/
  use-locale.ts               # ✅ Утилиты для работы с локалями
  use-user-locale.ts          # ✅ API для обновления локали пользователя
```

## Если нужно изменить локаль программно

```typescript
// В Vue компоненте
const { locale } = useI18n();
const { updateUserLocale } = useUserLocale();

// Изменить локаль и сохранить в БД (если залогинен)
await updateUserLocale('ru');

// Или просто изменить локаль (без сохранения в БД)
locale.value = 'ru';
```

## Тестирование

### Для незалогиненных пользователей:

```bash
# Открыть сайт с русской локалью
http://localhost:3000/?lang=ru

# Проверить редирект (должен убрать ?lang=sr)
http://localhost:3000/?lang=sr
# → редирект 301 на http://localhost:3000/

# Проверить cookie
# В DevTools → Application → Cookies после переключения языка — только locale=ru.
# Второй cookie (i18n_redirected) быть не должно: см. раздел про i18n выше.
```

### Для залогиненных пользователей:

```bash
# 1. Залогиниться
# 2. Изменить локаль через language-switcher на "Русский"
# 3. Обновить страницу
# → Должен загрузиться русский язык (из БД на сервере)

# 4. Попробовать открыть с другим query параметром
http://localhost:3000/?lang=en
# → Query параметр игнорируется, загружается русский (из БД)
# → Редирект НЕ происходит

# 5. Разлогиниться
# 6. Открыть http://localhost:3000/?lang=en
# → Теперь загружается английский (query параметр работает)

# 7. Проверить SSR (просмотреть исходный код страницы)
# → В HTML должен быть правильный язык
# → Нет "вспышки" неправильной локали при гидратации ✅
```

## E2E тесты

Автоматические end-to-end тесты находятся в `tests/e2e/locale.spec.ts`.

### Запуск тестов

```bash
# Запустить все тесты локализации
npm run test:e2e -- locale.spec.ts

# Запустить в headed режиме (с браузером)
npm run test:e2e -- locale.spec.ts --headed

# Запустить конкретный тест
npm run test:e2e -- locale.spec.ts -g "should load page with Russian locale"

# Запустить в debug режиме
npm run test:e2e -- locale.spec.ts --debug
```

### Покрытие тестами

#### ✅ Незалогиненные пользователи - Query параметры:

- Загрузка страницы с локалью из query параметра (`?lang=ru`, `?lang=en`)
- Проверка установки cookie
- Редирект от дефолтной локали (`?lang=sr` → `/`)
- Приоритет query параметра над cookie
- Использование cookie когда нет query параметра

#### ✅ Незалогиненные пользователи - Language Switcher:

- Переключение языка через компонент
- Сохранение выбранного языка после перезагрузки
- Сохранение языка при навигации между страницами

#### ✅ SSR и гидратация:

- Рендеринг правильной локали на сервере
- Отсутствие ошибок гидратации
- Одинаковая локаль на сервере и клиенте

#### 🔄 Залогиненные пользователи (требуют фикстур):

- Загрузка локали из БД при авторизации
- Игнорирование query параметра для залогиненных
- Сохранение локали в БД при изменении через switcher
- Использование query параметра после разлогина

#### ✅ Граничные случаи:

- Обработка невалидных локалей
- Множественные `lang` параметры в URL
- Удаление устаревших локалей (ME, BA) из cookie
- Изменение локали во время навигации

#### ✅ Производительность:

- Отсутствие layout shift при загрузке локали
- Быстрая загрузка локали из профиля

### Добавление фикстур для аутентификации

Для полноценного тестирования залогиненных пользователей используйте фикстуры из `tests/fixtures/auth.fixture.ts`:

```typescript
import { test } from '../fixtures/auth.fixture';

test('should load user locale from database', async ({ authenticatedPage }) => {
	// authenticatedPage уже содержит авторизованного пользователя
	await authenticatedPage.goto('/');

	const htmlLang = await authenticatedPage.getAttribute('html', 'lang');
	expect(htmlLang).toBe('ru'); // Локаль из профиля пользователя
});
```

**⚠️ TODO:** Фикстуры требуют реализации:

1. API для создания тестовых пользователей (`/api/test/create-user`)
2. Страница логина (`/login`)
3. Методы работы с сессиями в тестах

См. `tests/fixtures/auth.fixture.ts` для деталей.

## История изменений

- **Февраль 2026**: Исправлены ошибки импортов (`import type { Language }` → `import { Language }`)
- **Февраль 2026**: Добавлен импорт `getHeader` в `user-locale.ts`
- **Текущая версия**: Система работает стабильно, изменения не требуются
