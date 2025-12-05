<template>
	<div class="medication-card">
		<div class="medication-header">
			<h3 class="medication-name">{{ medication.name }}</h3>
		</div>

		<div class="clinics-list">
			<ClinicSummary
				v-for="clinic in medicationClinics"
				:key="clinic.id"
				:clinic="clinic"
				@show-on-map="$emit('show-on-map', clinic)"
			/>
		</div>
	</div>
</template>

<script setup lang="ts">
import type { MedicationData } from '~/interfaces/medication';
import type { ClinicData } from '~/interfaces/doctor';

const props = defineProps<{
	medication: MedicationData;
	clinics: ClinicData[];
}>();

defineEmits<{
	(e: 'show-on-map', clinic: ClinicData): void;
}>();

const medicationClinics = computed(() => {
	return props.clinics.filter((clinic) =>
		props.medication.clinicIds.split(',').map(Number).includes(clinic.id),
	);
});
</script>

<style scoped lang="less">
.medication-card {
	background: var(--color-surface-secondary);
	border: 1px solid var(--color-border-primary);
	border-radius: var(--border-radius-lg);
	padding: var(--spacing-xl) var(--spacing-2xl);
	transition: all var(--transition-base);
	box-shadow: var(--shadow-xs);
}

.medication-header {
	margin-bottom: var(--spacing-md);
}

.medication-name {
	font-size: 1.25rem;
	font-weight: 600;
	color: #1f2937;
	margin: 0;
	font-family: system-ui, -apple-system, sans-serif;
}

.clinics-list {
	margin-top: var(--spacing-xl);
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
}

@media (max-width: 500px) {
	.medication-card {
		padding: var(--spacing-sm) var(--spacing-xs);
	}

	.medication-name {
		font-size: 1.1rem;
	}
}
</style>
