<template>
	<div class="doctor-card">
		<DoctorInfo :doctor="doctor" />

		<div class="clinics-list">
			<ClinicSummary
				v-for="clinic in doctorClinics"
				:key="clinic.id"
				:clinic="clinic"
				@show-on-map="$emit('show-on-map', clinic)"
			/>
		</div>
	</div>
</template>

<script setup lang="ts">
import type { DoctorData } from '~/interfaces/doctor';
import type { ClinicData } from '~/interfaces/clinic';

const props = defineProps<{
	doctor: DoctorData;
	clinics: ClinicData[];
}>();

defineEmits<{
	(e: 'show-on-map', clinic: ClinicData): void;
}>();

const doctorClinics = computed(() => {
	return props.clinics.filter((clinic) =>
		props.doctor.clinicIds.split(',').map(Number).includes(clinic.id),
	);
});
</script>

<style scoped lang="less">
.clinics-list {
	margin-top: var(--spacing-xl);
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
	flex: 1;
}

.doctor-card {
	background: var(--color-surface-secondary);
	border: 1px solid var(--color-border-primary);
	border-radius: var(--border-radius-lg);
	padding: var(--spacing-xl) var(--spacing-2xl);
	transition: all var(--transition-base);
	box-shadow: var(--shadow-xs);
}

@media (max-width: 768px) {
	.doctor-card {
		padding: var(--spacing-xl);
	}
}
</style>
