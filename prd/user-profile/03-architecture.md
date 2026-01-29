# 3. Архитектура

[← Назад к оглавлению](index.md)

---

## 3.1 Технический стек

- **Frontend:** Nuxt 3, Vue 3 Composition API
- **UI:** Element Plus
- **State:** Pinia (userProfileStore)
- **Backend:** Nuxt 3 Server API
- **Database:** MySQL
- **Auth:** @sidebase/nuxt-auth

## 3.2 API Endpoints

### Профиль пользователя

- `GET /api/user/profile` - Получить профиль текущего пользователя
- `PUT /api/user/profile` - Обновить имя пользователя

### OAuth управление

- `GET /api/user/oauth-accounts` - Список привязанных OAuth аккаунтов
- `POST /api/user/oauth-accounts/link` - Инициировать привязку нового OAuth
- `DELETE /api/user/oauth-accounts/:id` - Удалить OAuth привязку

### Приватность

- `GET /api/user/privacy` - Получить настройки приватности
- `PUT /api/user/privacy` - Обновить настройки приватности

### Публичный профиль

- `GET /api/user/public-profile/:userId` - Получить публичный профиль пользователя (для будущих комментариев)

## 3.3 Frontend Компоненты

### Pages

- `pages/profile/index.vue` - Главная страница профиля
- `pages/profile/preview.vue` - Предпросмотр публичного профиля (модальное окно)

### Components

- `components/user/ProfileForm.vue` - Форма редактирования профиля (имя)
- `components/user/OAuthAccountsList.vue` - Список OAuth аккаунтов с кнопками управления
- `components/user/OAuthAddButton.vue` - Кнопка добавления OAuth
- `components/user/PrivacySettings.vue` - Настройки приватности (public/private toggle)
- `components/user/PublicProfilePreview.vue` - Предпросмотр как выглядит профиль для других
- `components/user/MaskedEmail.vue` - Отображение маскированного email

### Stores

```typescript
// stores/userProfile.ts
export const useUserProfileStore = defineStore('userProfile', () => {
  const profile = ref(null)
  const oauthAccounts = ref([])
  const privacySettings = ref({ isPublic: true })

  async function fetchProfile() { ... }
  async function updateProfile(data) { ... }
  async function fetchOAuthAccounts() { ... }
  async function deleteOAuthAccount(id) { ... }
  async function updatePrivacySettings(settings) { ... }

  return { profile, oauthAccounts, privacySettings, ... }
})
```

## 3.4 Утилиты

### Email Masking

```typescript
// utils/emailMasking.ts
export function maskEmail(email: string): string {
	const [localPart, domain] = email.split('@');
	if (!localPart || !domain) return email;

	const maskedLocal = localPart[0] + '*****';

	const [domainName, ...extensions] = domain.split('.');
	const maskedDomain = domainName[0] + '****';
	const maskedExtension = extensions
		.map((ext) => (ext.length <= 2 ? ext : '*' + ext.slice(1)))
		.join('.');

	return `${maskedLocal}@${maskedDomain}.${maskedExtension}`;
}

// Примеры:
// maskEmail('user@gmail.com') // 'u*****@g****.**m'
// maskEmail('admin@example.org') // 'a*****@e****.*rg'
```

## 3.5 Диаграммы

### Структура страницы профиля

```
┌─────────────────────────────────────────┐
│        Страница /profile                │
├─────────────────────────────────────────┤
│ ┌─────────────────────────────────────┐ │
│ │  ProfileForm                        │ │
│ │  - Фото (из OAuth)                  │ │
│ │  - Имя (editable)                   │ │
│ │  - Email (readonly)                 │ │
│ │  [Сохранить]                        │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ ┌─────────────────────────────────────┐ │
│ │  OAuthAccountsList                  │ │
│ │  ┌───────────────────────────────┐  │ │
│ │  │ Google: user@gmail.com        │  │ │
│ │  │ 29.01.2026  [Удалить]         │  │ │
│ │  └───────────────────────────────┘  │ │
│ │  [+ Добавить OAuth провайдер]       │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ ┌─────────────────────────────────────┐ │
│ │  PrivacySettings                    │ │
│ │  ○ Публичный профиль                │ │
│ │  ○ Приватный профиль                │ │
│ │  [Предпросмотр]                     │ │
│ └─────────────────────────────────────┘ │
└─────────────────────────────────────────┘
```

### Flow добавления OAuth

```
[Пользователь] → [Кнопка "Добавить OAuth"]
       ↓
[Выбор провайдера: Google / Telegram]
       ↓
[OAuth flow] → [Callback]
       ↓
[Привязка к текущему user_id]
       ↓
[Обновление списка OAuth аккаунтов]
       ↓
[Toast: "OAuth успешно добавлен"]
```

### Flow удаления OAuth

```
[Пользователь] → [Кнопка "Удалить" на OAuth]
       ↓
[Проверка: это последний OAuth?]
       ↓ Нет                    ↓ Да
[Подтверждение]       [Предупреждение: нельзя удалить последний]
       ↓
[DELETE /api/user/oauth-accounts/:id]
       ↓
[Обновление списка]
       ↓
[Toast: "OAuth удален"]
```

---

**Предыдущая секция:** [← 2. Требования](02-requirements.md)  
**Следующая секция:** [4. База данных →](04-database.md)
