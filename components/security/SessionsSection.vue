<script setup lang="ts">
import securityMessages from '~/i18n/security-section';

const { t } = useI18n({
	useScope: 'local',
	messages: securityMessages.messages,
});
const { d } = useI18n();

const userStore = useUserStore();
const { user } = storeToRefs(userStore);
const { data: oauthAccounts } = await useFetch('/api/auth/accounts');
const { data: sessions, refresh: refreshSessions } = await useFetch(
	'/api/auth/sessions',
);

const userHasPassword = computed(
	() =>
		oauthAccounts.value?.some((acc: any) => acc.provider === 'email') ?? false,
);

const isLoading = ref(false);
const showPasswordDialog = ref(false);

async function deleteSession(sessionId: string) {
	if (!confirm(t('confirmDeleteSession'))) return;

	try {
		isLoading.value = true;
		await $fetch(`/api/auth/sessions/${sessionId}`, { method: 'DELETE' });
		await refreshSessions();
		ElMessage.success(t('sessionDeleted'));
	} catch {
		ElMessage.error(t('errorDeleteSession'));
	} finally {
		isLoading.value = false;
	}
}

async function logoutAllOtherSessions() {
	if (!confirm(t('confirmLogoutAll'))) return;

	try {
		isLoading.value = true;
		await $fetch('/api/auth/sessions/logout-all', { method: 'POST' });
		await refreshSessions();
		ElMessage.success(t('allSessionsDeleted'));
	} catch {
		ElMessage.error(t('errorLogoutAll'));
	} finally {
		isLoading.value = false;
	}
}
</script>

<template>
	<section class="profile-section">
		<div class="profile-section__header">
			<div class="profile-section__icon">
				<IconShield :size="20" />
			</div>
			<div>
				<h2 class="profile-section__title">{{ t('security') }}</h2>
				<p class="profile-section__desc">{{ t('securityDescription') }}</p>
			</div>
		</div>

		<!-- Password -->
		<div class="security-row">
			<div class="security-row__info">
				<IconLock class="security-row__icon" :size="18" />
				<div>
					<div class="security-row__title">{{ t('password') }}</div>
					<div class="security-row__subtitle">
						{{
							userHasPassword ? t('changePasswordTitle') : t('setPasswordTitle')
						}}
					</div>
				</div>
			</div>
			<el-button size="small" type="primary" @click="showPasswordDialog = true">
				{{ userHasPassword ? t('changePassword') : t('setPassword') }}
			</el-button>
		</div>

		<!-- Active Sessions -->
		<div class="security-row">
			<div class="security-row__info">
				<IconMonitor class="security-row__icon" :size="18" />
				<div>
					<div class="security-row__title">{{ t('activeSessions') }}</div>
					<div class="security-row__subtitle">
						{{ t('activeDevicesCount') }}: {{ sessions?.length || 0 }}
					</div>
				</div>
			</div>
			<el-button
				v-if="sessions && sessions.length > 1"
				size="small"
				type="danger"
				plain
				:loading="isLoading"
				@click="logoutAllOtherSessions"
			>
				{{ t('logoutAll') }}
			</el-button>
		</div>

		<!-- Sessions List -->
		<div v-if="sessions && sessions.length > 0" class="sessions-grid">
			<div
				v-for="session in sessions"
				:key="session.id"
				class="session-card"
				:class="{ 'session-card--current': session.is_current }"
			>
				<div class="session-card__top">
					<div class="session-card__device">
						<span class="session-card__device-icon">
							<IconMonitor v-if="!session.is_current" :size="16" />
							<IconCheckCircle v-else :size="16" />
						</span>
						<span class="session-card__label">
							{{
								session.is_current ? t('currentSessionLabel') : t('otherDevice')
							}}
						</span>
					</div>
					<span v-if="session.is_current" class="session-card__current-tag">
						{{ t('currentSession') }}
					</span>
					<el-button
						v-else
						size="small"
						type="danger"
						text
						:loading="isLoading"
						@click="deleteSession(session.id)"
					>
						{{ t('terminate') }}
					</el-button>
				</div>
				<div class="session-card__meta">
					<span
						>{{ t('created') }}:
						{{ d(new Date(session.created_at), 'short') }}</span
					>
				</div>
			</div>
		</div>
	</section>

	<ClientOnly>
		<SecurityChangePasswordDialog
			v-model="showPasswordDialog"
			:user-has-password="userHasPassword"
			:user-email="user?.email"
		/>
	</ClientOnly>
</template>

<style scoped>
/* ── Section wrapper ─────────────────────────── */

.profile-section {
	background: var(--color-bg-primary);
	border-radius: var(--border-radius-xl);
	padding: var(--spacing-2xl);
	box-shadow: var(--shadow-sm);
	border: 1px solid var(--color-border-secondary);
}

.profile-section__header {
	display: flex;
	align-items: flex-start;
	gap: var(--spacing-md);
	margin-bottom: var(--spacing-xl);
}

.profile-section__icon {
	display: flex;
	align-items: center;
	justify-content: center;
	width: 40px;
	height: 40px;
	border-radius: var(--border-radius-lg);
	background: var(--color-primary-bg);
	color: var(--color-primary);
	flex-shrink: 0;
}

.profile-section__title {
	font-size: var(--font-size-2xl);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-heading);
	margin: 0 0 4px;
	line-height: 1.3;
}

.profile-section__desc {
	font-size: var(--font-size-sm);
	color: var(--color-text-muted);
	margin: 0;
	line-height: 1.4;
}

/* ── Security Rows ───────────────────────────── */

.security-row {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: var(--spacing-lg);
	padding: var(--spacing-lg);
	border: 1px solid var(--color-border-light);
	border-radius: var(--border-radius-lg);
	margin-bottom: var(--spacing-md);
	transition: border-color var(--transition-base);
}

.security-row:hover {
	border-color: var(--color-border-primary);
}

.security-row__info {
	display: flex;
	align-items: center;
	gap: var(--spacing-md);
}

.security-row__icon {
	color: var(--color-text-muted);
	flex-shrink: 0;
}

.security-row__title {
	font-size: var(--font-size-md);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-heading);
	margin-bottom: 2px;
}

.security-row__subtitle {
	font-size: var(--font-size-sm);
	color: var(--color-text-muted);
}

/* ── Session Cards ───────────────────────────── */

.sessions-grid {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
}

.session-card {
	padding: var(--spacing-md) var(--spacing-lg);
	border: 1px solid var(--color-border-light);
	border-radius: var(--border-radius-md);
	background: var(--color-bg-primary);
	transition: all var(--transition-base);
}

.session-card:hover {
	border-color: var(--color-border-primary);
}

.session-card--current {
	border-color: var(--color-success-border);
	background: var(--color-success-bg-soft);
}

.session-card__top {
	display: flex;
	align-items: center;
	justify-content: space-between;
	margin-bottom: 6px;
}

.session-card__device {
	display: flex;
	align-items: center;
	gap: var(--spacing-sm);
}

.session-card__device-icon {
	display: flex;
	color: var(--color-text-muted);
}

.session-card--current .session-card__device-icon {
	color: var(--color-success-dark);
}

.session-card__label {
	font-size: var(--font-size-sm);
	font-weight: var(--font-weight-medium);
	color: var(--color-text-primary);
}

.session-card__current-tag {
	font-size: 11px;
	font-weight: var(--font-weight-semibold);
	color: var(--color-success-dark);
	background: var(--color-success-bg);
	padding: 2px 10px;
	border-radius: 12px;
}

.session-card__meta {
	display: flex;
	gap: var(--spacing-lg);
	font-size: var(--font-size-xs);
	color: var(--color-text-light);
}

/* ── Responsive ──────────────────────────────── */

@media (max-width: 640px) {
	.security-row {
		flex-direction: column;
		align-items: stretch;
		gap: var(--spacing-md);
	}

	.session-card__meta {
		flex-direction: column;
		gap: 2px;
	}

	.session-card__top {
		flex-direction: column;
		align-items: flex-start;
		gap: var(--spacing-sm);
	}
}
</style>
