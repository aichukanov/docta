<script setup lang="ts">
import doctorProfileI18n from '~/i18n/doctor-profile';
import { combineI18nMessages } from '~/i18n/utils';
import { getRegionalQuery } from '~/common/url-utils';

const { t } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([doctorProfileI18n]),
});

const { locale } = useI18n({ useScope: 'global' });

const profileLink = computed(() => ({
	name: 'profile-doctor',
	query: getRegionalQuery(locale.value),
}));
</script>

<template>
	<div class="owner-banner">
		<div class="owner-banner__content">
			<IconEdit :size="18" />
			<span class="owner-banner__text">{{ t('ownerBanner') }}</span>
		</div>
		<NuxtLink :to="profileLink" class="owner-banner__link">
			{{ t('ownerBannerManage') }}
		</NuxtLink>
	</div>
</template>

<style scoped lang="less">
.owner-banner {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: var(--spacing-md);
	padding: var(--spacing-md) var(--spacing-xl);
	background: var(--color-primary-bg);
	border: 1px solid var(--color-border-accent);
	border-radius: var(--border-radius-lg);
}

.owner-banner__content {
	display: flex;
	align-items: center;
	gap: var(--spacing-sm);
	color: var(--color-primary);
}

.owner-banner__text {
	font-size: var(--font-size-base);
	font-weight: var(--font-weight-medium);
}

.owner-banner__link {
	font-size: var(--font-size-sm);
	font-weight: var(--font-weight-semibold);
	color: var(--color-primary);
	text-decoration: none;
	white-space: nowrap;
	transition: color var(--transition-fast);

	&:hover {
		color: var(--color-primary-dark);
	}
}
</style>
