<script setup lang="ts">
import type { ClinicData } from '~/interfaces/doctor';

defineProps<{
	clinic: ClinicData;
}>();
</script>

<template>
	<div class="clinic-popup">
		<h3>{{ clinic.name }}</h3>
		<p>{{ clinic.address }}</p>
		<ClinicRouteButton :clinic="clinic" />
	</div>
</template>

<style scoped>
.clinic-popup {
}
</style>
