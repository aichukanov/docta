<script setup lang="ts">
import type { ClinicData, DoctorData } from '~/interfaces/doctor';

defineProps<{
	clinic: ClinicData;
	doctors: DoctorData[];
}>();
</script>

<template>
	<div class="clinic-popup">
		<div class="clinic-name-container">
			<el-link
				v-if="clinic.website"
				:href="clinic.website"
				underline="hover"
				target="_blank"
				class="clinic-name"
			>
				{{ clinic.name }}
			</el-link>
			<h2 v-else class="clinic-name">
				{{ clinic.name }}
			</h2>
		</div>

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

.clinic-name-container {
	margin-bottom: var(--spacing-xs);

	.clinic-name {
		font-size: var(--font-size-2xl);
		font-weight: 600;
	}
}
</style>
