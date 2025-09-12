<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import { CITY_COORDINATES } from '~/enums/cities';
import specialtyI18n from '~/i18n/specialty';
import cityI18n from '~/i18n/city';

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

const onMapReady = () => {
	watch(
		cityIds,
		() => {
			doctorsMapRef.value?.centerOnLocations(
				cityIds.value.map((cityId) => CITY_COORDINATES[cityId]),
			);
		},
		{ immediate: true },
	);
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

const pageTitle = computed(() => {
	if (specialtyIds.value.length === 1) {
		if (cityIds.value.length === 1) {
			return t('DoctorsSpecialtyCity', {
				specialtyDoctors:
					specialtyI18n.messages[locale.value][
						`doctors_${specialtyIds.value[0].toString()}`
					],
				city: cityI18n.messages[locale.value][cityIds.value[0].toString()],
			});
		}

		return t('DoctorsSpecialty', {
			specialtyDoctors:
				specialtyI18n.messages[locale.value][
					`doctors_${specialtyIds.value[0].toString()}`
				],
		});
	} else if (cityIds.value.length === 1) {
		return t('DoctorsCity', {
			city: cityI18n.messages[locale.value][cityIds.value[0].toString()],
		});
	}

	return t('Doctors');
});
</script>

<template>
	<div class="doctors-page">
		<div ref="doctorsListRef" class="doctors-sidebar">
			<h1 class="page-title">{{ pageTitle }}</h1>

			<div class="doctors-list-container">
				<div class="filters-sidebar">
					<FilterCity />
					<FilterLanguage />
					<FilterSpecialty />
				</div>

				<div class="doctors-list-content">
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
			</div>
		</div>

		<div class="map-container">
			<DoctorsMap
				ref="doctorsMapRef"
				:doctors="doctorsList.doctors"
				:clinics="clinicsList.clinics"
				@ready="onMapReady"
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
	overflow-x: auto;
}

.filters-sidebar {
	display: flex;
	box-sizing: border-box;
	flex-direction: column;
	flex: 1 1 auto;
	min-width: 180px;
	max-width: 320px;
	background: #ffffff;
	overflow-y: auto;
	gap: var(--spacing-lg);
	position: sticky;
	top: var(--spacing-lg);
	align-self: flex-start;
	max-height: calc(100vh - 120px - 2 * var(--spacing-lg));
}

.doctors-sidebar {
	flex: 1 1 60%;
	padding: var(--spacing-lg);
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

.doctors-list-container {
	display: flex;
	flex-direction: row;
	gap: var(--spacing-2xl);

	.doctors-list-content {
		flex: 1 1 auto;
	}
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
	flex: 1 1 40%;
}

@media (max-width: 1300px) {
	.page-title {
		margin-bottom: var(--spacing-lg);
	}

	.doctors-list-container {
		flex-direction: column;

		.filters-sidebar {
			position: initial;
			max-width: 100%;
			width: 100%;
			gap: var(--spacing-sm);
		}
	}
}

@media (max-width: 950px) {
	.doctors-page {
		height: auto;
		flex-wrap: wrap;
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
		"DoctorsCity": "Врачи в городе {city}",
		"DoctorsSpecialty": "{specialtyDoctors} в Черногории",
		"DoctorsSpecialtyCity": "{specialtyDoctors} в городе {city}",
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
