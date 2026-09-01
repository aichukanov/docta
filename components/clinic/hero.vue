<script setup lang="ts">
import IconMapPin from '~/components/icon/map-pin.vue';
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
			<ClinicLogo
				:logoUrl="clinic.logoUrl"
				:name="localizedName"
				:size="80"
				zoomable
				loading="eager"
			/>
			<div class="clinic-hero__header-info">
				<div class="clinic-hero__title-row">
					<h1 class="clinic-hero__name">{{ localizedName }}</h1>
					<ClinicApprovedBadge :clinic="clinic" />
				</div>

				<div v-if="clinic.localName" class="clinic-hero__original-name">
					{{ clinic.localName }}
				</div>

				<div v-if="clinicTypeNames?.length" class="clinic-hero__types">
					<CategoryTag
						v-for="typeName in clinicTypeNames"
						:key="typeName"
						small
						>{{ typeName }}</CategoryTag
					>
				</div>

				<address class="clinic-hero__address">
					<IconMapPin aria-hidden="true" size="1em" />
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
	gap: var(--kit-spacing-md);
	padding: var(--kit-spacing-xl) 0;
}

.clinic-hero__header {
	display: flex;
	align-items: flex-start;
	gap: var(--kit-spacing-lg);
}

.clinic-hero__header-info {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-sm);
	min-width: 0;
}

.clinic-hero__title-row {
	display: flex;
	align-items: center;
	gap: var(--kit-spacing-sm);
}

.clinic-hero__name {
	font-size: var(--kit-font-size-4xl);
	font-weight: 700;
	color: var(--kit-color-text-primary);
	margin: 0;
	font-family:
		system-ui,
		-apple-system,
		sans-serif;
	line-height: 1.2;
}

/* Оригинальное название на сербской латинице — под локализованным */
.clinic-hero__original-name {
	font-size: var(--kit-font-size-md);
	font-weight: var(--kit-font-weight-medium);
	color: var(--kit-color-text-secondary);
	margin-top: calc(-1 * var(--kit-spacing-xs));
}

.clinic-hero__actions {
	display: flex;
	gap: var(--kit-spacing-sm);
}

.clinic-hero__types {
	display: flex;
	flex-wrap: wrap;
	gap: var(--kit-spacing-xs);
}

.clinic-hero__address {
	display: flex;
	align-items: center;
	gap: var(--kit-spacing-xs);
	font-size: var(--kit-font-size-md);
	color: var(--kit-color-text-secondary);
	font-style: normal;

	svg {
		width: 18px;
		height: 18px;
		flex-shrink: 0;
	}
}

@media (max-width: 500px) {
	.clinic-hero__name {
		font-size: var(--kit-font-size-3xl);
	}
}
</style>
