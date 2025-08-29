<template>
	<div class="location-item">
		<div class="location-info">
			<div class="clinic-name-container">
				<a
					v-if="clinic.website"
					:href="clinic.website"
					target="_blank"
					rel="noopener noreferrer"
					class="clinic-website-link clinic-name"
				>
					{{ clinic.clinicName }}
				</a>
				<span v-else class="clinic-name">{{ clinic.clinicName }}</span>
			</div>
			<div v-if="clinic.address" class="location-address">
				<IconMapPin
					class="pin-icon"
					:size="16"
					color="var(--color-bg-primary)"
				/>
				<span>{{ clinic.address }}</span>
			</div>
		</div>
		<div class="location-buttons">
			<!-- <ClinicShowOnMapButton
				:clinic="clinic"
				:location-index="locationIndex"
				:doctor-id="doctorId"
				@show-on-map="onShowOnMap"
			/>
			<ClinicRouteButton :clinic="clinic" /> -->
		</div>
	</div>
</template>

<script setup lang="ts">
import type { DoctorClinicFull } from '~/interfaces/doctor';

defineProps<{
	clinic: DoctorClinicFull;
	locationIndex?: number;
	doctorId?: number;
}>();

const emit = defineEmits<{
	showOnMap: [clinic: DoctorClinicFull, coordinates: [number, number]];
}>();

const onShowOnMap = (
	clinic: DoctorClinicFull,
	coordinates: [number, number],
) => {
	emit('showOnMap', clinic, coordinates);
};
</script>

<style scoped>
.location-item {
	display: flex;
	justify-content: space-between;
	align-items: center;
	background: var(--color-surface-secondary);
	border: 1px solid var(--color-border-light);
	border-radius: var(--border-radius-md);
	padding: var(--spacing-md) var(--spacing-lg);
	gap: var(--spacing-lg);
}

.location-info {
	display: flex;
	flex-direction: column;
	align-items: flex-start;
	gap: var(--spacing-xs);
	flex: 1;
}

.clinic-name-container {
	display: flex;
	align-items: center;
	gap: var(--spacing-xs);
}

.clinic-name {
	font-size: var(--font-size-lg);
	font-weight: 600;
	color: var(--color-text-primary);
}

.clinic-website-link {
	color: var(--color-primary);
	text-decoration: none;
	transition: color var(--transition-base);
	font-weight: inherit;
}

.clinic-website-link:hover {
	color: var(--color-primary-dark);
	text-decoration: underline;
}

.location-address {
	display: flex;
	align-items: center;
	gap: var(--spacing-xs);
	font-size: var(--font-size-md);
	color: var(--color-text-secondary);
}

.pin-icon {
	flex-shrink: 0;
	opacity: 0.8;
}

.location-buttons {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xs);
	align-items: stretch;
}

@media (max-width: 768px) {
	.location-item {
		flex-direction: column;
		align-items: stretch;
		gap: var(--spacing-md);
		padding: var(--spacing-md);
	}
}
</style>
