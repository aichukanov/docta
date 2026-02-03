<script setup lang="ts">
import profileMessages from '~/i18n/profile';

definePageMeta({
	middleware: 'auth',
	layout: 'default',
});

const { currentUser, isAdmin, logout } = useAuth();

// Инициализация i18n с локальными сообщениями
const { t } = useI18n({
	useScope: 'local',
	messages: profileMessages.messages,
});

// Получаем информацию о привязанных OAuth аккаунтах
const { data: oauthAccounts, refresh: refreshAccounts } = await useFetch(
	'/api/auth/accounts',
);

// Получаем полные OAuth профили
const { data: oauthProfiles, refresh: refreshOAuthProfiles } = await useFetch(
	'/api/auth/oauth-profiles',
);

// Получаем список активных сессий
const { data: sessions, refresh: refreshSessions } = await useFetch(
	'/api/auth/sessions',
);

// Получаем историю входов
const { data: loginHistory, refresh: refreshLoginHistory } = await useFetch(
	'/api/auth/login-history',
);

const isLoading = ref(false);
const showLoginHistoryDialog = ref(false);

// Форма смены пароля
const passwordForm = ref({
	currentPassword: '',
	newPassword: '',
	confirmPassword: '',
});

const showPasswordDialog = ref(false);
const passwordError = ref<string | null>(null);

// Формы редактирования профиля
const showEditNameDialog = ref(false);
const showEditEmailDialog = ref(false);
const editNameForm = ref({ name: '' });
const editEmailForm = ref({ newEmail: '' });
const editError = ref<string | null>(null);

// Проверяем есть ли у пользователя пароль
const userHasPassword = computed(() => {
	return oauthAccounts.value?.some(
		(acc: any) =>
			acc.provider === 'email' ||
			(currentUser.value?.email?.includes('@') &&
				!currentUser.value?.email?.includes('telegram_')),
	);
});

async function handleLogout() {
	try {
		isLoading.value = true;
		await logout();
	} catch (error) {
		console.error('Logout error:', error);
	} finally {
		isLoading.value = false;
	}
}

async function unlinkAccount(provider: string) {
	const confirmMessage =
		provider === 'google'
			? t('confirmUnlinkGoogle')
			: t('confirmUnlinkTelegram');

	if (!confirm(confirmMessage)) {
		return;
	}

	try {
		isLoading.value = true;
		await $fetch(`/api/auth/unlink/${provider}`, {
			method: 'POST',
		});
		await refreshAccounts();
		ElMessage.success(t('accountUnlinked'));
	} catch (error) {
		console.error('Unlink error:', error);
		ElMessage.error(t('errorUnlinkAccount'));
	} finally {
		isLoading.value = false;
	}
}

function linkGoogle() {
	sessionStorage.setItem('auth_redirect', '/profile');
	window.location.href = '/api/auth/google';
}

const hasGoogle = computed(() =>
	oauthAccounts.value?.some((acc: any) => acc.provider === 'google'),
);

const hasTelegram = computed(() =>
	oauthAccounts.value?.some((acc: any) => acc.provider === 'telegram'),
);

// Получение детальных данных профиля
const googleProfile = computed(() => oauthProfiles.value?.google);
const telegramProfile = computed(() => oauthProfiles.value?.telegram);
const primaryProvider = computed(() => oauthProfiles.value?.primaryProvider);

async function setPrimaryProvider(provider: string) {
	try {
		isLoading.value = true;
		await $fetch('/api/auth/set-primary-provider', {
			method: 'POST',
			body: { provider },
		});
		await refreshOAuthProfiles();
		ElMessage.success(t('primaryProviderUpdated'));
	} catch (error) {
		console.error('Set primary provider error:', error);
		ElMessage.error(t('errorUpdatePriority'));
	} finally {
		isLoading.value = false;
	}
}

// Смена пароля
async function handleChangePassword() {
	passwordError.value = null;

	if (!passwordForm.value.newPassword || !passwordForm.value.confirmPassword) {
		passwordError.value = t('allFieldsRequired');
		return;
	}

	if (passwordForm.value.newPassword !== passwordForm.value.confirmPassword) {
		passwordError.value = t('passwordsNotMatch');
		return;
	}

	try {
		isLoading.value = true;
		await $fetch('/api/auth/change-password', {
			method: 'POST',
			body: {
				currentPassword: passwordForm.value.currentPassword,
				newPassword: passwordForm.value.newPassword,
				confirmPassword: passwordForm.value.confirmPassword,
			},
		});

		ElMessage.success(t('passwordChanged'));
		showPasswordDialog.value = false;
		passwordForm.value = {
			currentPassword: '',
			newPassword: '',
			confirmPassword: '',
		};
	} catch (error: any) {
		console.error('Change password error:', error);
		passwordError.value = error.data?.statusMessage || t('errorChangePassword');
	} finally {
		isLoading.value = false;
	}
}

// Управление сессиями
async function deleteSession(sessionId: string) {
	if (!confirm(t('confirmDeleteSession'))) {
		return;
	}

	try {
		isLoading.value = true;
		await $fetch(`/api/auth/sessions/${sessionId}`, {
			method: 'DELETE',
		});
		await refreshSessions();
		ElMessage.success(t('sessionDeleted'));
	} catch (error) {
		console.error('Delete session error:', error);
		ElMessage.error(t('errorDeleteSession'));
	} finally {
		isLoading.value = false;
	}
}

async function logoutAllOtherSessions() {
	if (!confirm(t('confirmLogoutAll'))) {
		return;
	}

	try {
		isLoading.value = true;
		await $fetch('/api/auth/sessions/logout-all', {
			method: 'POST',
		});
		await refreshSessions();
		ElMessage.success(t('allSessionsDeleted'));
	} catch (error) {
		console.error('Logout all error:', error);
		ElMessage.error(t('errorLogoutAll'));
	} finally {
		isLoading.value = false;
	}
}

function formatDate(timestamp: number) {
	return new Date(timestamp * 1000).toLocaleString('ru-RU');
}

function formatLoginMethod(method: string): string {
	const methods: Record<string, string> = {
		email: t('emailMethod'),
		google: t('googleMethod'),
		telegram: t('telegramMethod'),
	};
	return methods[method] || method;
}

function getDeviceInfo(userAgent: string): string {
	if (!userAgent) return t('unknownDevice');

	// Простая детекция устройств
	if (userAgent.includes('Mobile')) return t('mobileDevice');
	if (userAgent.includes('Tablet')) return t('tablet');
	return t('computer');
}

// Редактирование имени
function openEditName() {
	editNameForm.value.name = currentUser.value?.name || '';
	editError.value = null;
	showEditNameDialog.value = true;
}

async function handleUpdateName() {
	editError.value = null;

	if (!editNameForm.value.name.trim()) {
		editError.value = t('nameEmpty');
		return;
	}

	try {
		isLoading.value = true;
		await $fetch('/api/auth/update-name', {
			method: 'POST',
			body: { name: editNameForm.value.name },
		});

		ElMessage.success(t('nameUpdated'));
		showEditNameDialog.value = false;

		// Обновляем данные пользователя
		const { fetchUser } = useAuth();
		await fetchUser();
	} catch (error: any) {
		console.error('Update name error:', error);
		editError.value = error.data?.statusMessage || t('errorUpdateName');
	} finally {
		isLoading.value = false;
	}
}

// Редактирование email
function openEditEmail() {
	editEmailForm.value.newEmail = '';
	editError.value = null;
	showEditEmailDialog.value = true;
}

async function handleRequestEmailChange() {
	editError.value = null;

	if (!editEmailForm.value.newEmail.trim()) {
		editError.value = t('enterNewEmail');
		return;
	}

	try {
		isLoading.value = true;
		const response = await $fetch('/api/auth/request-email-change', {
			method: 'POST',
			body: { newEmail: editEmailForm.value.newEmail },
		});

		ElMessage.success(t('emailChangeSent'));
		showEditEmailDialog.value = false;

		// В development показываем ссылку
		if (response.confirmUrl) {
			console.log('Confirmation URL:', response.confirmUrl);
		}
	} catch (error: any) {
		console.error('Request email change error:', error);
		editError.value = error.data?.statusMessage || t('errorRequestEmailChange');
	} finally {
		isLoading.value = false;
	}
}
</script>

<template>
	<div class="profile-page">
		<div class="profile-container">
			<el-card class="profile-card">
				<template #header>
					<div class="card-header">
						<h1>{{ t('profileTitle') }}</h1>
					</div>
				</template>

				<!-- Информация о пользователе -->
				<div class="user-section">
					<div class="user-avatar-section">
						<img
							v-if="currentUser?.photo_url"
							:src="currentUser.photo_url"
							:alt="currentUser.name"
							class="user-avatar"
						/>
						<div v-else class="user-avatar-placeholder">
							{{ currentUser?.name?.charAt(0).toUpperCase() }}
						</div>
					</div>

					<div class="user-info">
						<div class="user-info-header">
							<div>
								<h2>{{ currentUser?.name }}</h2>
								<p v-if="currentUser?.username" class="username">
									@{{ currentUser.username }}
								</p>
								<p class="email">{{ currentUser?.email }}</p>
							</div>
							<div class="edit-buttons">
								<el-button
									type="primary"
									size="small"
									text
									@click="openEditName"
								>
									<el-icon><Edit /></el-icon>
									{{ t('editName') }}
								</el-button>
								<el-button
									type="primary"
									size="small"
									text
									@click="openEditEmail"
								>
									<el-icon><Edit /></el-icon>
									{{ t('editEmail') }}
								</el-button>
							</div>
						</div>
						<el-tag v-if="isAdmin" type="danger" size="large">
							{{ t('administrator') }}
						</el-tag>
						<el-tag v-else type="success" size="large">
							{{ t('user') }}
						</el-tag>
					</div>
				</div>

				<el-divider />

				<!-- Привязанные аккаунты -->
				<div class="oauth-section">
					<h3>{{ t('linkedAccounts') }}</h3>
					<p class="section-description">
						{{ t('linkedAccountsDescription') }}
					</p>

					<div class="oauth-accounts">
						<!-- Google Account -->
						<div class="oauth-account-item">
							<div class="oauth-info">
								<svg
									width="24"
									height="24"
									viewBox="0 0 18 18"
									xmlns="http://www.w3.org/2000/svg"
									class="provider-icon"
								>
									<path
										d="M17.64 9.2c0-.637-.057-1.251-.164-1.84H9v3.481h4.844c-.209 1.125-.843 2.078-1.796 2.717v2.258h2.908c1.702-1.567 2.684-3.874 2.684-6.615z"
										fill="#4285F4"
									/>
									<path
										d="M9.003 18c2.43 0 4.467-.806 5.956-2.184l-2.908-2.258c-.806.54-1.837.86-3.048.86-2.344 0-4.328-1.584-5.036-3.711H.957v2.332C2.438 15.983 5.482 18 9.003 18z"
										fill="#34A853"
									/>
									<path
										d="M3.964 10.712c-.18-.54-.282-1.117-.282-1.71 0-.593.102-1.17.282-1.71V4.96H.957C.347 6.175 0 7.55 0 9.002c0 1.452.348 2.827.957 4.042l3.007-2.332z"
										fill="#FBBC05"
									/>
									<path
										d="M9.003 3.58c1.321 0 2.508.454 3.44 1.345l2.582-2.58C13.464.891 11.426 0 9.002 0 5.482 0 2.438 2.017.957 4.958L3.964 7.29c.708-2.127 2.692-3.71 5.036-3.71z"
										fill="#EA4335"
									/>
								</svg>
								<div>
									<div class="provider-name">Google</div>
									<div v-if="hasGoogle" class="provider-status connected">
										{{ t('connected') }}
										<el-tag
											v-if="primaryProvider === 'google'"
											type="success"
											size="small"
											style="margin-left: 8px"
										>
											{{ t('primary') }}
										</el-tag>
									</div>
									<div v-else class="provider-status">
										{{ t('notConnected') }}
									</div>
									<!-- Детальная информация Google профиля -->
									<div v-if="googleProfile" class="provider-details">
										<div v-if="googleProfile.email"
											>{{ t('email') }}: {{ googleProfile.email }}</div
										>
										<div v-if="googleProfile.given_name"
											>{{ t('firstName') }}: {{ googleProfile.given_name }}</div
										>
										<div v-if="googleProfile.family_name"
											>{{ t('lastName') }}: {{ googleProfile.family_name }}</div
										>
										<div v-if="googleProfile.locale"
											>{{ t('locale') }}: {{ googleProfile.locale }}</div
										>
										<div v-if="googleProfile.verified_email">
											<el-tag type="success" size="small">{{
												t('emailVerified')
											}}</el-tag>
										</div>
									</div>
								</div>
							</div>
							<el-button
								v-if="hasGoogle"
								type="danger"
								plain
								:loading="isLoading"
								@click="unlinkAccount('google')"
							>
								{{ t('unlink') }}
							</el-button>
							<div v-else>
								<el-button
									type="primary"
									plain
									:loading="isLoading"
									@click="linkGoogle"
								>
									{{ t('link') }}
								</el-button>
							</div>
							<!-- Кнопка сделать основным -->
							<el-button
								v-if="hasGoogle && primaryProvider !== 'google'"
								type="success"
								plain
								size="small"
								:loading="isLoading"
								@click="setPrimaryProvider('google')"
							>
								{{ t('setPrimary') }}
							</el-button>
						</div>

						<!-- Telegram Account -->
						<div class="oauth-account-item">
							<div class="oauth-info">
								<svg
									class="provider-icon"
									width="24"
									height="24"
									viewBox="0 0 24 24"
									fill="#54a9eb"
								>
									<path
										d="M11.944 0A12 12 0 0 0 0 12a12 12 0 0 0 12 12 12 12 0 0 0 12-12A12 12 0 0 0 12 0a12 12 0 0 0-.056 0zm4.962 7.224c.1-.002.321.023.465.14a.506.506 0 0 1 .171.325c.016.093.036.306.02.472-.18 1.898-.962 6.502-1.36 8.627-.168.9-.499 1.201-.82 1.23-.696.065-1.225-.46-1.9-.902-1.056-.693-1.653-1.124-2.678-1.8-1.185-.78-.417-1.21.258-1.91.177-.184 3.247-2.977 3.307-3.23.007-.032.014-.15-.056-.212s-.174-.041-.249-.024c-.106.024-1.793 1.14-5.061 3.345-.48.33-.913.49-1.302.48-.428-.008-1.252-.241-1.865-.44-.752-.245-1.349-.374-1.297-.789.027-.216.325-.437.893-.663 3.498-1.524 5.83-2.529 6.998-3.014 3.332-1.386 4.025-1.627 4.476-1.635z"
									/>
								</svg>
								<div>
									<div class="provider-name">Telegram</div>
									<div v-if="hasTelegram" class="provider-status connected">
										{{ t('connected') }}
										<el-tag
											v-if="primaryProvider === 'telegram'"
											type="success"
											size="small"
											style="margin-left: 8px"
										>
											{{ t('primary') }}
										</el-tag>
									</div>
									<div v-else class="provider-status">
										{{ t('notConnected') }}
									</div>
									<!-- Детальная информация Telegram профиля -->
									<div v-if="telegramProfile" class="provider-details">
										<div v-if="telegramProfile.first_name"
											>{{ t('firstName') }}:
											{{ telegramProfile.first_name }}</div
										>
										<div v-if="telegramProfile.last_name"
											>{{ t('lastName') }}: {{ telegramProfile.last_name }}</div
										>
										<div v-if="telegramProfile.username"
											>{{ t('username') }}: @{{ telegramProfile.username }}</div
										>
										<div
											>{{ t('telegramId') }}:
											{{ telegramProfile.telegram_id }}</div
										>
									</div>
								</div>
							</div>
							<div class="oauth-actions">
								<el-button
									v-if="hasTelegram"
									type="danger"
									plain
									:loading="isLoading"
									@click="unlinkAccount('telegram')"
								>
									{{ t('unlink') }}
								</el-button>
								<div v-else class="telegram-link-container">
									<TelegramLoginButton />
								</div>
								<!-- Кнопка сделать основным -->
								<el-button
									v-if="hasTelegram && primaryProvider !== 'telegram'"
									type="success"
									plain
									size="small"
									:loading="isLoading"
									@click="setPrimaryProvider('telegram')"
								>
									{{ t('setPrimary') }}
								</el-button>
							</div>
						</div>
					</div>
				</div>

				<el-divider />

				<!-- Безопасность -->
				<div class="security-section">
					<h3>{{ t('security') }}</h3>
					<p class="section-description">
						{{ t('securityDescription') }}
					</p>

					<!-- Смена пароля -->
					<div class="security-item">
						<div class="security-info">
							<div class="security-title">{{ t('password') }}</div>
							<div class="security-description">
								{{
									userHasPassword
										? t('changePasswordTitle')
										: t('setPasswordTitle')
								}}
							</div>
						</div>
						<el-button type="primary" plain @click="showPasswordDialog = true">
							{{ userHasPassword ? t('changePassword') : t('setPassword') }}
						</el-button>
					</div>

					<!-- Активные сессии -->
					<div class="security-item">
						<div class="security-info">
							<div class="security-title">{{ t('activeSessions') }}</div>
							<div class="security-description">
								{{ t('activeDevicesCount') }}: {{ sessions?.length || 0 }}
							</div>
						</div>
						<el-button
							v-if="sessions && sessions.length > 1"
							type="danger"
							plain
							:loading="isLoading"
							@click="logoutAllOtherSessions"
						>
							{{ t('logoutAll') }}
						</el-button>
					</div>

					<!-- Список сессий -->
					<div v-if="sessions && sessions.length > 0" class="sessions-list">
						<div
							v-for="session in sessions"
							:key="session.id"
							class="session-item"
							:class="{ 'current-session': session.is_current }"
						>
							<div class="session-info">
								<div class="session-title">
									{{
										session.is_current
											? t('currentSessionLabel')
											: t('otherDevice')
									}}
								</div>
								<div class="session-meta">
									<span
										>{{ t('created') }}:
										{{
											formatDate(new Date(session.created_at).getTime() / 1000)
										}}</span
									>
									<span
										>{{ t('expires') }}:
										{{ formatDate(session.expires_at) }}</span
									>
								</div>
							</div>
							<el-button
								v-if="!session.is_current"
								type="danger"
								text
								:loading="isLoading"
								@click="deleteSession(session.id)"
							>
								{{ t('terminate') }}
							</el-button>
							<el-tag v-else type="success">{{ t('currentSession') }}</el-tag>
						</div>
					</div>
				</div>

				<el-divider />

				<!-- История входов -->
				<div class="login-history-section">
					<div class="section-header-with-button">
						<div>
							<h3>{{ t('loginHistory') }}</h3>
							<p class="section-description">
								{{ t('loginHistoryDescription') }}
							</p>
						</div>
						<el-button
							type="primary"
							plain
							@click="showLoginHistoryDialog = true"
						>
							{{ t('showAll') }}
						</el-button>
					</div>

					<!-- Последние 5 входов -->
					<div
						v-if="loginHistory?.history && loginHistory.history.length > 0"
						class="history-preview"
					>
						<div
							v-for="entry in loginHistory.history.slice(0, 5)"
							:key="entry.id"
							class="history-item"
						>
							<div class="history-icon">
								{{ getDeviceInfo(entry.user_agent) }}
							</div>
							<div class="history-info">
								<div class="history-title">
									{{ t('loginVia') }}
									{{ formatLoginMethod(entry.login_method) }}
								</div>
								<div class="history-meta">
									<span>{{
										new Date(entry.created_at).toLocaleString('ru-RU')
									}}</span>
									<span v-if="entry.ip_address"
										>{{ t('ipAddress') }}: {{ entry.ip_address }}</span
									>
								</div>
							</div>
						</div>
					</div>

					<div v-else class="empty-state">
						<p>{{ t('loginHistoryEmpty') }}</p>
					</div>

					<!-- Статистика -->
					<div v-if="loginHistory?.stats" class="stats-section">
						<div
							class="stat-item"
							v-for="(count, method) in loginHistory.stats"
							:key="method"
						>
							<span class="stat-label"
								>{{ formatLoginMethod(method as string) }}:</span
							>
							<span class="stat-value">{{ count }} {{ t('logins') }}</span>
						</div>
					</div>
				</div>

				<el-divider />

				<!-- Действия -->
				<div class="actions-section">
					<el-button type="primary" size="large" @click="navigateTo('/')">
						{{ t('onMainPage') }}
					</el-button>
					<el-button
						v-if="isAdmin"
						type="warning"
						size="large"
						@click="navigateTo('/admin')"
					>
						{{ t('adminPanel') }}
					</el-button>
					<el-button
						type="danger"
						size="large"
						:loading="isLoading"
						@click="handleLogout"
					>
						{{ t('logout') }}
					</el-button>
				</div>
			</el-card>
		</div>

		<!-- Диалог смены пароля -->
		<el-dialog
			v-model="showPasswordDialog"
			:title="
				userHasPassword ? t('changePasswordTitle') : t('setPasswordTitle')
			"
			width="500px"
		>
			<el-alert
				v-if="passwordError"
				:title="passwordError"
				type="error"
				:closable="true"
				@close="passwordError = null"
				style="margin-bottom: 20px"
			/>

			<el-form @submit.prevent="handleChangePassword">
				<el-form-item v-if="userHasPassword" :label="t('currentPassword')">
					<el-input
						v-model="passwordForm.currentPassword"
						type="password"
						:placeholder="t('currentPasswordPlaceholder')"
						:disabled="isLoading"
						show-password
					/>
				</el-form-item>

				<el-form-item :label="t('newPassword')">
					<el-input
						v-model="passwordForm.newPassword"
						type="password"
						:placeholder="t('newPasswordPlaceholder')"
						:disabled="isLoading"
						show-password
					/>
				</el-form-item>

				<el-form-item :label="t('confirmPassword')">
					<el-input
						v-model="passwordForm.confirmPassword"
						type="password"
						:placeholder="t('confirmPasswordPlaceholder')"
						:disabled="isLoading"
						show-password
					/>
				</el-form-item>
			</el-form>

			<template #footer>
				<el-button @click="showPasswordDialog = false" :disabled="isLoading">
					{{ t('cancel') }}
				</el-button>
				<el-button
					type="primary"
					:loading="isLoading"
					@click="handleChangePassword"
				>
					{{ t('save') }}
				</el-button>
			</template>
		</el-dialog>

		<!-- Диалог истории входов -->
		<el-dialog
			v-model="showLoginHistoryDialog"
			:title="t('loginHistory')"
			width="700px"
		>
			<div
				v-if="loginHistory?.history && loginHistory.history.length > 0"
				class="full-history-list"
			>
				<el-timeline>
					<el-timeline-item
						v-for="entry in loginHistory.history"
						:key="entry.id"
						:timestamp="new Date(entry.created_at).toLocaleString('ru-RU')"
						placement="top"
					>
						<el-card>
							<div class="history-detail">
								<div class="detail-row">
									<span class="detail-label">{{ t('loginMethod') }}:</span>
									<el-tag>{{ formatLoginMethod(entry.login_method) }}</el-tag>
								</div>
								<div class="detail-row">
									<span class="detail-label">{{ t('device') }}:</span>
									<span>{{ getDeviceInfo(entry.user_agent) }}</span>
								</div>
								<div v-if="entry.ip_address" class="detail-row">
									<span class="detail-label">{{ t('ipAddress') }}:</span>
									<code>{{ entry.ip_address }}</code>
								</div>
								<div v-if="entry.user_agent" class="detail-row">
									<span class="detail-label">{{ t('userAgent') }}:</span>
									<div class="user-agent-text">{{ entry.user_agent }}</div>
								</div>
							</div>
						</el-card>
					</el-timeline-item>
				</el-timeline>
			</div>
			<div v-else class="empty-state">
				<p>{{ t('loginHistoryEmpty') }}</p>
			</div>
		</el-dialog>

		<!-- Диалог редактирования имени -->
		<el-dialog
			v-model="showEditNameDialog"
			:title="t('editNameTitle')"
			width="500px"
		>
			<el-alert
				v-if="editError"
				:title="editError"
				type="error"
				:closable="true"
				@close="editError = null"
				style="margin-bottom: 20px"
			/>

			<el-form @submit.prevent="handleUpdateName">
				<el-form-item :label="t('nameLabel')">
					<el-input
						v-model="editNameForm.name"
						:placeholder="t('namePlaceholder')"
						:disabled="isLoading"
					/>
				</el-form-item>
			</el-form>

			<template #footer>
				<el-button @click="showEditNameDialog = false" :disabled="isLoading">
					{{ t('cancel') }}
				</el-button>
				<el-button
					type="primary"
					:loading="isLoading"
					@click="handleUpdateName"
				>
					{{ t('save') }}
				</el-button>
			</template>
		</el-dialog>

		<!-- Диалог изменения email -->
		<el-dialog
			v-model="showEditEmailDialog"
			:title="t('editEmailTitle')"
			width="500px"
		>
			<el-alert
				v-if="editError"
				:title="editError"
				type="error"
				:closable="true"
				@close="editError = null"
				style="margin-bottom: 20px"
			/>

			<p style="margin-bottom: 20px; color: var(--el-text-color-secondary)">
				{{ t('emailChangeNote') }}
			</p>

			<el-form @submit.prevent="handleRequestEmailChange">
				<el-form-item :label="t('newEmailLabel')">
					<el-input
						v-model="editEmailForm.newEmail"
						type="email"
						:placeholder="t('newEmailPlaceholder')"
						:disabled="isLoading"
					/>
				</el-form-item>
			</el-form>

			<template #footer>
				<el-button @click="showEditEmailDialog = false" :disabled="isLoading">
					{{ t('cancel') }}
				</el-button>
				<el-button
					type="primary"
					:loading="isLoading"
					@click="handleRequestEmailChange"
				>
					{{ t('sendEmail') }}
				</el-button>
			</template>
		</el-dialog>
	</div>
</template>

<style scoped>
.profile-page {
	min-height: 100vh;
	background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	padding: 40px 20px;
}

.profile-container {
	max-width: 800px;
	margin: 0 auto;
}

.profile-card {
	border-radius: 12px;
	box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
}

.card-header h1 {
	margin: 0;
	font-size: 24px;
	font-weight: 600;
	color: var(--el-text-color-primary);
}

.user-section {
	display: flex;
	align-items: center;
	gap: 24px;
	margin-bottom: 24px;
}

.user-avatar-section {
	flex-shrink: 0;
}

.user-avatar {
	width: 100px;
	height: 100px;
	border-radius: 50%;
	border: 3px solid var(--el-color-primary);
	object-fit: cover;
}

.user-avatar-placeholder {
	width: 100px;
	height: 100px;
	border-radius: 50%;
	background: var(--el-color-primary);
	color: white;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 36px;
	font-weight: 600;
}

.user-info {
	text-align: center;
}

.user-info-header {
	display: flex;
	flex-direction: column;
	gap: 12px;
	align-items: center;
	width: 100%;
}

.edit-buttons {
	display: flex;
	gap: 8px;
}

.user-info h2 {
	margin: 0 0 4px 0;
	font-size: 28px;
	font-weight: 600;
	color: var(--el-text-color-primary);
}

.user-info .username {
	margin: 0 0 4px 0;
	font-size: 16px;
	color: var(--el-text-color-secondary);
}

.user-info .email {
	margin: 0 0 12px 0;
	font-size: 14px;
	color: var(--el-text-color-regular);
}

.oauth-section h3 {
	margin: 0 0 8px 0;
	font-size: 20px;
	font-weight: 600;
	color: var(--el-text-color-primary);
}

.section-description {
	margin: 0 0 20px 0;
	font-size: 14px;
	color: var(--el-text-color-secondary);
}

.oauth-accounts {
	display: flex;
	flex-direction: column;
	gap: 16px;
}

.oauth-account-item {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 16px;
	border: 1px solid var(--el-border-color);
	border-radius: 8px;
	transition: border-color 0.2s;
}

.oauth-account-item:hover {
	border-color: var(--el-color-primary);
}

.oauth-info {
	display: flex;
	align-items: center;
	gap: 16px;
}

.provider-icon {
	flex-shrink: 0;
}

.provider-name {
	font-size: 16px;
	font-weight: 500;
	color: var(--el-text-color-primary);
	margin-bottom: 4px;
}

.provider-status {
	font-size: 14px;
	color: var(--el-text-color-secondary);
}

.provider-status.connected {
	color: var(--el-color-success);
	font-weight: 500;
}

.provider-details {
	margin-top: 8px;
	padding: 8px;
	background: var(--el-fill-color-light);
	border-radius: 4px;
	font-size: 12px;
	color: var(--el-text-color-secondary);
}

.provider-details div {
	margin: 4px 0;
}

.oauth-actions {
	display: flex;
	gap: 8px;
	align-items: center;
	flex-wrap: wrap;
}

.telegram-link-container {
	width: 280px;
}

.security-section h3 {
	margin: 0 0 8px 0;
	font-size: 20px;
	font-weight: 600;
	color: var(--el-text-color-primary);
}

.security-item {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 16px;
	border: 1px solid var(--el-border-color);
	border-radius: 8px;
	margin-bottom: 16px;
	transition: border-color 0.2s;
}

.security-item:hover {
	border-color: var(--el-color-primary);
}

.security-info {
	flex: 1;
}

.security-title {
	font-size: 16px;
	font-weight: 500;
	color: var(--el-text-color-primary);
	margin-bottom: 4px;
}

.security-description {
	font-size: 14px;
	color: var(--el-text-color-secondary);
}

.sessions-list {
	margin-top: 16px;
}

.session-item {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 12px 16px;
	border: 1px solid var(--el-border-color-light);
	border-radius: 6px;
	margin-bottom: 8px;
	background: var(--el-fill-color-blank);
}

.session-item.current-session {
	border-color: var(--el-color-success);
	background: var(--el-color-success-light-9);
}

.session-title {
	font-size: 14px;
	font-weight: 500;
	color: var(--el-text-color-primary);
	margin-bottom: 4px;
}

.session-meta {
	font-size: 12px;
	color: var(--el-text-color-secondary);
	display: flex;
	flex-direction: column;
	gap: 2px;
}

.login-history-section h3 {
	margin: 0 0 8px 0;
	font-size: 20px;
	font-weight: 600;
	color: var(--el-text-color-primary);
}

.section-header-with-button {
	display: flex;
	justify-content: space-between;
	align-items: flex-start;
	margin-bottom: 20px;
}

.history-preview {
	display: flex;
	flex-direction: column;
	gap: 12px;
	margin-bottom: 20px;
}

.history-item {
	display: flex;
	align-items: center;
	gap: 16px;
	padding: 12px 16px;
	background: var(--el-fill-color-blank);
	border: 1px solid var(--el-border-color-light);
	border-radius: 6px;
	transition: border-color 0.2s;
}

.history-item:hover {
	border-color: var(--el-color-primary);
}

.history-icon {
	font-size: 24px;
	flex-shrink: 0;
}

.history-info {
	flex: 1;
}

.history-title {
	font-size: 14px;
	font-weight: 500;
	color: var(--el-text-color-primary);
	margin-bottom: 4px;
}

.history-meta {
	font-size: 12px;
	color: var(--el-text-color-secondary);
	display: flex;
	gap: 12px;
}

.stats-section {
	display: flex;
	gap: 20px;
	flex-wrap: wrap;
	padding: 16px;
	background: var(--el-fill-color-light);
	border-radius: 6px;
}

.stat-item {
	display: flex;
	gap: 8px;
	align-items: center;
}

.stat-label {
	font-size: 14px;
	color: var(--el-text-color-secondary);
}

.stat-value {
	font-size: 14px;
	font-weight: 600;
	color: var(--el-color-primary);
}

.empty-state {
	text-align: center;
	padding: 40px 20px;
	color: var(--el-text-color-secondary);
}

.full-history-list {
	max-height: 500px;
	overflow-y: auto;
}

.history-detail {
	display: flex;
	flex-direction: column;
	gap: 8px;
}

.detail-row {
	display: flex;
	gap: 12px;
	align-items: flex-start;
}

.detail-label {
	font-weight: 600;
	color: var(--el-text-color-primary);
	min-width: 100px;
}

.user-agent-text {
	font-size: 12px;
	color: var(--el-text-color-secondary);
	word-break: break-word;
}

.actions-section {
	display: flex;
	gap: 12px;
	flex-wrap: wrap;
}

@media (max-width: 768px) {
	.user-section {
		flex-direction: column;
		text-align: center;
	}

	.user-info {
		text-align: center;
	}

	.oauth-account-item {
		flex-direction: column;
		gap: 12px;
		align-items: stretch;
	}

	.oauth-info {
		justify-content: center;
	}

	.actions-section {
		flex-direction: column;
	}

	.actions-section .el-button {
		width: 100%;
	}

	.telegram-link-container {
		width: 100%;
	}

	.security-item {
		flex-direction: column;
		gap: 12px;
		align-items: stretch;
	}

	.session-item {
		flex-direction: column;
		gap: 8px;
		align-items: stretch;
	}
}
</style>
