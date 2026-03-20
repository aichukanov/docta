<script setup lang="ts">
import type { DoctorData } from '~/interfaces/doctor';

defineProps<{
	doctor: DoctorData;
	description?: string;
	isOwner?: boolean;
}>();
</script>

<template>
	<header class="doctor-hero">
		<DoctorOwnerBanner v-if="isOwner" />
		<DoctorInfo :service="doctor" isMainHeading />
		<MarkedContent
			v-if="description"
			:content="description"
			class="doctor-hero__description"
		/>
	</header>
</template>

<style lang="less" scoped>
.doctor-hero {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
	padding: var(--spacing-xl) 0;
}

.doctor-hero__description {
	color: var(--color-text-primary);
	line-height: 1.6;
	padding-top: var(--spacing-lg);
	border-top: 1px solid var(--color-border-light);
}
</style>
