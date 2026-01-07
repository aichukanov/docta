<script setup lang="ts">
const loadedDoctorsKey = ref(0);
const loadedClinicsKey = ref(0);
const loadedLabTestsKey = ref(0);
const loadedServicesKey = ref(0);

const { pending: isLoadingDoctors, data: doctorsList } = await useFetch(
	'/api/doctors/list',
	{
		key: `doctors-list`,
		method: 'POST',
		body: computed(() => ({
			specialtyIds: [],
			cityIds: [],
			languageIds: [],
			includeAllLocales: true,
			key: loadedDoctorsKey.value,
		})),
	},
);

const { pending: isLoadingLabTests, data: labTestsList } = await useFetch(
	'/api/labtests/list',
	{
		key: `labtests-list-admin`,
		method: 'POST',
		body: computed(() => ({
			key: loadedLabTestsKey.value,
		})),
	},
);

const { pending: isLoadingServices, data: servicesList } = await useFetch(
	'/api/services/list',
	{
		key: `services-list-admin`,
		method: 'POST',
		body: computed(() => ({
			key: loadedServicesKey.value,
		})),
	},
);

const clinicsStore = useClinicsStore();
await clinicsStore.fetchClinics();

const clinicsList = computed(() => ({
	clinics: clinicsStore.clinics,
	totalCount: clinicsStore.clinics.length,
}));
const isLoadingClinics = computed(() => clinicsStore.isLoading);

const labTestsForSelect = computed(() =>
	(labTestsList.value?.items || []).map((lt) => ({
		id: lt.id,
		name: lt.name,
	})),
);

const servicesForSelect = computed(() =>
	(servicesList.value?.items || []).map((s) => ({
		id: s.id,
		name: s.name,
	})),
);

const updateDoctors = () => {
	loadedDoctorsKey.value++;
};

const updateClinics = async () => {
	await clinicsStore.refresh();
};

const updateLabTests = () => {
	loadedLabTestsKey.value++;
};

const updateServices = () => {
	loadedServicesKey.value++;
};
</script>

<template>
	<div class="admin-index">
		<div v-if="isLoadingDoctors || isLoadingClinics || isLoadingLabTests || isLoadingServices">
			<div class="loading-spinner"></div>
			<p>Загрузка данных...</p>
		</div>
		<el-tabs v-else type="border-card">
			<el-tab-pane label="Врачи">
				<el-tabs>
					<el-tab-pane label="Найти">
						<AdminDoctorInfo
							:doctors="doctorsList.doctors"
							:clinics="clinicsList.clinics"
							editable
							@updated="updateDoctors"
						/>
					</el-tab-pane>

					<el-tab-pane label="Добавить">
						<AdminDoctorAdd
							:clinics="clinicsList.clinics"
							@updated="updateDoctors"
						/>
					</el-tab-pane>

					<el-tab-pane label="Объединить">
						<AdminDoctorMerge
							:doctors="doctorsList.doctors"
							:clinics="clinicsList.clinics"
							@updated="updateDoctors"
						/>
					</el-tab-pane>
				</el-tabs>
			</el-tab-pane>

			<el-tab-pane label="Анализы">
				<el-tabs>
					<el-tab-pane label="Найти">
						<AdminLabtestInfo
							:labTests="labTestsForSelect"
							:clinics="clinicsList.clinics"
							editable
							@updated="updateLabTests"
						/>
					</el-tab-pane>

					<el-tab-pane label="Добавить">
						<AdminLabtestAdd
							:clinics="clinicsList.clinics"
							@updated="updateLabTests"
						/>
					</el-tab-pane>

					<el-tab-pane label="Объединить">
						<AdminLabtestMerge
							:labTests="labTestsForSelect"
							:clinics="clinicsList.clinics"
							@updated="updateLabTests"
						/>
					</el-tab-pane>
				</el-tabs>
			</el-tab-pane>

			<el-tab-pane label="Услуги">
				<el-tabs>
					<el-tab-pane label="Найти">
						<AdminServiceInfo
							:services="servicesForSelect"
							:clinics="clinicsList.clinics"
							editable
							@updated="updateServices"
						/>
					</el-tab-pane>

					<el-tab-pane label="Добавить">
						<AdminServiceAdd
							:clinics="clinicsList.clinics"
							@updated="updateServices"
						/>
					</el-tab-pane>

					<el-tab-pane label="Объединить">
						<AdminServiceMerge
							:services="servicesForSelect"
							:clinics="clinicsList.clinics"
							@updated="updateServices"
						/>
					</el-tab-pane>
				</el-tabs>
			</el-tab-pane>

			<el-tab-pane label="Клиники">
				<el-tabs>
					<el-tab-pane label="Найти">
						<AdminClinicFind
							:clinics="clinicsList.clinics"
							editable
							@updated="updateClinics"
						/>
					</el-tab-pane>

					<el-tab-pane label="Добавить">
						<AdminClinicAdd @updated="updateClinics" />
					</el-tab-pane>
				</el-tabs>
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
