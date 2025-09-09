<script setup lang="ts">
const { t } = useI18n();
const route = useRoute();
const doctorsMapRef = ref<HTMLElement>();

const { pending: isLoadingDoctor, data: doctorData } = await useFetch(
	'/api/doctors/details',
	{
		key: 'doctor-details',
		method: 'POST',
		body: computed(() => ({
			doctorId: route.params.doctorId,
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
const doctorClinics = computed(() => {
	return clinicsList.value.clinics.filter((clinic) =>
		doctorData.value.clinicIds.split(',').map(Number).includes(clinic.id),
	);
});

const showClinicOnMap = (clinic: ClinicData) => {
	doctorsMapRef.value?.openClinicPopup(clinic);
};
</script>

<template>
	<div class="doctor-page">
		<div v-if="isLoadingDoctor" class="loading">
			<div class="loading-spinner"></div>
			<p>{{ t('LoadingDoctor') }}</p>
		</div>
		<div v-else class="doctor-info-container">
			<div class="doctor-info-wrapper">
				<DoctorInfo :doctor="doctorData" />
				<div class="clinics-list">
					<ClinicSummary
						v-for="clinic in doctorClinics"
						:key="clinic.id"
						:clinic="clinic"
						@show-on-map="showClinicOnMap(clinic)"
					/>
				</div>
			</div>
			<DoctorsMap
				ref="doctorsMapRef"
				:doctors="[doctorData]"
				:clinics="doctorClinics"
			/>
		</div>
	</div>
</template>

<style lang="less" scoped>
@import url('~/assets/css/vars.less');

.doctor-page {
	display: flex;
	gap: var(--spacing-2xl);
	margin-top: var(--spacing-2xl);
	justify-content: center;

	.doctor-info-container {
		display: flex;
		flex-direction: row;
		gap: var(--spacing-2xl);
		width: 100%;
		min-height: 700px;
		max-width: 1600px;

		& > * {
			flex: 1;
			height: 100%;
		}

		.doctor-info-wrapper {
			display: flex;
			flex-direction: column;
			gap: var(--spacing-2xl);
		}
	}
}
</style>

<i18n lang="json">
{
	"en": {
		"LoadingDoctor": "Loading doctor data..."
	},
	"ru": {
		"LoadingDoctor": "Загрузка данных о враче..."
	},
	"tr": {
		"LoadingDoctor": "Doktor verileri yükleniyor..."
	},
	"de": {
		"LoadingDoctor": "Doktor-Daten werden geladen..."
	},
	"sr": {
		"LoadingDoctor": "Učitavanje podataka o lekaru..."
	},
	"ba": {
		"LoadingDoctor": "Učitavanje podataka o lekaru..."
	},
	"me": {
		"LoadingDoctor": "Učitavanje podataka o lekaru..."
	}
}
</i18n>
