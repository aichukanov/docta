<script setup lang="ts">
import type { DoctorData } from '~/interfaces/doctor';

defineProps<{
	doctor: DoctorData;
	isOwner?: boolean;
}>();
</script>

<template>
	<header class="doctor-hero">
		<DoctorOwnerBanner v-if="isOwner" />
		<DoctorInfo :service="doctor" isMainHeading />
	</header>
</template>

<style lang="less" scoped>
.doctor-hero {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
	padding: var(--spacing-xl) 0;
}
</style>
