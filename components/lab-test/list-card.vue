<template>
	<div class="lab-test-card">
		<div class="lab-test-header">
			<h3 class="lab-test-name">{{ labTest.name }}</h3>
		</div>

		<div class="clinics-list">
			<LabTestClinicSummary
				v-for="clinic in labTestClinics"
				:key="clinic.id"
				:clinic="clinic"
				:price-info="getPriceInfo(clinic.id)"
				@show-on-map="$emit('show-on-map', clinic)"
			/>
		</div>
	</div>
</template>

<script setup lang="ts">
import type { LabTestData } from '~/interfaces/lab-test';
import type { ClinicData } from '~/interfaces/doctor';

const props = defineProps<{
	labTest: LabTestData;
	clinics: ClinicData[];
}>();

defineEmits<{
	(e: 'show-on-map', clinic: ClinicData): void;
}>();

const labTestClinics = computed(() => {
	if (!props.labTest.clinicIds) {
		return [];
	}
	return props.clinics.filter((clinic) =>
		props.labTest.clinicIds.split(',').map(Number).includes(clinic.id),
	);
});

const getPriceInfo = (clinicId: number) => {
	if (!props.labTest.clinicPrices) {
		return undefined;
	}
	return props.labTest.clinicPrices.find((p) => p.clinicId === clinicId);
};
</script>

<style scoped lang="less">
.lab-test-card {
	background: var(--color-surface-secondary);
	border: 1px solid var(--color-border-primary);
	border-radius: var(--border-radius-lg);
	padding: var(--spacing-xl) var(--spacing-2xl);
	transition: all var(--transition-base);
	box-shadow: var(--shadow-xs);
}

.lab-test-header {
	margin-bottom: var(--spacing-md);
}

.lab-test-name {
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
	.lab-test-card {
		padding: var(--spacing-sm) var(--spacing-xs);
	}

	.lab-test-name {
		font-size: 1.1rem;
	}
}
</style>
