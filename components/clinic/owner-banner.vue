<script setup lang="ts">
import clinicProfileI18n from '~/i18n/clinic-profile';
import { getRegionalQuery } from '~/common/url-utils';
import type { ClinicStatus } from '~/interfaces/clinic';

const props = defineProps<{
	status?: ClinicStatus;
}>();

const { t } = useI18n({
	useScope: 'local',
	messages: clinicProfileI18n.messages,
});

const { locale } = useI18n({ useScope: 'global' });

const isDraftVisible = computed(
	() => props.status != null && props.status !== 'published',
);

const cabinetLink = computed(() => ({
	name: 'profile-clinics',
	query: getRegionalQuery(locale.value),
}));
</script>

<template>
	<div class="owner-banner">
		<div class="owner-banner__row">
			<div class="owner-banner__content">
				<IconEdit :size="18" />
				<span class="owner-banner__text">{{ t('OwnerBanner') }}</span>
			</div>
			<NuxtLink :to="cabinetLink" class="owner-banner__link">
				{{ t('OwnerBannerManage') }}
			</NuxtLink>
		</div>
		<p v-if="isDraftVisible" class="owner-banner__draft-notice">
			{{ t('DraftNotice') }}
		</p>
	</div>
</template>

<style scoped lang="less">
.owner-banner {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
	padding: var(--spacing-md) var(--spacing-xl);
	background: var(--color-primary-bg);
	border: 1px solid var(--color-border-accent);
	border-radius: var(--border-radius-lg);
}

.owner-banner__row {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: var(--spacing-md);
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

.owner-banner__draft-notice {
	margin: 0;
	font-size: var(--font-size-sm);
	color: var(--color-warning-dark);
	background: var(--color-warning-bg);
	border: 1px solid var(--color-warning-border);
	border-radius: var(--border-radius-md);
	padding: var(--spacing-xs) var(--spacing-md);
}
</style>
