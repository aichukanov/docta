<script setup lang="ts">
import { LocationFilled } from '@element-plus/icons-vue';
import { formatClinicAddressLine } from '~/common/clinic-address';
import { getLocalizedName } from '~/common/utils';
import type { ClinicData } from '~/interfaces/clinic';

interface Props {
	clinic: ClinicData;
	cityName: string;
	languageAssistanceLabel: string;
	clinicTypeNames?: string[];
}

const props = defineProps<Props>();
defineEmits<{ scrollToMap: [] }>();
const { locale } = useI18n();

const localizedName = computed(() =>
	getLocalizedName(props.clinic, locale.value),
);
</script>

<template>
	<header class="clinic-hero">
		<div class="clinic-hero__header">
			<ClinicLogo :logoUrl="clinic.logoUrl" :name="localizedName" :size="80" />
			<div class="clinic-hero__header-info">
				<div class="clinic-hero__title-row">
					<h1 class="clinic-hero__name">{{ localizedName }}</h1>
					<ClinicApprovedBadge :clinic="clinic" />
				</div>

				<div v-if="clinicTypeNames?.length" class="clinic-hero__types">
					<span
						v-for="typeName in clinicTypeNames"
						:key="typeName"
						class="clinic-hero__type-tag"
						>{{ typeName }}</span
					>
				</div>

				<address class="clinic-hero__address">
					<LocationFilled aria-hidden="true" />
					<span>{{
						formatClinicAddressLine({
							clinic: clinic,
							cityName: cityName,
						})
					}}</span>
				</address>
			</div>
		</div>

		<ConsultationLanguages :languageIds="clinic.languageIds">
			{{ languageAssistanceLabel }}
		</ConsultationLanguages>

		<div class="clinic-hero__actions">
			<ClinicShowOnMapButton :clinic="clinic" @click="$emit('scrollToMap')" />
			<ClinicRouteButton :clinic="clinic" />
		</div>
	</header>
</template>

<style lang="less" scoped>
.clinic-hero {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
	padding: var(--spacing-xl) 0;
}

.clinic-hero__header {
	display: flex;
	align-items: flex-start;
	gap: var(--spacing-lg);
}

.clinic-hero__header-info {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
	min-width: 0;
}

.clinic-hero__title-row {
	display: flex;
	align-items: center;
	gap: var(--spacing-sm);
}

.clinic-hero__name {
	font-size: 1.75rem;
	font-weight: 700;
	color: var(--color-text-primary);
	margin: 0;
	font-family: system-ui, -apple-system, sans-serif;
	line-height: 1.2;
}

.clinic-hero__actions {
	display: flex;
	gap: var(--spacing-sm);
}

.clinic-hero__types {
	display: flex;
	flex-wrap: wrap;
	gap: var(--spacing-xs);
}

.clinic-hero__type-tag {
	display: inline-block;
	padding: 2px var(--spacing-sm);
	background: var(--color-surface-secondary);
	border-radius: var(--border-radius-sm);
	font-size: var(--font-size-sm);
	color: var(--color-text-secondary);
}

.clinic-hero__address {
	display: flex;
	align-items: center;
	gap: var(--spacing-xs);
	font-size: var(--font-size-md);
	color: var(--color-text-secondary);
	font-style: normal;

	svg {
		width: 18px;
		height: 18px;
		flex-shrink: 0;
	}
}

@media (max-width: 500px) {
	.clinic-hero__name {
		font-size: 1.5rem;
	}
}
</style>
