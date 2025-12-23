<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';

const props = defineProps<{
	title?: string;
	itemId?: number;
	clinicIds: string;
	clinicPrices?: ClinicService[];
	detailsRouteName?: string;
	detailsParamName?: string;
}>();

defineEmits<{
	(e: 'show-on-map', clinic: ClinicData): void;
}>();

const { locale } = useI18n();
const clinicsStore = useClinicsStore();

const filteredClinics = computed(() => {
	return clinicsStore.clinics.filter((clinic) =>
		props.clinicIds.split(',').map(Number).includes(clinic.id),
	);
});

const getPriceInfo = (clinicId: number) =>
	props.clinicPrices?.find((p) => p.clinicId === clinicId);

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
			<h3 v-if="title" class="list-card-header">
				<NuxtLink v-if="detailsLink" :to="detailsLink" class="list-card-link">
					{{ title }}
				</NuxtLink>
				<template v-else>{{ title }}</template>
			</h3>
		</slot>

		<div class="clinics-list">
			<ClinicSummary
				v-for="clinic in filteredClinics"
				:key="clinic.id"
				:clinic="clinic"
				:price-info="getPriceInfo(clinic.id)"
				linkable
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
