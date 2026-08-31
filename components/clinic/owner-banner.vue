<script setup lang="ts">
import clinicProfileI18n from '~/i18n/clinic-profile';
import { PROJECT_CONTACTS } from '~/common/constants';
import { getRegionalQuery } from '~/common/url-utils';
import type { ClinicStatus } from '~/interfaces/clinic';

// Баннер показывается тем, кому вообще досталась непубличная клиника:
// владельцу (со ссылкой в кабинет) и админу (только плашка-предупреждение,
// иначе скрытая страница выглядит для него как живая).
const props = defineProps<{
	status?: ClinicStatus;
	hidden?: boolean;
	/** Причина скрытия админом, как в БД — на сербском. */
	hiddenReason?: string;
	isOwner?: boolean;
}>();

const { t } = useI18n({
	useScope: 'local',
	messages: clinicProfileI18n.messages,
});

const { locale } = useI18n({ useScope: 'global' });

const isDraftVisible = computed(
	() => !props.hidden && props.status != null && props.status !== 'published',
);

const cabinetLink = computed(() => ({
	name: 'profile-clinics',
	query: getRegionalQuery(locale.value),
}));
</script>

<template>
	<div class="owner-banner">
		<div v-if="isOwner" class="owner-banner__row">
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

		<!-- Скрытие админом: почему страницы нет для пациентов, причина (её
		     пишет админ на сербском) и как вернуть клинику -->
		<div v-if="hidden" class="owner-banner__hidden-notice">
			<p class="owner-banner__hidden-text">{{ t('HiddenNotice') }}</p>
			<p v-if="hiddenReason" class="owner-banner__reason">
				<span class="owner-banner__reason-label">{{ t('HiddenReason') }}</span>
				<span lang="sr">{{ hiddenReason }}</span>
			</p>
			<p class="owner-banner__hidden-text">
				{{ t('HiddenReasonAction') }}
				<a :href="`mailto:${PROJECT_CONTACTS.email}`">
					{{ PROJECT_CONTACTS.email }}
				</a>
			</p>
		</div>
	</div>
</template>

<style scoped lang="less">
.owner-banner {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-sm);
	padding: var(--kit-spacing-md) var(--kit-spacing-xl);
	background: var(--kit-color-primary-bg);
	border: 1px solid var(--kit-color-border-accent);
	border-radius: var(--kit-border-radius-lg);
}

.owner-banner__row {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: var(--kit-spacing-md);
}

.owner-banner__content {
	display: flex;
	align-items: center;
	gap: var(--kit-spacing-sm);
	color: var(--kit-color-primary);
}

.owner-banner__text {
	font-size: var(--kit-font-size-base);
	font-weight: var(--kit-font-weight-medium);
}

.owner-banner__link {
	font-size: var(--kit-font-size-sm);
	font-weight: var(--kit-font-weight-semibold);
	color: var(--kit-color-primary);
	text-decoration: none;
	white-space: nowrap;
	transition: color var(--kit-transition-fast);

	&:hover {
		color: var(--kit-color-primary-dark);
	}
}

.owner-banner__draft-notice {
	margin: 0;
	font-size: var(--kit-font-size-sm);
	color: var(--kit-color-warning-dark);
	background: var(--kit-color-warning-bg);
	border: 1px solid var(--kit-color-warning-border);
	border-radius: var(--kit-border-radius-md);
	padding: var(--kit-spacing-xs) var(--kit-spacing-md);
}

.owner-banner__hidden-notice {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-xs);
	background: var(--kit-color-danger-bg);
	border: 1px solid var(--kit-color-danger-border);
	border-radius: var(--kit-border-radius-md);
	padding: var(--kit-spacing-xs) var(--kit-spacing-md);
}

.owner-banner__hidden-text {
	margin: 0;
	font-size: var(--kit-font-size-sm);
	color: var(--kit-color-danger-dark);
	line-height: 1.5;
}

.owner-banner__reason {
	margin: 0;
	font-size: var(--kit-font-size-sm);
	color: var(--kit-color-text-primary);
	line-height: 1.5;
}

.owner-banner__reason-label {
	font-weight: var(--kit-font-weight-semibold);
	margin-right: var(--kit-spacing-xs);
}
</style>
