<script setup lang="ts">
import RatingStars from '~/components/rating-stars.vue';
import { maskEmail } from '~/common/email-masking';
import accountCardMessages from '~/i18n/account-card';
import profileMessages from '~/i18n/profile';
import { combineI18nMessages } from '~/i18n/utils';

const { t } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([profileMessages, accountCardMessages]),
});

const { data: oauthAccounts, refresh: refreshAccounts } =
	await useFetch('/api/auth/accounts');
const { data: oauthProfiles, refresh: refreshOAuthProfiles } = await useFetch(
	'/api/auth/oauth-profiles',
);

const isLoading = ref(false);

const hasGoogle = computed(() =>
	oauthAccounts.value?.some((acc: any) => acc.provider === 'google'),
);
const hasTelegram = computed(() =>
	oauthAccounts.value?.some((acc: any) => acc.provider === 'telegram'),
);
const hasFacebook = computed(() =>
	oauthAccounts.value?.some((acc: any) => acc.provider === 'facebook'),
);

const googleProfile = computed(() => oauthProfiles.value?.google);
const telegramProfile = computed(() => oauthProfiles.value?.telegram);
const facebookProfile = computed(() => oauthProfiles.value?.facebook);
const primaryProvider = computed(() => oauthProfiles.value?.primaryProvider);

async function unlinkAccount(provider: string) {
	const confirmMessages: Record<string, string> = {
		google: t('confirmUnlinkGoogle'),
		telegram: t('confirmUnlinkTelegram'),
		facebook: t('confirmUnlinkFacebook'),
	};
	if (!confirm(confirmMessages[provider] || t('confirmUnlinkGoogle'))) return;

	try {
		isLoading.value = true;
		await $fetch(`/api/auth/unlink/${provider}`, { method: 'POST' });
		await Promise.all([refreshAccounts(), refreshOAuthProfiles()]);
		ElMessage.success(t('accountUnlinked'));
	} catch {
		ElMessage.error(t('errorUnlinkAccount'));
	} finally {
		isLoading.value = false;
	}
}

async function setPrimaryProvider(provider: string) {
	try {
		isLoading.value = true;
		await $fetch('/api/auth/set-primary-provider', {
			method: 'POST',
			body: { provider },
		});
		await refreshOAuthProfiles();
		ElMessage.success(t('primaryProviderUpdated'));
	} catch {
		ElMessage.error(t('errorUpdatePriority'));
	} finally {
		isLoading.value = false;
	}
}

function linkGoogle() {
	sessionStorage.setItem('auth_redirect', '/profile');
	window.location.href = '/api/auth/google';
}

const { openTelegramAuth } = useTelegramAuth();

function linkTelegram() {
	openTelegramAuth('/profile');
}

function linkFacebook() {
	sessionStorage.setItem('auth_redirect', '/profile');
	window.location.href = '/api/auth/facebook';
}

// --- Приватность (prd/user-profile, итерации 3-4) ---
const userStore = useUserStore();
const { user } = storeToRefs(userStore);

const isPublicProfile = ref(!!user.value?.is_profile_public);
watch(user, (u) => {
	isPublicProfile.value = !!u?.is_profile_public;
});

const isSavingPrivacy = ref(false);

// Подпись к отзыву глазами других: имя, иначе маскированный email — как на сервере
const previewName = computed(() => {
	if (!isPublicProfile.value) return t('anonymousUser');
	const u = user.value;
	if (!u) return '';
	if (u.name && u.name !== u.email) return u.name;
	return u.email ? maskEmail(u.email) : '';
});

async function onPrivacyChange(value: string | number | boolean) {
	const isPublic = !!value;
	try {
		isSavingPrivacy.value = true;
		await $fetch('/api/auth/update-privacy', {
			method: 'POST',
			body: { isPublic },
		});
		await userStore.fetchUser(true);
		ElMessage.success(t('privacyUpdated'));
	} catch {
		isPublicProfile.value = !isPublic;
		ElMessage.error(t('errorUpdatingPrivacy'));
	} finally {
		isSavingPrivacy.value = false;
	}
}
</script>

<template>
	<section class="profile-section">
		<div class="profile-section__header">
			<div class="profile-section__icon">
				<IconLink :size="20" />
			</div>
			<div>
				<h2 class="profile-section__title">{{ t('linkedAccounts') }}</h2>
				<p class="profile-section__desc">{{
					t('linkedAccountsDescription')
				}}</p>
			</div>
		</div>

		<div class="accounts-grid">
			<ProfileAccountCard
				provider="Google"
				:is-connected="hasGoogle"
				:is-primary="primaryProvider === 'google'"
				:details="
					googleProfile
						? [
								...(googleProfile.given_name
									? [{ label: t('firstName'), value: googleProfile.given_name }]
									: []),
								...(googleProfile.family_name
									? [{ label: t('lastName'), value: googleProfile.family_name }]
									: []),
								...(googleProfile.email
									? [{ label: t('email'), value: googleProfile.email }]
									: []),
							]
						: []
				"
				:verified-email="!!googleProfile?.verified_email"
				:is-loading="isLoading"
				@unlink="unlinkAccount('google')"
				@set-primary="setPrimaryProvider('google')"
				@link="linkGoogle"
			>
				<template #icon><IconGoogle :size="20" /></template>
			</ProfileAccountCard>

			<ProfileAccountCard
				provider="Telegram"
				:is-connected="hasTelegram"
				:is-primary="primaryProvider === 'telegram'"
				:details="
					telegramProfile
						? [
								...(telegramProfile.first_name
									? [
											{
												label: t('firstName'),
												value: telegramProfile.first_name,
											},
										]
									: []),
								...(telegramProfile.last_name
									? [{ label: t('lastName'), value: telegramProfile.last_name }]
									: []),
								...(telegramProfile.username
									? [
											{
												label: t('username'),
												value: `@${telegramProfile.username}`,
											},
										]
									: []),
								{
									label: t('telegramId'),
									value: String(telegramProfile.telegram_id),
								},
							]
						: []
				"
				:is-loading="isLoading"
				@unlink="unlinkAccount('telegram')"
				@set-primary="setPrimaryProvider('telegram')"
				@link="linkTelegram"
			>
				<template #icon><IconTelegram :size="20" color="#54a9eb" /></template>
			</ProfileAccountCard>

			<ProfileAccountCard
				provider="Facebook"
				:is-connected="hasFacebook"
				:is-primary="primaryProvider === 'facebook'"
				:details="
					facebookProfile
						? [
								...(facebookProfile.name
									? [{ label: t('firstName'), value: facebookProfile.name }]
									: []),
								...(facebookProfile.email
									? [{ label: t('email'), value: facebookProfile.email }]
									: []),
							]
						: []
				"
				:is-loading="isLoading"
				@unlink="unlinkAccount('facebook')"
				@set-primary="setPrimaryProvider('facebook')"
				@link="linkFacebook"
			>
				<template #icon><IconFacebook :size="20" color="#1877F2" /></template>
			</ProfileAccountCard>
		</div>
	</section>

	<section class="profile-section">
		<div class="profile-section__header">
			<div class="profile-section__icon">
				<IconLock :size="20" />
			</div>
			<div>
				<h2 class="profile-section__title">{{ t('privacyTitle') }}</h2>
				<p class="profile-section__desc">{{ t('privacyDescription') }}</p>
			</div>
		</div>

		<div class="privacy-toggle">
			<div class="privacy-toggle__text">
				<span class="privacy-toggle__label">{{ t('publicProfileLabel') }}</span>
				<span class="privacy-toggle__hint">{{
					isPublicProfile ? t('publicProfileHint') : t('privateProfileHint')
				}}</span>
			</div>
			<el-switch
				v-model="isPublicProfile"
				:disabled="isSavingPrivacy"
				@change="onPrivacyChange"
			/>
		</div>

		<div class="privacy-preview">
			<span class="privacy-preview__label">{{ t('privacyPreviewLabel') }}</span>
			<div class="privacy-preview__card">
				<span
					class="privacy-preview__author"
					:class="{ 'privacy-preview__author--anon': !isPublicProfile }"
				>
					{{ previewName }}
				</span>
				<RatingStars :rating="5" />
			</div>
		</div>
	</section>
</template>

<style scoped>
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

.accounts-grid {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
	gap: var(--spacing-lg);
}

.privacy-toggle {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: var(--spacing-lg);
}

.privacy-toggle__text {
	display: flex;
	flex-direction: column;
	gap: 2px;
	min-width: 0;
}

.privacy-toggle__label {
	font-size: var(--font-size-base);
	font-weight: var(--font-weight-medium);
	color: var(--color-text-primary);
}

.privacy-toggle__hint {
	font-size: var(--font-size-sm);
	color: var(--color-text-muted);
	line-height: 1.4;
}

.privacy-preview {
	margin-top: var(--spacing-xl);
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
}

.privacy-preview__label {
	font-size: var(--font-size-sm);
	color: var(--color-text-muted);
}

.privacy-preview__card {
	display: flex;
	align-items: center;
	gap: var(--spacing-md);
	padding: var(--spacing-md) var(--spacing-lg);
	border: var(--border-width-thin) solid var(--color-border-secondary);
	border-radius: var(--border-radius-lg);
	background: var(--color-bg-secondary);
}

.privacy-preview__author {
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-primary);
}

.privacy-preview__author--anon {
	color: var(--color-text-muted);
	font-style: italic;
}

@media (max-width: 640px) {
	.accounts-grid {
		grid-template-columns: 1fr;
	}

	.profile-section {
		padding: var(--spacing-xl) var(--spacing-lg);
	}
}
</style>
