<script setup lang="ts">
const { pending: isLoadingDoctors, data: doctorsList } = await useFetch(
	'/api/doctors/list',
	{
		key: 'doctors-list',
		method: 'POST',
		body: {
			specialtyIds: [],
			cityIds: [],
			languageIds: [],
		},
	},
);

const { pending: isLoadingClinics, data: clinicsList } = await useFetch(
	'/api/clinics/list',
	{
		key: 'clinics-list',
		method: 'POST',
	},
);
</script>

<template>
	<div class="admin-index">
		<el-collapse expand-icon-position="left">
			<el-collapse-item title="Найти врача">
				<AdminDoctorFind
					:doctors="doctorsList.doctors"
					:isLoadingDoctors="isLoadingDoctors"
				/>
			</el-collapse-item>

			<el-collapse-item title="Добавить врача">
				<AdminDoctorAdd
					:clinics="clinicsList.clinics"
					:isLoadingClinics="isLoadingClinics"
				/>
			</el-collapse-item>

			<el-collapse-item title="Добавить клинику">
				<AdminClinicFind
					:clinics="clinicsList.clinics"
					:isLoadingClinics="isLoadingClinics"
				/>
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
