<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import { CITY_COORDINATES } from '~/enums/cities';
import { combineI18nMessages } from '~/i18n/utils';
import type { ClinicData } from '~/interfaces/clinic';

import cityI18n from '~/i18n/city';
import medicalServiceI18n from '~/i18n/medical-service';

const router = useRouter();
const route = useRoute();

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([cityI18n, medicalServiceI18n]),
});

const { cityIds, clinicIds, name, updateFromRoute, getRouteParams } =
	useFilters();

updateFromRoute(route.query);

const medicalServicesListRef = ref<HTMLElement>();
const medicalServicesMapRef = ref<HTMLElement>();
const PAGE_LIMIT = 50;
const pageNumber = ref(+route.query.page || 1);

const filterList = computed(() => ({
	cityIds: cityIds.value,
	clinicIds: clinicIds.value,
	name: name.value,
}));

const { pending: isLoadingMedicalServices, data: medicalServicesList } =
	await useFetch('/api/medical-services/list', {
		key: 'medical-services-list',
		method: 'POST',
		body: filterList,
	});

const { pending: isLoadingClinics, data: clinicsList } = await useFetch(
	'/api/clinics/list',
	{
		key: 'clinics-list',
		method: 'POST',
	},
);

const routeWithParams = computed(() => {
	return {
		query: {
			page: pageNumber.value > 1 ? pageNumber.value : undefined,
			...getRouteParams().query,
			...getRegionalQuery(locale.value),
		},
	};
});

const medicalServicesOnPage = computed(() => {
	if (!medicalServicesList.value?.medicalServices) {
		return [];
	}
	return medicalServicesList.value.medicalServices.slice(
		(pageNumber.value - 1) * PAGE_LIMIT,
		pageNumber.value * PAGE_LIMIT,
	);
});

const showClinicOnMap = (clinic: ClinicData) => {
	medicalServicesMapRef.value.openClinicPopup(clinic);
};

const onMapReady = () => {
	watch(
		cityIds,
		() => {
			medicalServicesMapRef.value?.centerOnLocations(
				cityIds.value.map((cityId) => CITY_COORDINATES[cityId]),
			);
		},
		{ immediate: true },
	);
};

const clinicName = computed(() => {
	if (clinicIds.value.length === 1) {
		const clinic = clinicsList.value?.clinics?.find(
			(c) => c.id === clinicIds.value[0],
		);
		return clinic?.name || '';
	}
	return '';
});

const pageTitle = computed(() => {
	if (cityIds.value.length === 1) {
		if (clinicIds.value.length === 1) {
			return t('MedicalServicesCityClinic', {
				city: t(`city_${cityIds.value[0]}_genitive`),
				clinic: clinicName.value,
			});
		}
		return t('MedicalServicesCity', {
			city: t(`city_${cityIds.value[0]}_genitive`),
		});
	}

	if (clinicIds.value.length === 1) {
		return t('MedicalServicesClinic', {
			clinic: clinicName.value,
		});
	}

	return t('MedicalServices');
});

const pageTitleWithCount = computed(() => {
	return `${pageTitle.value} (${medicalServicesList.value?.totalCount || 0})`;
});

const robotsMeta = computed(() => {
	if (
		!medicalServicesList.value?.medicalServices ||
		medicalServicesList.value.medicalServices.length === 0
	) {
		return 'noindex, follow';
	}
	return undefined;
});

useSeoMeta({
	title: pageTitleWithCount,
	robots: robotsMeta,
});

onMounted(async () => {
	await nextTick();
	router.replace(routeWithParams.value);

	watch(filterList, () => {
		pageNumber.value = 1;
		router.replace(routeWithParams.value);
	});

	watch(pageNumber, () => {
		router.replace(routeWithParams.value);
	});

	watch(pageNumber, () => {
		window.scrollTo(0, 0);
		if (medicalServicesListRef.value) {
			medicalServicesListRef.value.scrollTo(0, 0);
		}
	});
});
</script>

<template>
	<div class="medical-services-page">
		<div ref="medicalServicesListRef" class="medical-services-sidebar">
			<h1 class="page-title">{{ pageTitleWithCount }}</h1>

			<div class="medical-services-list-container">
				<div class="filters-sidebar">
					<FilterName />
					<FilterCitySelect v-model:value="cityIds" />
					<FilterClinicSelect
						:clinics="clinicsList?.clinics || []"
						v-model:value="clinicIds"
					/>
				</div>

				<div class="medical-services-list-content">
					<div
						v-if="isLoadingMedicalServices || isLoadingClinics"
						class="loading"
					>
						<div class="loading-spinner"></div>
						<p>{{ t('LoadingMedicalServices') }}</p>
					</div>

					<div v-else class="medical-services-list">
						<div
							v-if="
								!medicalServicesList?.medicalServices ||
								medicalServicesList.medicalServices.length === 0
							"
							class="empty-state"
						>
							<p>{{ t('NoMedicalServicesFound') }}</p>
						</div>

						<MedicalServiceListCard
							v-for="medicalService in medicalServicesOnPage"
							:key="medicalService.id"
							:medicalService="medicalService"
							:clinics="clinicsList?.clinics || []"
							@show-on-map="showClinicOnMap($event)"
						/>
					</div>

					<Pagination
						:total="medicalServicesList?.totalCount || 0"
						:page-size="PAGE_LIMIT"
						v-model:current-page="pageNumber"
					/>
				</div>
			</div>
		</div>

		<div class="map-container">
			<DoctorsMap
				ref="medicalServicesMapRef"
				:doctors="medicalServicesList?.medicalServices || []"
				:clinics="clinicsList?.clinics || []"
				@ready="onMapReady"
			/>
		</div>
	</div>
</template>

<style lang="less" scoped>
@import url('~/assets/css/vars.less');

.medical-services-page {
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

.medical-services-sidebar {
	flex: 1 1 60%;
	background: #ffffff;
	border-right: 1px solid rgba(0, 0, 0, 0.06);
	overflow-y: auto;
	padding: var(--spacing-lg);
}

.page-title {
	font-size: 2rem;
	font-weight: 600;
	color: #1f2937;
	margin: 0 0 @double-padding 0;
	font-family: system-ui, -apple-system, sans-serif;
}

.medical-services-list-container {
	display: flex;
	flex-direction: row;
	gap: var(--spacing-2xl);

	.medical-services-list-content {
		flex: 1 1 auto;
	}
}

.medical-services-list {
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

	.medical-services-list-container {
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
	.medical-services-page {
		height: auto;
		flex-wrap: wrap;
	}

	.map-container {
		max-height: 60vh;
		overflow: hidden;
	}
}

@media (max-width: 500px) {
	.medical-services-sidebar {
		padding: var(--spacing-sm);
	}
}
</style>
