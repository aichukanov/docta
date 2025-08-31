<template>
	<div class="doctor-card">
		<DoctorInfo :doctor="doctor" />

		<div class="clinics-list">
			<ClinicSummary
				v-for="clinic in doctor.clinics"
				:key="clinic.clinicId"
				:clinic="clinic"
			/>
		</div>
	</div>
</template>

<script setup lang="ts">
import type { DoctorWithClinics } from '~/interfaces/doctor';

const props = defineProps<{
	doctor: DoctorWithClinics;
}>();
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
	background: var(--color-surface-primary);
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
