<script setup lang="ts">
import { createDoctorUrl, getRegionalQuery } from '~/common/url-utils';
import { useDoctorsStore } from '~/stores/doctors';

const { t, locale } = useI18n();

const doctorsListRef = ref<HTMLElement>();
const doctorsMapRef = ref<HTMLElement>();
const PAGE_LIMIT = 20;
const pageNumber = ref(1);

const { pending: isLoadingDoctors, data: doctorsList } = await useFetch(
	'/api/doctors/list',
	{
		key: 'doctors-list',
		method: 'POST',
	},
);

const { pending: isLoadingClinics, data: clinicsList } = await useFetch(
	'/api/clinics/list',
	{
		key: 'clinics-list',
		method: 'POST',
	},
);

const filteredDoctors = computed(() => {
	// todo: фильтрация
	return doctorsList.value.doctors;
});

const doctorsOnPage = computed(() => {
	return filteredDoctors.value.slice(
		(pageNumber.value - 1) * PAGE_LIMIT,
		pageNumber.value * PAGE_LIMIT,
	);
});

const showClinicOnMap = (clinic: ClinicData) => {
	doctorsMapRef.value.openClinicPopup(clinic);
};

watch(pageNumber, () => {
	window.scrollTo(0, 0);
	if (doctorsListRef.value) {
		doctorsListRef.value.scrollTo(0, 0);
	}
});
</script>

<template>
	<PageWrapper>
		<div class="doctors-page">
			<div ref="doctorsListRef" class="doctors-sidebar">
				<h1 class="page-title">{{ t('Doctors') }}</h1>

				<div v-if="isLoadingDoctors || isLoadingClinics" class="loading">
					<div class="loading-spinner"></div>
					<p>{{ t('LoadingDoctors') }}</p>
				</div>

				<div v-else class="doctors-list">
					<div v-if="doctorsList.doctors.length === 0" class="empty-state">
						<p>{{ t('NoDoctorsFound') }}</p>
					</div>

					<DoctorListCard
						v-for="doctor in doctorsOnPage"
						:key="doctor.id"
						:doctor="doctor"
						:clinics="clinicsList.clinics"
						@show-on-map="showClinicOnMap($event)"
					/>
				</div>

				<Pagination
					:total="doctorsList.totalCount"
					:page-size="PAGE_LIMIT"
					v-model:current-page="pageNumber"
				/>
			</div>

			<div class="map-container">
				<DoctorsMap
					ref="doctorsMapRef"
					:doctors="filteredDoctors"
					:clinics="clinicsList.clinics"
				/>
			</div>
		</div>
	</PageWrapper>
</template>

<style lang="less" scoped>
@import url('~/assets/css/vars.less');

.doctors-page {
	display: flex;
	height: calc(100vh - 120px);
	gap: 0;
}

.doctors-sidebar {
	flex: 1;
	max-width: 50%;
	padding: @double-padding;
	background: #ffffff;
	border-right: 1px solid rgba(0, 0, 0, 0.06);
	overflow-y: auto;
}

.page-title {
	font-size: 2rem;
	font-weight: 600;
	color: #1f2937;
	margin: 0 0 @double-padding 0;
	font-family: system-ui, -apple-system, sans-serif;
}

.doctors-list {
	display: flex;
	flex-direction: column;
	gap: @base-padding;
}

.loading {
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	padding: 40px;
	color: #6b7280;
}

.loading-spinner {
	width: 40px;
	height: 40px;
	border: 3px solid #e5e7eb;
	border-top: 3px solid #4f46e5;
	border-radius: 50%;
	animation: spin 1s linear infinite;
	margin-bottom: 16px;
}

@keyframes spin {
	0% {
		transform: rotate(0deg);
	}
	100% {
		transform: rotate(360deg);
	}
}

.empty-state {
	text-align: center;
	padding: 40px;
	color: #6b7280;
}

.map-container {
	flex: 1;
	max-width: 50%;
	position: relative;
}

@media (max-width: 768px) {
	.doctors-page {
		flex-direction: column;
		height: auto;
	}

	.doctors-sidebar,
	.map-container {
		max-width: 100%;
	}

	.map-container {
		height: 400px;
	}
}
</style>

<i18n lang="json">
{
	"en": {
		"Doctors": "Doctors",
		"LoadingDoctors": "Loading doctors...",
		"NoDoctorsFound": "No doctors found"
	},
	"ru": {
		"Doctors": "Врачи",
		"LoadingDoctors": "Загрузка врачей...",
		"NoDoctorsFound": "Врачи не найдены"
	},
	"tr": {
		"Doctors": "Doktorlar",
		"LoadingDoctors": "Doktorlar yükleniyor...",
		"NoDoctorsFound": "Doktor bulunamadı"
	},
	"de": {
		"Doctors": "Ärzte",
		"LoadingDoctors": "Ärzte werden geladen...",
		"NoDoctorsFound": "Keine Ärzte gefunden"
	},
	"sr": {
		"Doctors": "Lekari",
		"LoadingDoctors": "Učitava lekare...",
		"NoDoctorsFound": "Lekari nisu pronađeni"
	},
	"ba": {
		"Doctors": "Lekari",
		"LoadingDoctors": "Učitava lekare...",
		"NoDoctorsFound": "Lekari nisu pronađeni"
	},
	"me": {
		"Doctors": "Lekari",
		"LoadingDoctors": "Učitava lekare...",
		"NoDoctorsFound": "Lekari nisu pronađeni"
	}
}
</i18n>
