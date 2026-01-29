# Итерация 4: UI компоненты - блок пользователя в хэдере

[← К списку итераций](README.md) | [← Предыдущая](iteration-03-oauth-telegram.md)

---

## Цель

Создать UI для входа/выхода и блок пользователя в хэдере с dropdown меню.

## Зависимости

Итерации 2-3 (OAuth провайдеры работают)

## Задачи

1. Создать компонент LoginModal с кнопками OAuth
2. Создать компонент UserMenu для хэдера (аватар + dropdown)
3. Создать базовый middleware для защиты страниц
4. Интегрировать компоненты в layout

## Технические детали

### Создать файл: `components/auth/LoginModal.vue`

**Назначение:** Модальное окно для входа с выбором OAuth провайдера.

**Функционал:**

- Кнопка "Войти через Google"
- Кнопка "Войти через Telegram"
- Закрытие модального окна
- Индикация загрузки во время OAuth flow

```vue
<template>
	<el-dialog v-model="isOpen" title="Вход" width="400px">
		<div class="oauth-buttons">
			<el-button type="primary" @click="signIn('google')" :loading="loading">
				<img src="/google-icon.svg" class="oauth-icon" />
				Войти через Google
			</el-button>

			<el-button type="primary" @click="signIn('telegram')" :loading="loading">
				<img src="/tg.png" class="oauth-icon" />
				Войти через Telegram
			</el-button>
		</div>
	</el-dialog>
</template>

<script setup lang="ts">
import { signIn } from '#auth';

const props = defineProps<{
	modelValue: boolean;
}>();

const emit = defineEmits<{
	'update:modelValue': [value: boolean];
}>();

const isOpen = computed({
	get: () => props.modelValue,
	set: (value) => emit('update:modelValue', value),
});

const loading = ref(false);

async function handleSignIn(provider: 'google' | 'telegram') {
	loading.value = true;
	try {
		await signIn(provider, { callbackUrl: '/' });
	} catch (error) {
		console.error('Sign in error:', error);
		ElMessage.error('Ошибка при входе');
	} finally {
		loading.value = false;
	}
}
</script>

<style scoped>
.oauth-buttons {
	display: flex;
	flex-direction: column;
	gap: 12px;
}

.oauth-icon {
	width: 20px;
	height: 20px;
	margin-right: 8px;
}
</style>
```

### Создать файл: `components/auth/UserMenu.vue`

**Назначение:** Блок пользователя в хэдере с dropdown меню.

**Функционал:**

- Аватар пользователя
- Имя пользователя (при наведении)
- Dropdown меню с опциями
- Автоматический logout

```vue
<template>
	<div class="user-menu">
		<!-- Для неавторизованных пользователей -->
		<el-button
			v-if="status === 'unauthenticated'"
			type="primary"
			@click="emit('login')"
		>
			Войти
		</el-button>

		<!-- Для авторизованных пользователей -->
		<el-dropdown v-else-if="status === 'authenticated'" trigger="click">
			<div class="user-avatar-block">
				<el-avatar :src="session.user?.image" :size="40">
					{{ session.user?.name?.[0]?.toUpperCase() || '?' }}
				</el-avatar>
				<span class="user-name">{{ session.user?.name }}</span>
			</div>

			<template #dropdown>
				<el-dropdown-menu>
					<el-dropdown-item @click="navigateTo('/profile')">
						<el-icon><User /></el-icon>
						Мой профиль
					</el-dropdown-item>

					<el-dropdown-item divided @click="handleSignOut">
						<el-icon><SwitchButton /></el-icon>
						Выйти
					</el-dropdown-item>
				</el-dropdown-menu>
			</template>
		</el-dropdown>
	</div>
</template>

<script setup lang="ts">
import { User, SwitchButton } from '@element-plus/icons-vue';

const { status, data: session, signOut } = useAuth();

const emit = defineEmits<{
	login: [];
}>();

async function handleSignOut() {
	try {
		await signOut({ callbackUrl: '/' });
		ElMessage.success('Вы вышли из системы');
	} catch (error) {
		console.error('Sign out error:', error);
		ElMessage.error('Ошибка при выходе');
	}
}
</script>

<style scoped>
.user-menu {
	display: flex;
	align-items: center;
}

.user-avatar-block {
	display: flex;
	align-items: center;
	gap: 12px;
	cursor: pointer;
	padding: 4px 12px;
	border-radius: 8px;
	transition: background-color 0.2s;
}

.user-avatar-block:hover {
	background-color: #f5f5f5;
}

.user-name {
	font-size: 14px;
	font-weight: 500;
	max-width: 150px;
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
}

@media (max-width: 768px) {
	.user-name {
		display: none;
	}
}
</style>
```

### Создать файл: `middleware/auth.ts`

**Назначение:** Базовая защита страниц (требует авторизации).

```typescript
export default defineNuxtRouteMiddleware((to, from) => {
	const { status } = useAuth();

	if (status.value === 'unauthenticated') {
		return navigateTo('/login?redirect=' + encodeURIComponent(to.path));
	}
});
```

### Обновить: `layouts/default.vue`

**Интеграция:** Добавить UserMenu в хэдер.

```vue
<template>
	<div class="layout">
		<header class="header">
			<div class="header-content">
				<nuxt-link to="/" class="logo">
					<img src="/logo.svg" alt="docta.me" />
				</nuxt-link>

				<nav class="nav">
					<!-- Существующая навигация -->
				</nav>

				<!-- НОВОЕ: Блок пользователя -->
				<AuthUserMenu @login="showLoginModal = true" />
			</div>
		</header>

		<main class="main">
			<slot />
		</main>

		<footer class="footer">
			<!-- Существующий footer -->
		</footer>

		<!-- НОВОЕ: Модальное окно входа -->
		<AuthLoginModal v-model="showLoginModal" />
	</div>
</template>

<script setup lang="ts">
const showLoginModal = ref(false);
</script>

<style scoped>
.header {
	background: white;
	border-bottom: 1px solid #e5e5e5;
	padding: 16px 24px;
}

.header-content {
	max-width: 1200px;
	margin: 0 auto;
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 24px;
}

.logo img {
	height: 40px;
}

.nav {
	flex: 1;
	display: flex;
	gap: 24px;
}

@media (max-width: 768px) {
	.nav {
		display: none;
	}
}
</style>
```

## Критерии приемки

- [ ] AC-1: Кнопка "Войти" открывает модальное окно с OAuth провайдерами
- [ ] AC-2: После успешного входа кнопка меняется на UserMenu с аватаром
- [ ] AC-3: Клик по аватару открывает dropdown с опциями
- [ ] AC-4: Опция "Мой профиль" ведет на /profile
- [ ] AC-5: Опция "Выйти" корректно завершает сессию и показывает сообщение
- [ ] AC-6: После выхода UserMenu меняется обратно на кнопку "Войти"
- [ ] AC-7: Middleware auth защищает страницу /profile (редирект на login)
- [ ] AC-8: После успешного login происходит редирект обратно на защищенную страницу
- [ ] AC-9: UI адаптивен на мобильных (имя пользователя скрывается)
- [ ] AC-10: Аватар показывает первую букву имени если нет фото
- [ ] AC-11: Индикация загрузки во время OAuth flow

## Как проверить

1. **Открыть главную страницу (неавторизованный):**

   - Должна быть кнопка "Войти"

2. **Нажать "Войти":**

   - Должно открыться модальное окно
   - Должны быть кнопки для Google и Telegram

3. **Войти через Google или Telegram:**

   - Должен произойти OAuth flow
   - После успешного входа модальное окно закрывается
   - Кнопка "Войти" меняется на UserMenu

4. **Проверить UserMenu:**

   - Должен показываться аватар пользователя
   - Должно показываться имя пользователя (на десктопе)
   - Клик должен открывать dropdown

5. **Проверить dropdown:**

   - Должна быть опция "Мой профиль"
   - Должна быть опция "Выйти"
   - Клик на "Мой профиль" → переход на /profile
   - Клик на "Выйти" → logout и сообщение "Вы вышли"

6. **Проверить middleware:**

   - Выйти из системы
   - Попробовать открыть /profile
   - Должен произойти редирект на /login?redirect=/profile
   - После входа должен вернуть на /profile

7. **Проверить на мобильном:**

   - Аватар должен быть виден
   - Имя пользователя должно быть скрыто
   - Dropdown должен работать

8. **Проверить edge cases:**
   - Пользователь без фото → показывается первая буква имени
   - Пользователь без имени → показывается "?"
   - Медленный интернет → показывается индикация загрузки

## Статус

**Not Started**

---

**Итерация завершена!** Базовая авторизация через OAuth готова к использованию.

**Следующие шаги:**

- Создать другие PRD (user-profile, doctor-profile, clinic-profile)
- Позже добавить в auth PRD: email/password авторизацию
