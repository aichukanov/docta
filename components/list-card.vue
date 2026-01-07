<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';

interface ClinicServiceItem {
	id: number;
	name: string;
	localName: string;
	price: number | null;
}

interface ClinicServicesMap {
	[clinicId: number]: ClinicServiceItem[];
}

const props = defineProps<{
	title?: string;
	localName?: string;
	itemId?: number;
	clinicIds: string;
	clinicPrices?: ClinicService[];
	detailsRouteName?: string;
	detailsParamName?: string;
	clinicServices?: ClinicServicesMap;
}>();

defineEmits<{
	(e: 'show-on-map', clinic: ClinicData): void;
}>();

const { locale } = useI18n();
const clinicsStore = useClinicsStore();

const getPriceInfo = (clinicId: number) =>
	props.clinicPrices?.find((p) => p.clinicId === clinicId);

const getServices = (clinicId: number) => props.clinicServices?.[clinicId];

// clinicIds уже отсортированы на бэкенде по количеству услуг
const sortedClinics = computed(() =>
	clinicsStore.getClinicsByIds(props.clinicIds),
);

const detailsLink = computed(() => {
	if (!props.detailsRouteName || !props.detailsParamName || !props.itemId) {
		return null;
	}
	return {
		name: props.detailsRouteName,
		params: { [props.detailsParamName]: props.itemId },
		query: getRegionalQuery(locale.value),
	};
});
</script>

<template>
	<div class="list-card">
		<slot>
			<div v-if="title" class="list-card-header-wrapper">
				<h3 class="list-card-header">
					<NuxtLink v-if="detailsLink" :to="detailsLink" class="list-card-link">
						{{ title }}
					</NuxtLink>
					<template v-else>{{ title }}</template>
				</h3>
				<div v-if="localName" class="list-card-local-name">
					{{ localName }}
				</div>
			</div>
		</slot>

		<div class="clinics-list">
			<ClinicSummary
				v-for="clinic in sortedClinics"
				:key="clinic.id"
				:clinic="clinic"
				:price-info="getPriceInfo(clinic.id)"
				:services="getServices(clinic.id)"
				@show-on-map="$emit('show-on-map', clinic)"
			/>
		</div>
	</div>
</template>

<style scoped lang="less">
.list-card {
	box-sizing: border-box;
	background: var(--color-surface-secondary);
	border: 1px solid var(--color-border-primary);
	border-radius: var(--border-radius-lg);
	padding: var(--spacing-xl) var(--spacing-2xl);
	transition: all var(--transition-base);
	box-shadow: var(--shadow-xs);

	.list-card-header-wrapper {
		display: flex;
		flex-direction: column;
		gap: var(--spacing-xs);
	}

	.list-card-header {
		font-size: 1.25rem;
		font-weight: 600;
		color: #1f2937;
		margin: 0;
		font-family: system-ui, -apple-system, sans-serif;

		.list-card-link {
			color: var(--color-primary);
			text-decoration: none;

			&:hover {
				color: var(--color-primary-dark);
				text-decoration: underline;
			}
		}
	}

	.list-card-local-name {
		font-size: var(--font-size-sm);
		font-weight: var(--font-weight-medium);
		color: var(--color-text-secondary);
	}
}

.clinics-list {
	margin-top: var(--spacing-xl);
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
}

@media (max-width: 500px) {
	.list-card {
		padding: var(--spacing-sm) var(--spacing-xs);
	}
}
</style>
