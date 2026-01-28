<script setup lang="ts">
import { LocationFilled } from '@element-plus/icons-vue';
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

const localizedName = computed(() => getLocalizedName(props.clinic, locale.value));
</script>

<template>
	<header class="clinic-header">
		<div class="clinic-main-info">
			<div class="clinic-title-wrapper">
				<h1 class="clinic-title">{{ localizedName }}</h1>
				<ClinicApprovedBadge :clinic="clinic" />
			</div>

			<address class="clinic-address">
				<LocationFilled aria-hidden="true" />
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
	gap: var(--spacing-xl);
	background: var(--color-surface-primary);
	border: 1px solid var(--color-border-light);
	border-radius: var(--border-radius-md);
	padding: var(--spacing-lg) var(--spacing-xl);
}

.clinic-main-info {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
}

.clinic-title-wrapper {
	display: flex;
	align-items: center;
	gap: var(--spacing-xs);
}

.clinic-title {
	font-size: var(--font-size-2xl);
	font-weight: 600;
	color: var(--color-text-primary);
	margin: 0;
	font-family: system-ui, -apple-system, sans-serif;
}

.clinic-address {
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

.clinic-actions {
	display: flex;
	gap: var(--spacing-sm);
	margin-top: var(--spacing-sm);
}

.clinic-description-container {
	margin-top: var(--spacing-xs);
}

.clinic-contacts {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
	padding-top: var(--spacing-lg);
	border-top: 1px solid var(--color-border-light);
}

.contacts-title {
	font-size: var(--font-size-lg);
	font-weight: 600;
	color: var(--color-text-primary);
	margin: 0;
	font-family: system-ui, -apple-system, sans-serif;
}
</style>
