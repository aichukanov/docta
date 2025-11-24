<script setup lang="ts">
const loadedDoctorsKey = ref(0);
const loadedClinicsKey = ref(0);

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
		key: `clinics-list`,
		method: 'POST',
		body: computed(() => ({
			key: loadedClinicsKey.value,
		})),
	},
);

const updateDoctors = () => {
	loadedDoctorsKey.value++;
};

const updateClinics = () => {
	loadedClinicsKey.value++;
};
</script>

<template>
	<div class="admin-index">
		<div v-if="isLoadingDoctors || isLoadingClinics">
			<div class="loading-spinner"></div>
			<p>Загрузка врачей и клиник...</p>
		</div>
		<el-tabs v-else>
			<el-tab-pane label="Добавить врача">
				<AdminDoctorAdd
					:clinics="clinicsList.clinics"
					@updated="updateDoctors"
				/>
			</el-tab-pane>

			<el-tab-pane label="Найти врача">
				<AdminDoctorFind
					:doctors="doctorsList.doctors"
					:clinics="clinicsList.clinics"
					@updated="updateDoctors"
				/>
			</el-tab-pane>

			<el-tab-pane label="Объединить врачей">
				<AdminDoctorMerge
					:doctors="doctorsList.doctors"
					:clinics="clinicsList.clinics"
					@updated="updateDoctors"
				/>
			</el-tab-pane>

			<el-tab-pane label="Найти клинику">
				<AdminClinicFind :clinics="clinicsList.clinics" />
			</el-tab-pane>

			<el-tab-pane label="Добавить клинику">
				<AdminClinicAdd @updated="updateClinics" />
			</el-tab-pane>
		</el-tabs>
	</div>
</template>

<style scoped>
.admin-index {
	width: min(1000px, 100%);
	margin: 0 auto;
}
</style>
