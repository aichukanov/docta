<template>
	<div class="medical-service-card">
		<div class="medical-service-header">
			<h3 class="medical-service-name">{{ medicalService.name }}</h3>
		</div>

		<div class="clinics-list">
			<ClinicSummary
				v-for="clinic in medicalServiceClinics"
				:key="clinic.id"
				:clinic="clinic"
				@show-on-map="$emit('show-on-map', clinic)"
			/>
		</div>
	</div>
</template>

<script setup lang="ts">
import type { MedicalServiceData } from '~/interfaces/medical-service';
import type { ClinicData } from '~/interfaces/clinic';

const props = defineProps<{
	medicalService: MedicalServiceData;
	clinics: ClinicData[];
}>();

defineEmits<{
	(e: 'show-on-map', clinic: ClinicData): void;
}>();

const medicalServiceClinics = computed(() => {
	return props.clinics.filter((clinic) =>
		props.medicalService.clinicIds.split(',').map(Number).includes(clinic.id),
	);
});
</script>

<style scoped lang="less">
.medical-service-card {
	background: var(--color-surface-secondary);
	border: 1px solid var(--color-border-primary);
	border-radius: var(--border-radius-lg);
	padding: var(--spacing-xl) var(--spacing-2xl);
	transition: all var(--transition-base);
	box-shadow: var(--shadow-xs);
}

.medical-service-header {
	margin-bottom: var(--spacing-md);
}

.medical-service-name {
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
	.medical-service-card {
		padding: var(--spacing-sm) var(--spacing-xs);
	}

	.medical-service-name {
		font-size: 1.1rem;
	}
}
</style>
