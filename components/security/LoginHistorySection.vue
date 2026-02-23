<script setup lang="ts">
import securityMessages from '~/i18n/security-section';

const { t } = useI18n({
	useScope: 'local',
	messages: securityMessages.messages,
});

const { data: loginHistory } = await useFetch('/api/auth/login-history');

const showLoginHistoryDialog = ref(false);

function formatLoginMethod(method: string): string {
	const methods: Record<string, string> = {
		email: t('emailMethod'),
		google: t('googleMethod'),
		telegram: t('telegramMethod'),
		facebook: t('facebookMethod'),
	};
	return methods[method] || method;
}

function getDeviceIcon(userAgent: string): string {
	if (!userAgent) return 'unknown';
	if (userAgent.includes('Mobile')) return 'mobile';
	if (userAgent.includes('Tablet')) return 'tablet';
	return 'desktop';
}

function getDeviceInfo(userAgent: string): string {
	if (!userAgent) return t('unknownDevice');
	if (userAgent.includes('Mobile')) return t('mobileDevice');
	if (userAgent.includes('Tablet')) return t('tablet');
	return t('computer');
}
</script>

<template>
	<section class="profile-section">
		<div class="profile-section__header">
			<div class="profile-section__icon">
				<IconClock :size="20" />
			</div>
			<div class="profile-section__header-text">
				<h2 class="profile-section__title">{{ t('loginHistory') }}</h2>
				<p class="profile-section__desc">{{ t('loginHistoryDescription') }}</p>
			</div>
			<el-button
				size="small"
				class="profile-section__header-action"
				@click="showLoginHistoryDialog = true"
			>
				{{ t('showAll') }}
			</el-button>
		</div>

		<!-- Stats -->
		<div v-if="loginHistory?.stats" class="stats-bar">
			<div
				v-for="(count, method) in loginHistory.stats"
				:key="method"
				class="stats-bar__item"
			>
				<span class="stats-bar__value">{{ count }}</span>
				<span class="stats-bar__label">{{
					formatLoginMethod(method as string)
				}}</span>
			</div>
		</div>

		<!-- Recent logins -->
		<div
			v-if="loginHistory?.history && loginHistory.history.length > 0"
			class="history-list"
		>
			<div
				v-for="entry in loginHistory.history.slice(0, 5)"
				:key="entry.id"
				class="history-row"
			>
				<div class="history-row__icon-wrap">
					<IconMobile
						v-if="getDeviceIcon(entry.user_agent) === 'mobile'"
						:size="16"
					/>
					<IconMonitor v-else :size="16" />
				</div>
				<div class="history-row__info">
					<span class="history-row__method">
						{{ t('loginVia') }} {{ formatLoginMethod(entry.login_method) }}
					</span>
					<span class="history-row__time">
						{{ new Date(entry.created_at).toLocaleString() }}
					</span>
				</div>
				<span v-if="entry.ip_address" class="history-row__ip">
					{{ entry.ip_address }}
				</span>
			</div>
		</div>

		<div v-else class="profile-empty">
			<p>{{ t('loginHistoryEmpty') }}</p>
		</div>
	</section>

	<!-- Full History Dialog -->
	<ClientOnly>
		<el-dialog
			v-model="showLoginHistoryDialog"
			:title="t('loginHistory')"
			width="640px"
			class="profile-dialog"
		>
			<div
				v-if="loginHistory?.history && loginHistory.history.length > 0"
				class="full-history"
			>
				<div
					v-for="entry in loginHistory.history"
					:key="entry.id"
					class="full-history__item"
				>
					<div class="full-history__header">
						<span class="full-history__method">{{
							formatLoginMethod(entry.login_method)
						}}</span>
						<span class="full-history__time">{{
							new Date(entry.created_at).toLocaleString()
						}}</span>
					</div>
					<div class="full-history__details">
						<span class="full-history__device">{{
							getDeviceInfo(entry.user_agent)
						}}</span>
						<span v-if="entry.ip_address" class="full-history__ip">{{
							entry.ip_address
						}}</span>
					</div>
					<div v-if="entry.user_agent" class="full-history__ua">{{
						entry.user_agent
					}}</div>
				</div>
			</div>
			<div v-else class="profile-empty">
				<p>{{ t('loginHistoryEmpty') }}</p>
			</div>
		</el-dialog>
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

.profile-section__header-text {
	flex: 1;
}

.profile-section__header-action {
	flex-shrink: 0;
	margin-left: auto;
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

/* ── Stats Bar ───────────────────────────────── */

.stats-bar {
	display: flex;
	gap: var(--spacing-lg);
	padding: var(--spacing-lg);
	background: var(--color-bg-secondary);
	border-radius: var(--border-radius-lg);
	margin-bottom: var(--spacing-lg);
}

.stats-bar__item {
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 2px;
	flex: 1;
}

.stats-bar__value {
	font-size: var(--font-size-2xl);
	font-weight: var(--font-weight-bold);
	color: var(--color-primary);
}

.stats-bar__label {
	font-size: var(--font-size-xs);
	color: var(--color-text-muted);
	text-transform: uppercase;
	letter-spacing: 0.5px;
}

/* ── History List ────────────────────────────── */

.history-list {
	display: flex;
	flex-direction: column;
	gap: 1px;
	border-radius: var(--border-radius-lg);
	overflow: hidden;
	border: 1px solid var(--color-border-light);
}

.history-row {
	display: flex;
	align-items: center;
	gap: var(--spacing-md);
	padding: var(--spacing-md) var(--spacing-lg);
	background: var(--color-bg-primary);
	transition: background var(--transition-base);
}

.history-row:not(:last-child) {
	border-bottom: 1px solid var(--color-border-light);
}

.history-row:hover {
	background: var(--color-bg-secondary);
}

.history-row__icon-wrap {
	display: flex;
	align-items: center;
	justify-content: center;
	width: 32px;
	height: 32px;
	border-radius: var(--border-radius-md);
	background: var(--color-bg-tertiary);
	color: var(--color-text-muted);
	flex-shrink: 0;
}

.history-row__info {
	flex: 1;
	min-width: 0;
}

.history-row__method {
	display: block;
	font-size: var(--font-size-sm);
	font-weight: var(--font-weight-medium);
	color: var(--color-text-primary);
}

.history-row__time {
	display: block;
	font-size: var(--font-size-xs);
	color: var(--color-text-light);
	margin-top: 2px;
}

.history-row__ip {
	font-size: var(--font-size-xs);
	color: var(--color-text-muted);
	font-family: monospace;
	flex-shrink: 0;
}

/* ── Full History (Dialog) ───────────────────── */

.full-history {
	max-height: 480px;
	overflow-y: auto;
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
}

.full-history__item {
	padding: var(--spacing-md) var(--spacing-lg);
	border: 1px solid var(--color-border-light);
	border-radius: var(--border-radius-md);
	transition: border-color var(--transition-base);
}

.full-history__item:hover {
	border-color: var(--color-border-primary);
}

.full-history__header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	margin-bottom: 6px;
}

.full-history__method {
	font-size: var(--font-size-md);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-heading);
}

.full-history__time {
	font-size: var(--font-size-xs);
	color: var(--color-text-muted);
}

.full-history__details {
	display: flex;
	gap: var(--spacing-lg);
	font-size: var(--font-size-sm);
	color: var(--color-text-secondary);
}

.full-history__ip {
	font-family: monospace;
	color: var(--color-text-muted);
}

.full-history__ua {
	margin-top: 6px;
	font-size: var(--font-size-xs);
	color: var(--color-text-light);
	word-break: break-word;
	line-height: 1.4;
}

/* ── Responsive ──────────────────────────────── */

@media (max-width: 640px) {
	.stats-bar {
		gap: var(--spacing-sm);
	}

	.history-row {
		padding: var(--spacing-sm) var(--spacing-md);
	}

	.history-row__ip {
		display: none;
	}
}
</style>
