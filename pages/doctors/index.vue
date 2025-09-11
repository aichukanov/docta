<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';

const router = useRouter();
const route = useRoute();
const { t, locale } = useI18n();
const { specialtyIds, cityIds, languageIds, updateFromRoute, getRouteParams } =
	useFilters();

updateFromRoute(route.query);

const doctorsListRef = ref<HTMLElement>();
const doctorsMapRef = ref<HTMLElement>();
const PAGE_LIMIT = 20;
const pageNumber = ref(1);

const filterList = computed(() => ({
	specialtyIds: specialtyIds.value,
	cityIds: cityIds.value,
	languageIds: languageIds.value,
}));

const { pending: isLoadingDoctors, data: doctorsList } = await useFetch(
	'/api/doctors/list',
	{
		key: 'doctors-list',
		method: 'POST',
		body: computed(() => ({
			specialtyIds: specialtyIds.value,
			cityIds: cityIds.value,
			languageIds: languageIds.value,
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

const routeWithParams = computed(() => {
	return {
		query: { ...getRouteParams().query, ...getRegionalQuery(locale.value) },
	};
});

const doctorsOnPage = computed(() => {
	return doctorsList.value.doctors.slice(
		(pageNumber.value - 1) * PAGE_LIMIT,
		pageNumber.value * PAGE_LIMIT,
	);
});

const showClinicOnMap = (clinic: ClinicData) => {
	doctorsMapRef.value.openClinicPopup(clinic);
};

onMounted(async () => {
	await nextTick();
	router.replace(routeWithParams.value);

	watch(filterList, () => {
		pageNumber.value = 1;

		router.replace(routeWithParams.value);
	});

	watch(pageNumber, () => {
		window.scrollTo(0, 0);
		if (doctorsListRef.value) {
			doctorsListRef.value.scrollTo(0, 0);
		}
	});
});
</script>

<template>
	<div class="doctors-page">
		<div class="filters-sidebar">
			<FilterCity />
			<FilterLanguage />
			<FilterSpecialty />
		</div>

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
				:doctors="doctorsList.doctors"
				:clinics="clinicsList.clinics"
			/>
		</div>
	</div>
</template>

<style lang="less" scoped>
@import url('~/assets/css/vars.less');

.doctors-page {
	display: flex;
	height: calc(100vh - 120px);
	gap: 0;
}

.filters-sidebar {
	display: flex;
	flex-direction: column;
	flex: 1 1 auto;
	min-width: 180px;
	max-width: 320px;
	padding: @double-padding @double-padding;
	background: #ffffff;
	border-right: 1px solid rgba(0, 0, 0, 0.06);
	overflow-y: auto;
	gap: var(--spacing-lg);
}

.doctors-sidebar {
	flex: 1 1 auto;
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
	flex: 1 1 auto;
	position: relative;
}

@media (max-width: 768px) {
	.doctors-page {
		flex-direction: column;
		height: auto;
	}

	.filters-sidebar {
		width: 100%;
		max-width: 100%;
		min-width: 0;
		border-right: none;
		border-bottom: 1px solid rgba(0, 0, 0, 0.06);
		overflow: visible;
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
