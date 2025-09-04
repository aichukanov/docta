<script setup lang="ts">
import type { ClinicData, DoctorData } from '~/interfaces/doctor';

const props = defineProps<{
	clinic: ClinicData;
	doctors: DoctorData[];
}>();

const doctorsListRef = ref<HTMLElement>();
const pageNumber = ref(1);
const PAGE_LIMIT = 20;

const doctorsOnPage = computed(() => {
	return props.doctors.slice(
		(pageNumber.value - 1) * PAGE_LIMIT,
		pageNumber.value * PAGE_LIMIT,
	);
});

watch(pageNumber, () => {
	if (doctorsListRef.value) {
		doctorsListRef.value.scrollTo(0, 0);
	}
});
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

		<div class="doctors-list" ref="doctorsListRef">
			<DoctorInfo
				v-for="doctor in doctorsOnPage"
				:key="doctor.id"
				:doctor="doctor"
				short
			/>
			<Pagination
				align="center"
				:total="doctors.length"
				:page-size="PAGE_LIMIT"
				v-model:current-page="pageNumber"
			/>
		</div>
	</div>
</template>

<style scoped lang="less">
.doctors-list {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xl);
	margin-top: var(--spacing-xl);
	margin-right: -20px; // fix inner leaflet margin
	padding-right: var(--spacing-xs);
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
