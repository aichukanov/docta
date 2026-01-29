# Итерация 1: Страница профиля (базовая)

[← К списку итераций](README.md) | [Следующая →](iteration-02-oauth-management.md)

---

## Цель

Создать базовую страницу профиля пользователя `/profile` с отображением и редактированием имени.

## Зависимости

- auth PRD завершен (пользователи могут авторизоваться через OAuth)

## Задачи

1. Создать миграцию БД (добавить поля в users)
2. Создать API endpoint для профиля
3. Создать страницу `/profile`
4. Создать компонент ProfileForm
5. Создать Pinia store для профиля
6. Защитить страницу middleware

## Технические детали

### 1. Миграция: `server/sql/migrations/003_user_profile.sql`

```sql
ALTER TABLE users
ADD COLUMN display_name VARCHAR(100) AFTER name,
ADD COLUMN is_profile_public BOOLEAN DEFAULT TRUE AFTER photo_url,
ADD COLUMN updated_profile_at TIMESTAMP NULL AFTER updated_at;
```

### 2. API: `server/api/user/profile.get.ts`

```typescript
export default defineEventHandler(async (event) => {
	const session = await getServerSession(event);
	if (!session?.user?.id) {
		throw createError({ statusCode: 401, message: 'Unauthorized' });
	}

	const user = await db.query(
		'SELECT id, email, name, display_name, photo_url, is_profile_public FROM users WHERE id = ?',
		[session.user.id],
	);

	return user[0];
});
```

### 3. API: `server/api/user/profile.put.ts`

```typescript
export default defineEventHandler(async (event) => {
	const session = await getServerSession(event);
	if (!session?.user?.id) {
		throw createError({ statusCode: 401, message: 'Unauthorized' });
	}

	const body = await readBody(event);
	const { display_name } = body;

	// Validation
	if (!display_name || display_name.length < 2 || display_name.length > 100) {
		throw createError({ statusCode: 400, message: 'Invalid display name' });
	}

	await db.query(
		'UPDATE users SET display_name = ?, updated_profile_at = NOW() WHERE id = ?',
		[display_name, session.user.id],
	);

	return { success: true };
});
```

### 4. Store: `stores/userProfile.ts`

```typescript
export const useUserProfileStore = defineStore('userProfile', () => {
	const profile = ref(null);
	const isLoading = ref(false);

	async function fetchProfile() {
		isLoading.value = true;
		try {
			profile.value = await $fetch('/api/user/profile');
		} finally {
			isLoading.value = false;
		}
	}

	async function updateProfile(data) {
		await $fetch('/api/user/profile', {
			method: 'PUT',
			body: data,
		});
		await fetchProfile();
	}

	return { profile, isLoading, fetchProfile, updateProfile };
});
```

### 5. Page: `pages/profile/index.vue`

```vue
<template>
	<div class="profile-page">
		<h1>Мой профиль</h1>
		<UserProfileForm v-if="profile" :profile="profile" @save="handleSave" />
	</div>
</template>

<script setup lang="ts">
definePageMeta({
	middleware: 'auth', // Требует авторизации
});

const profileStore = useUserProfileStore();
const { profile, isLoading } = storeToRefs(profileStore);

await profileStore.fetchProfile();

async function handleSave(data) {
	await profileStore.updateProfile(data);
	ElMessage.success('Профиль обновлен');
}
</script>
```

### 6. Component: `components/user/ProfileForm.vue`

```vue
<template>
	<el-form :model="form" label-width="120px">
		<el-form-item label="Фото">
			<el-avatar :src="profile.photo_url" :size="80">
				{{ profile.name?.[0] }}
			</el-avatar>
			<span class="photo-hint">Фото берется из OAuth провайдера</span>
		</el-form-item>

		<el-form-item label="Email">
			<el-input :value="profile.email" disabled />
		</el-form-item>

		<el-form-item label="Имя">
			<el-input v-model="form.display_name" />
		</el-form-item>

		<el-form-item>
			<el-button type="primary" @click="save">Сохранить</el-button>
		</el-form-item>
	</el-form>
</template>

<script setup lang="ts">
const props = defineProps<{ profile: any }>();
const emit = defineEmits<{ save: [data: any] }>();

const form = reactive({
	display_name: props.profile.display_name || props.profile.name,
});

function save() {
	emit('save', form);
}
</script>
```

## Критерии приемки

- [ ] AC-1: Страница `/profile` доступна только авторизованным пользователям
- [ ] AC-2: На странице отображается: фото, email, имя
- [ ] AC-3: Фото берется из OAuth провайдера
- [ ] AC-4: Email нельзя редактировать (disabled input)
- [ ] AC-5: Имя можно редактировать (display_name)
- [ ] AC-6: Кнопка "Сохранить" обновляет display_name в БД
- [ ] AC-7: После сохранения показывается успешное сообщение
- [ ] AC-8: Валидация: имя 2-100 символов
- [ ] AC-9: При ошибке валидации показывается сообщение об ошибке

## Как проверить

1. Войти через OAuth (Google или Telegram)
2. Перейти на `/profile` - должна открыться страница профиля
3. Проверить отображение фото, email, имени
4. Попробовать отредактировать email - должно быть disabled
5. Изменить имя и нажать "Сохранить"
6. Проверить, что показалось сообщение "Профиль обновлен"
7. Перезагрузить страницу - новое имя должно сохраниться
8. Проверить валидацию: пустое имя, слишком короткое (<2), слишком длинное (>100)
9. Выйти и попробовать открыть `/profile` - должен редирект на login

## Статус

📝 **Planning**

---

**Следующая итерация:** [2. Управление OAuth →](iteration-02-oauth-management.md)
