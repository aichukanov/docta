<script setup lang="ts">
import profileMessages from '~/i18n/profile';

definePageMeta({
	middleware: 'auth',
	layout: 'default',
});

const { currentUser, isAdmin, logout } = useAuth();
const activeTab = ref('basic');

const { t } = useI18n({
	useScope: 'local',
	messages: profileMessages.messages,
});

const isLoading = ref(false);
const showEditNameDialog = ref(false);
const userName = ref('');
const showEditEmailDialog = ref(false);

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

function openEditName() {
	const name = currentUser.value?.name || '';
	userName.value = name === currentUser.value?.email ? '' : name;
	showEditNameDialog.value = true;
}

function openEditEmail() {
	showEditEmailDialog.value = true;
}
</script>

<template>
	<div class="profile-page">
		<div class="profile-layout">
			<!-- Hero -->
			<section class="profile-hero">
				<div class="profile-hero__content">
					<div class="profile-hero__avatar-wrap">
						<DoctorAvatar
							:name="currentUser?.name ?? ''"
							:photo-url="currentUser?.photo_url"
							:size="88"
						/>
						<span
							v-if="isAdmin"
							class="profile-hero__badge"
							:class="
								isAdmin
									? 'profile-hero__badge--admin'
									: 'profile-hero__badge--user'
							"
						>
							{{ isAdmin ? t('administrator') : t('user') }}
						</span>
					</div>

					<div class="profile-hero__info">
						<div class="profile-hero__name-row">
							<h1 class="profile-hero__name">{{ currentUser?.name }}</h1>
							<button
								class="profile-hero__edit-btn"
								:title="t('editName')"
								@click="openEditName"
							>
								<IconEdit :size="16" />
							</button>
						</div>
						<p v-if="currentUser?.username" class="profile-hero__username">
							@{{ currentUser.username }}
						</p>
						<div class="profile-hero__email-row">
							<span class="profile-hero__email">{{ currentUser?.email }}</span>
							<button
								class="profile-hero__edit-btn"
								:title="t('editEmail')"
								@click="openEditEmail"
							>
								<IconEdit :size="14" />
							</button>
						</div>
					</div>

					<div class="profile-hero__actions">
						<el-button
							type="danger"
							plain
							:loading="isLoading"
							@click="handleLogout"
						>
							{{ t('logout') }}
						</el-button>
					</div>
				</div>
			</section>

			<!-- El-tabs with left nav -->
			<el-tabs v-model="activeTab" tab-position="left" class="profile-el-tabs">
				<el-tab-pane name="basic">
					<template #label>
						<div class="tab-label">
							<IconUser :size="16" />
							<span>{{ t('tabBasic') }}</span>
						</div>
					</template>
					<ProfileTabBasic />
				</el-tab-pane>

				<el-tab-pane name="security">
					<template #label>
						<div class="tab-label">
							<IconShield :size="16" />
							<span>{{ t('tabSecurity') }}</span>
						</div>
					</template>
					<SecuritySessionsSection />
					<SecurityLoginHistorySection />
				</el-tab-pane>

				<el-tab-pane name="doctor">
					<template #label>
						<div class="tab-label">
							<IconDoctor :size="16" />
							<span>{{ t('tabDoctor') }}</span>
							<span class="tab-label__soon">{{ t('comingSoon') }}</span>
						</div>
					</template>
					<ProfileTabDoctor />
				</el-tab-pane>

				<el-tab-pane name="clinics">
					<template #label>
						<div class="tab-label">
							<IconClinic :size="16" />
							<span>{{ t('tabClinics') }}</span>
							<span class="tab-label__soon">{{ t('comingSoon') }}</span>
						</div>
					</template>
					<ProfileTabClinics />
				</el-tab-pane>
			</el-tabs>
		</div>

		<ClientOnly>
			<!-- Edit Name Dialog -->
			<el-dialog
				v-model="showEditNameDialog"
				:title="t('editNameTitle')"
				width="460px"
				class="profile-dialog"
				destroy-on-close
			>
				<ProfileEditNameDialog
					:initial-name="userName"
					@updated="showEditNameDialog = false"
					@cancel="showEditNameDialog = false"
				/>
			</el-dialog>

			<!-- Edit Email Dialog -->
			<el-dialog
				v-model="showEditEmailDialog"
				:title="t('editEmailTitle')"
				width="460px"
				class="profile-dialog"
				destroy-on-close
			>
				<ProfileEditEmailDialog
					@updated="showEditEmailDialog = false"
					@cancel="showEditEmailDialog = false"
				/>
			</el-dialog>
		</ClientOnly>
	</div>
</template>

<style>
/* ── El-tabs overrides (non-scoped, scoped by .profile-el-tabs) ── */

.profile-el-tabs.el-tabs--left {
	gap: var(--spacing-xl);
}

.profile-el-tabs.el-tabs--left > .el-tabs__header {
	width: 220px;
	flex-shrink: 0;
	background: var(--color-bg-primary);
	border-radius: var(--border-radius-xl);
	border: 1px solid var(--color-border-secondary);
	box-shadow: var(--shadow-sm);
	border-right: none;
	padding: var(--spacing-sm);
	align-self: flex-start;
}

.profile-el-tabs.el-tabs--left > .el-tabs__header .el-tabs__nav-wrap::after {
	display: none;
}

.profile-el-tabs.el-tabs--left > .el-tabs__header .el-tabs__active-bar {
	display: none;
}

.profile-el-tabs.el-tabs--left > .el-tabs__header .el-tabs__item {
	height: auto;
	padding: var(--spacing-sm) var(--spacing-md);
	border-radius: var(--border-radius-lg);
	color: var(--color-text-secondary);
	font-size: var(--font-size-sm);
	font-weight: var(--font-weight-medium);
	transition: all var(--transition-base);
	text-align: left;
	white-space: nowrap;
	justify-content: flex-start;
}

.profile-el-tabs.el-tabs--left > .el-tabs__header .el-tabs__item:hover {
	background: var(--color-bg-tertiary);
	color: var(--color-text-primary);
}

.profile-el-tabs.el-tabs--left > .el-tabs__header .el-tabs__item.is-active {
	background: var(--color-primary-bg);
	color: var(--color-primary);
}

.profile-el-tabs.el-tabs--left > .el-tabs__content {
	padding: 0;
}

.profile-el-tabs.el-tabs--left > .el-tabs__content .el-tab-pane {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xl);
}
</style>

<style scoped>
.profile-page {
	background: var(--color-bg-secondary);
	min-height: calc(100vh - 120px);
	padding: var(--spacing-2xl) var(--spacing-lg);
}

.profile-layout {
	max-width: 1060px;
	margin: 0 auto;
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xl);
}

/* ── Tab labels ──────────────────────────────── */

.tab-label {
	display: flex;
	align-items: center;
	gap: var(--spacing-sm);
}

.tab-label__soon {
	margin-left: auto;
	font-size: 10px;
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-muted);
	background: var(--color-bg-tertiary);
	padding: 1px 6px;
	border-radius: 6px;
	text-transform: uppercase;
	letter-spacing: 0.3px;
}

/* ── Hero ────────────────────────────────────── */

.profile-hero {
	position: relative;
	background: var(--color-bg-primary);
	border-radius: var(--border-radius-xl);
	box-shadow: var(--shadow-sm);
	border: 1px solid var(--color-border-secondary);
}

.profile-hero__content {
	display: flex;
	align-items: center;
	gap: var(--spacing-xl);
	padding: var(--spacing-2xl);
}

.profile-hero__avatar-wrap {
	position: relative;
	flex-shrink: 0;
}

.profile-hero__badge {
	position: absolute;
	bottom: -4px;
	left: 50%;
	transform: translateX(-50%);
	padding: 2px 10px;
	font-size: 11px;
	font-weight: var(--font-weight-semibold);
	border-radius: 20px;
	white-space: nowrap;
	letter-spacing: 0.3px;
	text-transform: uppercase;
}

.profile-hero__badge--user {
	background: #ecfdf5;
	color: #059669;
	border: 1px solid #a7f3d0;
}

.profile-hero__badge--admin {
	background: #fef2f2;
	color: #dc2626;
	border: 1px solid #fecaca;
}

.profile-hero__info {
	flex: 1;
	min-width: 0;
}

.profile-hero__actions {
	display: flex;
	align-items: center;
	gap: var(--spacing-sm);
	margin-left: auto;
	flex-shrink: 0;
}

.profile-hero__name-row {
	display: flex;
	align-items: center;
	gap: var(--spacing-sm);
}

.profile-hero__name {
	font-size: var(--font-size-3xl);
	font-weight: var(--font-weight-bold);
	color: var(--color-text-heading);
	margin: 0;
	line-height: 1.3;
}

.profile-hero__username {
	margin: 2px 0 0;
	font-size: var(--font-size-md);
	color: var(--color-text-muted);
}

.profile-hero__email-row {
	display: flex;
	align-items: center;
	gap: var(--spacing-xs);
	margin-top: var(--spacing-xs);
}

.profile-hero__email {
	font-size: var(--font-size-sm);
	color: var(--color-text-secondary);
}

.profile-hero__edit-btn {
	display: inline-flex;
	align-items: center;
	justify-content: center;
	width: 28px;
	height: 28px;
	border: none;
	background: transparent;
	color: var(--color-text-muted);
	border-radius: var(--border-radius-md);
	cursor: pointer;
	transition: all var(--transition-base);
	flex-shrink: 0;
}

.profile-hero__edit-btn:hover {
	background: var(--color-bg-tertiary);
	color: var(--color-primary);
}

/* ── Dialogs ─────────────────────────────────── */

.profile-dialog__footer {
	display: flex;
	justify-content: flex-end;
	gap: var(--spacing-sm);
}

.profile-dialog__note {
	font-size: var(--font-size-sm);
	color: var(--color-text-muted);
	margin: 0 0 var(--spacing-lg);
	line-height: 1.5;
}

/* ── Responsive ──────────────────────────────── */

@media (max-width: 640px) {
	.profile-page {
		padding: var(--spacing-lg) var(--spacing-sm);
	}

	.profile-hero__content {
		flex-wrap: wrap;
		padding: var(--spacing-xl) var(--spacing-lg);
	}

	.profile-hero__actions {
		width: 100%;
		justify-content: center;
	}

	.profile-hero__avatar {
		width: 76px;
		height: 76px;
	}
}
</style>
