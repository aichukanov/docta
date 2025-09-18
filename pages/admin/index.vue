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

const doctorId = ref<number | null>(null);
const clinicId = ref<number | null>(null);

const searchDoctorName = ref('');
const searchDoctorNameInput = ref<HTMLInputElement | null>(null);

const doctorName = ref('');
const doctorEmail = ref('');
const doctorPhone = ref('');
const doctorWebsite = ref('');
const doctorPhotoUrl = ref('');
const doctorFacebook = ref('');
const doctorInstagram = ref('');
const doctorTelegram = ref('');
const doctorWhatsapp = ref('');
const doctorViber = ref('');

const selectedDoctor = computed(() => {
	return doctorsList.value.doctors.find(
		(doctor) => doctor.id === doctorId.value,
	);
});

const selectedClinic = computed(() => {
	return clinicsList.value.clinics.find(
		(clinic) => clinic.id === clinicId.value,
	);
});

const filteredDoctors = computed(() => {
	return doctorsList.value.doctors.filter((doctor) =>
		doctor.name.toLowerCase().includes(searchDoctorName.value.toLowerCase()),
	);
});

const focusSearchDoctorNameInput = async (visible: boolean) => {
	if (visible && searchDoctorNameInput.value) {
		await nextTick();
		searchDoctorNameInput.value.focus();
	}
};
</script>

<template>
	<div>
		<div class="doctor-form">
			<h2>Найти врача</h2>

			<div v-if="isLoadingDoctors">
				<div class="loading-spinner"></div>
				<p>Загрузка врачей...</p>
			</div>
			<div v-else>
				<el-select
					v-model="doctorId"
					placeholder="Выберите врача"
					size="large"
					@visible-change="focusSearchDoctorNameInput($event)"
				>
					<template #header>
						<el-input
							ref="searchDoctorNameInput"
							v-model="searchDoctorName"
							placeholder="Введите имя врача"
						/>
					</template>
					<el-option
						v-for="{ id, name } in filteredDoctors"
						:key="id"
						:label="name"
						:value="id"
					/>
				</el-select>
			</div>
			<div v-if="selectedDoctor" class="doctor-info">
				<h3>Имя: {{ selectedDoctor.name }}</h3>
				<div>
					Фото:
					{{ selectedDoctor.photoUrl }}
					<img :src="selectedDoctor.photoUrl" width="100" height="100" />
				</div>
				<div>email: {{ selectedDoctor.email }}</div>
				<div>Телефон: {{ selectedDoctor.phone }}</div>
				<div>Вебсайт: {{ selectedDoctor.website }}</div>
				<div>Facebook: {{ selectedDoctor.facebook }}</div>
				<div>Instagram: {{ selectedDoctor.instagram }}</div>
				<div>Telegram: {{ selectedDoctor.telegram }}</div>
				<div>Whatsapp: {{ selectedDoctor.whatsapp }}</div>
				<div>Viber: {{ selectedDoctor.viber }}</div>
			</div>
		</div>

		<div class="doctor-form">
			<h2>Добавить врача</h2>

			<el-input v-model="doctorName" placeholder="Имя" required />
			<el-input v-model="doctorPhotoUrl" placeholder="Фото" />
			<el-input v-model="doctorEmail" placeholder="Email" />
			<el-input v-model="doctorPhone" placeholder="Телефон" />
			<el-input v-model="doctorWebsite" placeholder="Вебсайт" />
			<el-input v-model="doctorFacebook" placeholder="Facebook" />
			<el-input v-model="doctorInstagram" placeholder="Instagram" />
			<el-input v-model="doctorTelegram" placeholder="Telegram" />
			<el-input v-model="doctorWhatsapp" placeholder="Whatsapp" />
			<el-input v-model="doctorViber" placeholder="Viber" />

			<div v-if="isLoadingClinics">
				<div class="loading-spinner"></div>
				<p>Загрузка клиник...</p>
			</div>
			<div v-else>
				<el-select v-model="clinicId" placeholder="Клиника" size="large">
					<el-option
						v-for="{ id, name } in clinicsList.clinics"
						:key="id"
						:label="name"
						:value="id"
					/>
				</el-select>
			</div>
		</div>

		<!-- <el-input v-model="doctor.specialty" placeholder="Специальность" />
		<el-input v-model="doctor.language" placeholder="Язык" /> -->
	</div>
</template>

<style scoped>
.doctor-form {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
	max-width: 1000px;
	margin: 0 auto;
}

.doctor-info {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);

	& > div {
		display: flex;
		flex-direction: row;
		align-items: center;
		gap: var(--spacing-lg);
	}
}
</style>
