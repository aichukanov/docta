<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import { CITY_COORDINATES } from '~/enums/cities';
import { combineI18nMessages } from '~/i18n/utils';

import cityI18n from '~/i18n/city';
import labTestI18n from '~/i18n/lab-test';

const router = useRouter();
const route = useRoute();

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([cityI18n, labTestI18n]),
});

const { cityIds, clinicIds, name, updateFromRoute, getRouteParams } =
	useFilters();

updateFromRoute(route.query);

const labTestsListRef = ref<HTMLElement>();
const labTestsMapRef = ref<HTMLElement>();
const PAGE_LIMIT = 50;
const pageNumber = ref(+route.query.page || 1);

const filterList = computed(() => ({
	cityIds: cityIds.value,
	clinicIds: clinicIds.value,
	name: name.value,
}));

const { pending: isLoadingLabTests, data: labTestsList } = await useFetch(
	'/api/lab-tests/list',
	{
		key: 'lab-tests-list',
		method: 'POST',
		body: filterList,
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
		query: {
			page: pageNumber.value > 1 ? pageNumber.value : undefined,
			...getRouteParams().query,
			...getRegionalQuery(locale.value),
		},
	};
});

const labTestsOnPage = computed(() => {
	return labTestsList.value.labTests.slice(
		(pageNumber.value - 1) * PAGE_LIMIT,
		pageNumber.value * PAGE_LIMIT,
	);
});

const showClinicOnMap = (clinic: ClinicData) => {
	labTestsMapRef.value.openClinicPopup(clinic);
};

const onMapReady = () => {
	watch(
		cityIds,
		() => {
			labTestsMapRef.value?.centerOnLocations(
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
			return t('LabTestsCityClinic', {
				city: t(`city_${cityIds.value[0]}_genitive`),
				clinic: clinicName.value,
			});
		}
		return t('LabTestsCity', {
			city: t(`city_${cityIds.value[0]}_genitive`),
		});
	}

	if (clinicIds.value.length === 1) {
		return t('LabTestsClinic', {
			clinic: clinicName.value,
		});
	}

	return t('LabTests');
});

const pageTitleWithCount = computed(() => {
	return `${pageTitle.value} (${labTestsList.value?.totalCount})`;
});

const robotsMeta = computed(() => {
	if (labTestsList.value?.labTests?.length === 0) {
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
		if (labTestsListRef.value) {
			labTestsListRef.value.scrollTo(0, 0);
		}
	});
});
</script>

<template>
	<div class="lab-tests-page">
		<div ref="labTestsListRef" class="lab-tests-sidebar">
			<h1 class="page-title">{{ pageTitleWithCount }}</h1>

			<div class="lab-tests-list-container">
				<div class="filters-sidebar">
					<FilterName />
					<FilterCitySelect v-model:value="cityIds" />
					<FilterClinicSelect
						:clinics="clinicsList.clinics"
						v-model:value="clinicIds"
					/>
				</div>

				<div class="lab-tests-list-content">
					<div v-if="isLoadingLabTests || isLoadingClinics" class="loading">
						<div class="loading-spinner"></div>
						<p>{{ t('LoadingLabTests') }}</p>
					</div>

					<div v-else class="lab-tests-list">
						<div v-if="labTestsList.labTests.length === 0" class="empty-state">
							<p>{{ t('NoLabTestsFound') }}</p>
						</div>

						<LabTestListCard
							v-for="labTest in labTestsOnPage"
							:key="labTest.id"
							:labTest="labTest"
							:clinics="clinicsList.clinics"
							@show-on-map="showClinicOnMap($event)"
						/>
					</div>

					<Pagination
						:total="labTestsList.totalCount"
						:page-size="PAGE_LIMIT"
						v-model:current-page="pageNumber"
					/>
				</div>
			</div>
		</div>

		<div class="map-container">
			<DoctorsMap
				ref="labTestsMapRef"
				:doctors="labTestsList.labTests"
				:clinics="clinicsList.clinics"
				@ready="onMapReady"
			/>
		</div>
	</div>
</template>

<style lang="less" scoped>
@import url('~/assets/css/vars.less');

.lab-tests-page {
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

.lab-tests-sidebar {
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

.lab-tests-list-container {
	display: flex;
	flex-direction: row;
	gap: var(--spacing-2xl);

	.lab-tests-list-content {
		flex: 1 1 auto;
	}
}

.lab-tests-list {
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

	.lab-tests-list-container {
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
	.lab-tests-page {
		height: auto;
		flex-wrap: wrap;
	}

	.map-container {
		max-height: 60vh;
		overflow: hidden;
	}
}

@media (max-width: 500px) {
	.lab-tests-sidebar {
		padding: var(--spacing-sm);
	}
}
</style>
