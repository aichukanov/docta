<template>
	<div class="location-item">
		<div class="location-info">
			<div class="clinic-name-container">
				<el-link
					v-if="clinic.website"
					:href="clinic.website"
					:underline="false"
					target="_blank"
					class="clinic-name"
				>
					{{ clinic.name }}
				</el-link>
				<span v-else class="clinic-name">{{ clinic.name }}</span>
			</div>
			<div v-if="clinic.address" class="location-address">
				<el-icon><LocationFilled /></el-icon>
				<span>{{ clinic.address }}</span>
			</div>
		</div>
		<div class="location-buttons">
			<ClinicShowOnMapButton :clinic="clinic" @click="showOnMap()" />
			<ClinicRouteButton :clinic="clinic" />
		</div>
	</div>
</template>

<script setup lang="ts">
import { LocationFilled } from '@element-plus/icons-vue';
import type { ClinicData } from '~/interfaces/doctor';

const props = defineProps<{
	clinic: ClinicData;
}>();

function showOnMap() {
	console.log('showOnMap', props.clinic);
}
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
