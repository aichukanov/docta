<script setup lang="ts">
import { Briefcase } from '@element-plus/icons-vue';
import profileMessages from '~/i18n/profile';
import { getRegionalQuery } from '~/common/url-utils';

definePageMeta({
	middleware: 'auth',
	layout: 'default',
});

const userStore = useUserStore();
const { user, isAdmin } = storeToRefs(userStore);

const { t } = useI18n({
	useScope: 'local',
	messages: profileMessages.messages,
});
const { t: $t, locale } = useI18n({ useScope: 'global' });

const route = useRoute();

const isMobile = ref(false);
let mql: MediaQueryList | null = null;

function onMqlChange(e: MediaQueryListEvent | MediaQueryList) {
	isMobile.value = e.matches;
}

onMounted(() => {
	mql = window.matchMedia('(max-width: 768px)');
	onMqlChange(mql);
	mql.addEventListener('change', onMqlChange as EventListener);
});

onUnmounted(() => {
	mql?.removeEventListener('change', onMqlChange as EventListener);
});

interface ProfileTab {
	key: string;
	icon: string;
	label: string;
	soon?: boolean;
}

const tabs = computed<ProfileTab[]>(() => [
	{ key: 'basic', icon: 'user', label: t('tabBasic') },
	{ key: 'security', icon: 'shield', label: t('tabSecurity') },
	{ key: 'doctor', icon: 'doctor', label: t('tabDoctor') },
	{ key: 'clinics', icon: 'clinic', label: t('tabClinics'), soon: true },
]);

const activeTab = computed(() => {
	const name = route.name as string;
	const match = name?.match(/^profile-(.+)$/);
	return match ? match[1] : 'basic';
});

function tabRoute(key: string) {
	return {
		name: `profile-${key}`,
		query: getRegionalQuery(locale.value),
	};
}

const seoTitle = computed(
	() => t('profileTitle') + ' | ' + $t('ApplicationName'),
);

useSeoMeta({
	title: () => seoTitle.value,
});

const isLoading = ref(false);
const showEditNameDialog = ref(false);
const userName = ref('');
const showEditEmailDialog = ref(false);

async function handleLogout() {
	try {
		isLoading.value = true;
		await userStore.logout();
	} catch (error) {
		console.error('Logout error:', error);
	} finally {
		isLoading.value = false;
	}
}

function openEditName() {
	const name = user.value?.name || '';
	userName.value = name === user.value?.email ? '' : name;
	showEditNameDialog.value = true;
}

function openEditEmail() {
	showEditEmailDialog.value = true;
}

// --- Avatar upload ---
const avatarInput = ref<HTMLInputElement | null>(null);
const {
	isUploading,
	isRemoving,
	error: uploadError,
	preview,
	upload,
	removePhoto,
	setPreview,
} = useImageUpload();

function triggerAvatarUpload() {
	avatarInput.value?.click();
}

async function onAvatarFileChange(e: Event) {
	const file = (e.target as HTMLInputElement).files?.[0];
	if (!file) return;

	setPreview(file);
	const url = await upload(file, 'avatars');

	if (url) {
		await userStore.fetchUser(true);
	}

	if (avatarInput.value) {
		avatarInput.value.value = '';
	}
}

async function removeAvatar() {
	const ok = await removePhoto('avatars');
	if (ok) {
		await userStore.fetchUser(true);
	}
}

const canRemoveAvatar = computed(
	() => preview.value || user.value?.has_custom_photo,
);
const isOAuthPhoto = computed(
	() => !user.value?.has_custom_photo && !!user.value?.photo_url,
);
const avatarDisplayUrl = computed(() => preview.value || user.value?.photo_url);
</script>

<template>
	<div class="profile-page">
		<div class="profile-layout">
			<!-- Hero -->
			<section class="profile-hero">
				<div class="profile-hero__content">
					<div class="profile-hero__avatar-wrap">
						<el-tooltip
							v-if="isOAuthPhoto"
							:content="t('oauthPhotoHint')"
							placement="bottom"
						>
							<DoctorAvatar
								:name="user?.name ?? ''"
								:photo-url="avatarDisplayUrl"
								:size="88"
							/>
						</el-tooltip>
						<DoctorAvatar
							v-else
							:name="user?.name ?? ''"
							:photo-url="avatarDisplayUrl"
							:size="88"
						/>
						<button
							class="profile-hero__avatar-upload"
							:title="t('changePhoto')"
							:disabled="isUploading"
							@click="triggerAvatarUpload"
						>
							<IconCamera v-if="!isUploading" :size="14" />
							<span v-else class="profile-hero__avatar-spinner" />
						</button>
						<button
							v-if="canRemoveAvatar"
							class="profile-hero__avatar-remove"
							:title="t('removePhoto')"
							:disabled="isRemoving"
							@click="removeAvatar"
						>
							<IconClose :size="10" />
						</button>
						<input
							ref="avatarInput"
							type="file"
							accept="image/jpeg,image/png,image/webp,image/gif"
							hidden
							@change="onAvatarFileChange"
						/>
					</div>

					<div class="profile-hero__info">
						<div class="profile-hero__name-row">
							<h1 class="profile-hero__name">{{ user?.name }}</h1>
							<button
								class="profile-hero__edit-btn"
								:title="t('editName')"
								@click="openEditName"
							>
								<IconEdit :size="16" />
							</button>
						</div>
						<p v-if="user?.username" class="profile-hero__username">
							@{{ user.username }}
						</p>
						<div class="profile-hero__email-row">
							<span class="profile-hero__email">{{ user?.email }}</span>
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
						<NuxtLink
							v-if="isAdmin"
							:to="{ name: 'admin', query: getRegionalQuery(locale) }"
						>
							<el-button type="primary" plain :icon="Briefcase">
								{{ t('adminPanel') }}
							</el-button>
						</NuxtLink>
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

			<!-- Tabs + Content -->
			<div class="profile-body">
				<!-- Sidebar nav (desktop) / Scrollable bar (mobile) -->
				<nav class="profile-nav">
					<div class="profile-nav__list">
						<NuxtLink
							v-for="tab in tabs"
							:key="tab.key"
							:to="tabRoute(tab.key)"
							class="profile-nav__item"
							:class="{ 'profile-nav__item--active': activeTab === tab.key }"
						>
							<IconUser v-if="tab.icon === 'user'" :size="16" />
							<IconShield v-else-if="tab.icon === 'shield'" :size="16" />
							<IconDoctor v-else-if="tab.icon === 'doctor'" :size="16" />
							<IconClinic v-else-if="tab.icon === 'clinic'" :size="16" />
							<span class="profile-nav__label">{{ tab.label }}</span>
							<span v-if="tab.soon" class="profile-nav__soon">
								{{ t('comingSoon') }}
							</span>
						</NuxtLink>
					</div>
				</nav>

				<!-- Content -->
				<div class="profile-content">
					<NuxtPage />
				</div>
			</div>
		</div>

		<ClientOnly>
			<AppDialog
				v-model="showEditNameDialog"
				:title="t('editNameTitle')"
				width="460px"
			>
				<ProfileEditNameDialog
					:initial-name="userName"
					@updated="showEditNameDialog = false"
					@cancel="showEditNameDialog = false"
				/>
			</AppDialog>

			<AppDialog
				v-model="showEditEmailDialog"
				:title="t('editEmailTitle')"
				width="460px"
			>
				<ProfileEditEmailDialog
					@updated="showEditEmailDialog = false"
					@cancel="showEditEmailDialog = false"
				/>
			</AppDialog>
		</ClientOnly>
	</div>
</template>

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

.profile-hero__avatar-upload {
	position: absolute;
	bottom: -2px;
	right: -2px;
	width: 28px;
	height: 28px;
	border-radius: 50%;
	border: 2px solid var(--color-bg-primary);
	background: var(--color-primary);
	color: #fff;
	display: flex;
	align-items: center;
	justify-content: center;
	cursor: pointer;
	transition: all var(--transition-base);
	padding: 0;
}

.profile-hero__avatar-upload:hover {
	opacity: 0.9;
	transform: scale(1.1);
}

.profile-hero__avatar-upload:disabled {
	cursor: not-allowed;
	opacity: 0.7;
}

.profile-hero__avatar-spinner {
	width: 14px;
	height: 14px;
	border: 2px solid rgba(255, 255, 255, 0.3);
	border-top-color: #fff;
	border-radius: 50%;
	animation: avatar-spin 0.6s linear infinite;
}

.profile-hero__avatar-remove {
	position: absolute;
	top: -4px;
	right: -4px;
	width: 20px;
	height: 20px;
	border-radius: 50%;
	border: 2px solid var(--color-bg-primary);
	background: var(--color-danger, #ef4444);
	color: #fff;
	display: flex;
	align-items: center;
	justify-content: center;
	cursor: pointer;
	transition: all var(--transition-base);
	padding: 0;
}

.profile-hero__avatar-remove:hover {
	background: var(--color-danger-dark, #dc2626);
	transform: scale(1.1);
}

.profile-hero__avatar-remove:disabled {
	cursor: not-allowed;
	opacity: 0.7;
}

@keyframes avatar-spin {
	to {
		transform: rotate(360deg);
	}
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
	background: var(--color-success-bg);
	color: var(--color-success-dark);
	border: 1px solid var(--color-success-border);
}

.profile-hero__badge--admin {
	background: var(--color-danger-bg);
	color: var(--color-danger);
	border: 1px solid var(--color-danger-border);
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

/* ── Body (sidebar + content) ────────────────── */

.profile-body {
	display: flex;
	gap: var(--spacing-xl);
	align-items: flex-start;
}

/* ── Nav (sidebar on desktop) ────────────────── */

.profile-nav {
	width: 220px;
	flex-shrink: 0;
	position: sticky;
	top: calc(var(--spacing-2xl) + 60px);
}

.profile-nav__list {
	display: flex;
	flex-direction: column;
	gap: 2px;
	background: var(--color-bg-primary);
	border-radius: var(--border-radius-xl);
	border: 1px solid var(--color-border-secondary);
	box-shadow: var(--shadow-sm);
	padding: var(--spacing-sm);
}

.profile-nav__item {
	display: flex;
	align-items: center;
	gap: var(--spacing-sm);
	padding: var(--spacing-sm) var(--spacing-md);
	border: none;
	background: transparent;
	border-radius: var(--border-radius-lg);
	color: var(--color-text-secondary);
	font-size: var(--font-size-sm);
	font-weight: var(--font-weight-medium);
	cursor: pointer;
	transition: all var(--transition-base);
	white-space: nowrap;
	text-align: left;
	text-decoration: none;
	width: 100%;
	box-sizing: border-box;
}

.profile-nav__item:hover {
	background: var(--color-bg-tertiary);
	color: var(--color-text-primary);
}

.profile-nav__item--active {
	background: var(--color-primary-bg);
	color: var(--color-primary);
}

.profile-nav__item--active:hover {
	background: var(--color-primary-bg);
	color: var(--color-primary);
}

.profile-nav__soon {
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

/* ── Content ─────────────────────────────────── */

.profile-content {
	flex: 1;
	min-width: 0;
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xl);
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

@media (max-width: 768px) {
	.profile-page {
		padding: var(--spacing-lg) var(--spacing-sm);
	}

	.profile-hero__content {
		flex-direction: column;
		align-items: center;
		text-align: center;
		padding: var(--spacing-xl) var(--spacing-lg);
		gap: var(--spacing-md);
	}

	.profile-hero__name {
		font-size: var(--font-size-2xl);
	}

	.profile-hero__name-row {
		justify-content: center;
	}

	.profile-hero__email-row {
		justify-content: center;
	}

	.profile-hero__actions {
		width: 100%;
		justify-content: center;
	}

	/* Nav becomes horizontal scrollable bar */
	.profile-body {
		flex-direction: column;
		gap: var(--spacing-md);
	}

	.profile-content {
		width: 100%;
	}

	.profile-nav {
		width: 100%;
		position: static;
	}

	.profile-nav__list {
		flex-direction: row;
		overflow-x: auto;
		-webkit-overflow-scrolling: touch;
		scrollbar-width: thin;
		gap: var(--spacing-xs);
		padding: var(--spacing-xs);
	}

	.profile-nav__item {
		flex-shrink: 0;
		width: auto;
		padding: var(--spacing-sm) var(--spacing-md);
	}

	.profile-nav__soon {
		display: none;
	}
}
</style>
