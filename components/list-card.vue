<script setup lang="ts">
import type { DoctorData } from '~/interfaces/doctor';
import type { ClinicData } from '~/interfaces/clinic';

const props = defineProps<{
	title?: string;
	clinicIds: string;
	clinics: ClinicData[];
	clinicPrices?: ClinicService[];
}>();

defineEmits<{
	(e: 'show-on-map', clinic: ClinicData): void;
}>();

const filteredClinics = computed(() => {
	return props.clinics.filter((clinic) =>
		props.clinicIds.split(',').map(Number).includes(clinic.id),
	);
});

const getPriceInfo = (clinicId: number) =>
	props.clinicPrices?.find((p) => p.clinicId === clinicId);
</script>

<template>
	<div class="list-card">
		<slot>
			<h3 v-if="title" class="list-card-header">{{ title }}</h3>
		</slot>

		<div class="clinics-list">
			<ClinicSummary
				v-for="clinic in filteredClinics"
				:key="clinic.id"
				:clinic="clinic"
				:price-info="getPriceInfo(clinic.id)"
				@show-on-map="$emit('show-on-map', clinic)"
			/>
		</div>
	</div>
</template>

<style scoped lang="less">
.list-card {
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
