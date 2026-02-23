<script setup lang="ts">
import profileMessages from '~/i18n/profile';
import accountCardMessages from '~/i18n/account-card';
import { combineI18nMessages } from '~/i18n/utils';

const { t } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([profileMessages, accountCardMessages]),
});

const { data: oauthAccounts, refresh: refreshAccounts } = await useFetch(
	'/api/auth/accounts',
);
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
		await refreshAccounts();
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

function linkTelegram() {
	sessionStorage.setItem('auth_redirect', '/profile');
	window.location.href = '/api/auth/telegram';
}

function linkFacebook() {
	sessionStorage.setItem('auth_redirect', '/profile');
	window.location.href = '/api/auth/facebook';
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
				:verified-email="googleProfile?.verified_email"
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

@media (max-width: 640px) {
	.accounts-grid {
		grid-template-columns: 1fr;
	}

	.profile-section {
		padding: var(--spacing-xl) var(--spacing-lg);
	}
}
</style>
