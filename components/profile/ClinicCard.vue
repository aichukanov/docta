<script setup lang="ts">
import { Edit, CreditCard } from '@element-plus/icons-vue';
import clinicProfileI18n from '~/i18n/clinic-profile';
import clinicBillingI18n from '~/i18n/clinic-billing';
import clinicTypeI18n from '~/i18n/clinic-type';
import cityI18n from '~/i18n/city';
import { combineI18nMessages } from '~/i18n/utils';
import { getRegionalQuery } from '~/common/url-utils';
import type { ClinicMyListItem } from '~/server/api/clinics/my-list';

const props = defineProps<{
	clinic: ClinicMyListItem;
	isToggling: boolean;
}>();

const emit = defineEmits<{
	(e: 'publish'): void;
	(e: 'hide'): void;
	(e: 'edit'): void;
}>();

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		clinicProfileI18n,
		clinicBillingI18n,
		clinicTypeI18n,
		cityI18n,
	]),
});

const billingLink = computed(() => ({
	path: `/profile/clinics/${props.clinic.id}/billing`,
	query: getRegionalQuery(locale.value),
}));

const typeNames = computed(() => {
	if (!props.clinic.clinicTypeIds) return [];
	return props.clinic.clinicTypeIds
		.split(',')
		.map(Number)
		.filter(Boolean)
		.map((id) => t(`clinic_type_${id}`));
});

const cityName = computed(() =>
	props.clinic.cityId ? t(`city_${props.clinic.cityId}`) : '',
);
</script>

<template>
	<section class="clinic-card">
		<div class="clinic-card__profile">
			<ClinicLogo
				:logoUrl="clinic.logoUrl"
				:name="clinic.name"
				:size="64"
			/>
			<div class="clinic-card__info">
				<div class="clinic-card__name">
					{{ clinic.name }}
					<span
						v-if="clinic.localName && clinic.localName !== clinic.name"
						class="clinic-card__local-name"
					>
						({{ clinic.localName }})
					</span>
				</div>
				<div v-if="typeNames.length" class="clinic-card__meta">
					{{ typeNames.join(', ') }}
				</div>
				<div v-if="cityName || clinic.addressSr" class="clinic-card__meta">
					{{ [cityName, clinic.addressSr].filter(Boolean).join(', ') }}
				</div>
			</div>
		</div>

		<div class="clinic-card__edit">
			<el-button plain :icon="Edit" @click="emit('edit')">
				{{ t('BtnEdit') }}
			</el-button>
			<NuxtLink :to="billingLink">
				<el-button plain :icon="CreditCard">
					{{ t('BillingButton') }}
				</el-button>
			</NuxtLink>
		</div>

		<ProfileClinicStatusBlock
			:status="clinic.status"
			:clinic-slug="clinic.slug"
			:is-toggling="isToggling"
			@publish="emit('publish')"
			@hide="emit('hide')"
		/>
	</section>
</template>

<style scoped>
.clinic-card {
	background: var(--color-bg-primary);
	border-radius: var(--border-radius-xl);
	padding: var(--spacing-2xl);
	box-shadow: var(--shadow-sm);
	border: 1px solid var(--color-border-secondary);
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xl);
}

.clinic-card__profile {
	display: flex;
	gap: var(--spacing-lg);
	align-items: flex-start;
}

.clinic-card__info {
	display: flex;
	flex-direction: column;
	gap: 4px;
	min-width: 0;
}

.clinic-card__name {
	font-size: var(--font-size-xl);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-heading);
	line-height: 1.3;
}

.clinic-card__local-name {
	font-weight: var(--font-weight-normal);
	color: var(--color-text-secondary);
}

.clinic-card__meta {
	font-size: var(--font-size-sm);
	color: var(--color-text-secondary);
	line-height: 1.4;
}

.clinic-card__edit {
	display: flex;
	gap: var(--spacing-sm);
	flex-wrap: wrap;
}

@media (max-width: 640px) {
	.clinic-card {
		padding: var(--spacing-xl) var(--spacing-lg);
	}

	.clinic-card__profile {
		flex-direction: column;
		align-items: center;
		text-align: center;
	}
}
</style>
