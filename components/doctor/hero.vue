<script setup lang="ts">
import type { DoctorData } from '~/interfaces/doctor';

const props = defineProps<{
	doctor: DoctorData;
	isOwner?: boolean;
}>();

const isNonPublic = computed(
	() =>
		props.doctor.isDraft === true ||
		props.doctor.hidden === true ||
		props.doctor.hiddenByAdmin === true,
);
</script>

<template>
	<header class="doctor-hero">
		<!-- Непубличный профиль получают только владелец и админ: баннер
		     объясняет, почему пациенты его не видят. Для админа это
		     единственный признак, что профиль скрыт. -->
		<DoctorOwnerBanner
			v-if="isOwner || isNonPublic"
			:isOwner="isOwner"
			:isDraft="doctor.isDraft"
			:hidden="doctor.hidden"
			:hiddenByAdmin="doctor.hiddenByAdmin"
			:hiddenReason="doctor.hiddenReason"
		/>
		<DoctorInfo :service="doctor" isMainHeading />
	</header>
</template>

<style lang="less" scoped>
.doctor-hero {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-lg);
	padding: var(--kit-spacing-xl) 0;
}
</style>
