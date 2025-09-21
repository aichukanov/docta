<script setup lang="ts">
const loadedDoctorsKey = ref(0);
const { pending: isLoadingDoctors, data: doctorsList } = await useFetch(
	'/api/doctors/list',
	{
		key: `doctors-list`,
		method: 'POST',
		body: computed(() => ({
			specialtyIds: [],
			cityIds: [],
			languageIds: [],
			key: loadedDoctorsKey.value,
		})),
	},
);

const { pending: isLoadingClinics, data: clinicsList } = await useFetch(
	'/api/clinics/list',
	{
		key: 'clinics-list',
		method: 'POST',
	},
);

const updateDoctors = () => {
	loadedDoctorsKey.value++;
};
</script>

<template>
	<div class="admin-index">
		<div v-if="isLoadingDoctors || isLoadingClinics">
			<div class="loading-spinner"></div>
			<p>Загрузка врачей и клиник...</p>
		</div>
		<el-collapse v-else expand-icon-position="left">
			<el-collapse-item title="Найти врача">
				<AdminDoctorFind
					:doctors="doctorsList.doctors"
					@updated="updateDoctors"
				/>
			</el-collapse-item>

			<el-collapse-item title="Объединить врачей">
				<AdminDoctorMerge
					:doctors="doctorsList.doctors"
					@updated="updateDoctors"
				/>
			</el-collapse-item>

			<el-collapse-item title="Добавить врача">
				<AdminDoctorAdd
					:clinics="clinicsList.clinics"
					@updated="updateDoctors"
				/>
			</el-collapse-item>

			<el-collapse-item title="Добавить клинику">
				<AdminClinicFind :clinics="clinicsList.clinics" />
			</el-collapse-item>

			<el-collapse-item title="Добавить клинику">
				<AdminClinicAdd />
			</el-collapse-item>
		</el-collapse>
	</div>
</template>

<style scoped>
.admin-index {
	width: min(1000px, 100%);
	margin: 0 auto;
}
</style>
