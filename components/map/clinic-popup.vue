<script setup lang="ts">
import type { ClinicData, DoctorData } from '~/interfaces/doctor';

defineProps<{
	clinic: ClinicData;
	doctors: DoctorData[];
}>();
</script>

<template>
	<div class="clinic-popup">
		<h2>{{ clinic.name }}</h2>
		<ClinicRouteButton :clinic="clinic" :text="clinic.address" />

		<div class="doctors-list">
			<DoctorInfo
				v-for="doctor in doctors"
				:key="doctor.id"
				:doctor="doctor"
				short
			/>
		</div>
	</div>
</template>

<style scoped>
.doctors-list {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xl);
	margin-top: var(--spacing-xl);
	max-height: 300px;
	overflow-y: auto;
}
</style>
