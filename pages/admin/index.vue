<script setup lang="ts">
// Проверка авторизации
definePageMeta({
	middleware: 'admin-auth',
});

// Получаем данные текущего пользователя
const { data: authData } = await useFetch('/api/admin/auth/me');
const currentUser = computed(() => authData.value?.user);

async function handleLogout() {
	try {
		await $fetch('/api/admin/auth/logout', { method: 'POST' });
		// Перенаправляем на страницу входа
		navigateTo({ name: 'admin-login', query: getRegionalQuery(locale.value) });
	} catch (error) {
		console.error('Logout error:', error);
	}
}

// Активный таб
const activeTab = ref('doctors');

// Флаги загрузки данных для каждого таба
const loadedTabs = ref({
	doctors: false,
	labtests: false,
	services: false,
	clinics: false,
});

// Состояние загрузки
const isLoadingDoctors = ref(false);
const isLoadingLabTests = ref(false);
const isLoadingServices = ref(false);
const isLoadingClinics = ref(false);

// Данные
const doctorsList = ref(null);
const labTestsList = ref(null);
const servicesList = ref(null);
const clinicsStore = useClinicsStore();

const clinicsList = computed(() => ({
	clinics: clinicsStore.clinics,
	totalCount: clinicsStore.clinics.length,
}));

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

// Загрузка данных по табам
async function loadDoctorsData() {
	if (loadedTabs.value.doctors) return;

	isLoadingDoctors.value = true;
	try {
		const data = await $fetch('/api/doctors/list', {
			method: 'POST',
			body: {
				specialtyIds: [],
				cityIds: [],
				languageIds: [],
				includeAllLocales: true,
			},
		});
		doctorsList.value = data;
		loadedTabs.value.doctors = true;
	} catch (error) {
		console.error('Failed to load doctors:', error);
	} finally {
		isLoadingDoctors.value = false;
	}
}

async function loadLabTestsData() {
	if (loadedTabs.value.labtests) return;

	isLoadingLabTests.value = true;
	try {
		const data = await $fetch('/api/labtests/list', {
			method: 'POST',
			body: {},
		});
		labTestsList.value = data;
		loadedTabs.value.labtests = true;
	} catch (error) {
		console.error('Failed to load lab tests:', error);
	} finally {
		isLoadingLabTests.value = false;
	}
}

async function loadServicesData() {
	if (loadedTabs.value.services) return;

	isLoadingServices.value = true;
	try {
		const data = await $fetch('/api/services/list', {
			method: 'POST',
			body: {},
		});
		servicesList.value = data;
		loadedTabs.value.services = true;
	} catch (error) {
		console.error('Failed to load services:', error);
	} finally {
		isLoadingServices.value = false;
	}
}

async function loadClinicsData() {
	if (loadedTabs.value.clinics) return;

	isLoadingClinics.value = true;
	try {
		await clinicsStore.fetchClinics();
		loadedTabs.value.clinics = true;
	} catch (error) {
		console.error('Failed to load clinics:', error);
	} finally {
		isLoadingClinics.value = false;
	}
}

// Отслеживание изменения активного таба
watch(activeTab, async (newTab) => {
	switch (newTab) {
		case 'doctors':
			await loadDoctorsData();
			break;
		case 'labtests':
			await loadLabTestsData();
			break;
		case 'services':
			await loadServicesData();
			break;
		case 'clinics':
			await loadClinicsData();
			break;
	}
});

// Загружаем данные для первого таба
onMounted(() => {
	loadDoctorsData();
});

// Функции обновления данных
const updateDoctors = async () => {
	loadedTabs.value.doctors = false;
	await loadDoctorsData();
};

const updateClinics = async () => {
	loadedTabs.value.clinics = false;
	await loadClinicsData();
};

const updateLabTests = async () => {
	loadedTabs.value.labtests = false;
	await loadLabTestsData();
};

const updateServices = async () => {
	loadedTabs.value.services = false;
	await loadServicesData();
};
</script>

<template>
	<div class="admin-index">
		<div class="admin-header">
			<h1>Админ-панель</h1>
			<div class="admin-user-info">
				<span v-if="currentUser" class="user-email">{{
					currentUser.email
				}}</span>
				<el-button type="danger" size="small" @click="handleLogout">
					Выйти
				</el-button>
			</div>
		</div>

		<el-tabs v-model="activeTab" type="border-card">
			<el-tab-pane label="Врачи" name="doctors">
				<div v-if="isLoadingDoctors" class="tab-loading">
					<div class="loading-spinner"></div>
					<p>Загрузка данных о врачах...</p>
				</div>
				<el-tabs v-else-if="doctorsList">
					<el-tab-pane label="Найти">
						<AdminDoctorInfo
							:doctors="doctorsList.doctors"
							:clinics="clinicsList.clinics"
							:services="servicesForSelect"
							editable
							@updated="updateDoctors"
						/>
					</el-tab-pane>

					<el-tab-pane label="Добавить">
						<AdminDoctorAdd
							:clinics="clinicsList.clinics"
							:services="servicesForSelect"
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

			<el-tab-pane label="Анализы" name="labtests">
				<div v-if="isLoadingLabTests" class="tab-loading">
					<div class="loading-spinner"></div>
					<p>Загрузка данных об анализах...</p>
				</div>
				<el-tabs v-else-if="labTestsList">
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

			<el-tab-pane label="Услуги" name="services">
				<div v-if="isLoadingServices" class="tab-loading">
					<div class="loading-spinner"></div>
					<p>Загрузка данных об услугах...</p>
				</div>
				<el-tabs v-else-if="servicesList">
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

			<el-tab-pane label="Клиники" name="clinics">
				<div v-if="isLoadingClinics" class="tab-loading">
					<div class="loading-spinner"></div>
					<p>Загрузка данных о клиниках...</p>
				</div>
				<el-tabs
					v-else-if="clinicsList.clinics.length > 0 || loadedTabs.clinics"
				>
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

.admin-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 20px;
	padding: 16px 20px;
	background: white;
	border-radius: 8px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.admin-header h1 {
	margin: 0;
	font-size: 24px;
	color: #2c3e50;
}

.admin-user-info {
	display: flex;
	align-items: center;
	gap: 12px;
}

.user-email {
	font-size: 14px;
	color: #7f8c8d;
	font-weight: 500;
}

.tab-loading {
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	padding: 40px;
	gap: 16px;
}

.loading-spinner {
	width: 40px;
	height: 40px;
	border: 4px solid #f3f3f3;
	border-top: 4px solid #409eff;
	border-radius: 50%;
	animation: spin 1s linear infinite;
}

@keyframes spin {
	0% {
		transform: rotate(0deg);
	}
	100% {
		transform: rotate(360deg);
	}
}
</style>
