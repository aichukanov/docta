<script setup lang="ts">
import IconMapPin from '~/components/icon/map-pin.vue';
import { formatClinicAddressLine } from '~/common/clinic-address';
import { getLocalizedName } from '~/common/utils';
import type { ClinicData } from '~/interfaces/clinic';

interface Props {
	clinic: ClinicData;
	cityName: string;
	description?: string;
	languageAssistanceLabel: string;
	contactsLabel: string;
	showOnMapLabel: string;
}

const props = defineProps<Props>();

defineEmits<{
	showOnMap: [clinic: ClinicData];
}>();

const { locale } = useI18n();

const localizedName = computed(() =>
	getLocalizedName(props.clinic, locale.value),
);
</script>

<template>
	<header class="clinic-header">
		<div class="clinic-main-info">
			<div class="clinic-title-wrapper">
				<h1 class="clinic-title">{{ localizedName }}</h1>
				<ClinicApprovedBadge :clinic="clinic" />
			</div>

			<address class="clinic-address">
				<IconMapPin aria-hidden="true" size="1em" />
				<span>{{
					formatClinicAddressLine({
						clinic: clinic,
						cityName: cityName,
					})
				}}</span>
			</address>

			<ConsultationLanguages :languageIds="clinic.languageIds">
				{{ languageAssistanceLabel }}
			</ConsultationLanguages>

			<div class="clinic-actions" role="group">
				<ClinicShowOnMapButton
					:clinic="clinic"
					:aria-label="showOnMapLabel"
					@click="$emit('showOnMap', clinic)"
				/>
				<ClinicRouteButton :clinic="clinic" />
			</div>

			<MarkedContent
				v-if="description"
				:content="description"
				class="clinic-description-container"
			/>
		</div>

		<section class="clinic-contacts" :aria-label="contactsLabel">
			<h2 class="contacts-title">{{ contactsLabel }}</h2>
			<ContactsList :list="clinic" />
		</section>
	</header>
</template>

<style lang="less" scoped>
.clinic-header {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-xl);
	background: var(--kit-color-surface-primary);
	border: 1px solid var(--kit-color-border-light);
	border-radius: var(--kit-border-radius-md);
	padding: var(--kit-spacing-lg) var(--kit-spacing-xl);
}

.clinic-main-info {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-md);
}

.clinic-title-wrapper {
	display: flex;
	align-items: center;
	gap: var(--kit-spacing-xs);
}

.clinic-title {
	font-size: var(--kit-font-size-2xl);
	font-weight: 600;
	color: var(--kit-color-text-primary);
	margin: 0;
	font-family:
		system-ui,
		-apple-system,
		sans-serif;
}

.clinic-address {
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

.clinic-actions {
	display: flex;
	gap: var(--kit-spacing-sm);
	margin-top: var(--kit-spacing-sm);
}

.clinic-description-container {
	margin-top: var(--kit-spacing-xs);
}

.clinic-contacts {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-md);
	padding-top: var(--kit-spacing-lg);
	border-top: 1px solid var(--kit-color-border-light);
}

.contacts-title {
	font-size: var(--kit-font-size-lg);
	font-weight: 600;
	color: var(--kit-color-text-primary);
	margin: 0;
	font-family:
		system-ui,
		-apple-system,
		sans-serif;
}
</style>
