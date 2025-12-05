<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import { CITY_COORDINATES } from '~/enums/cities';
import { combineI18nMessages } from '~/i18n/utils';

import cityI18n from '~/i18n/city';
import clinicI18n from '~/i18n/clinic';
import languageI18n from '~/i18n/language';

const router = useRouter();
const route = useRoute();

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([clinicI18n, cityI18n, languageI18n]),
});

const { cityIds, languageIds, name, updateFromRoute, getRouteParams } =
	useFilters();

updateFromRoute(route.query);

const clinicsListRef = ref<HTMLElement>();
const clinicsMapRef = ref<HTMLElement>();
const PAGE_LIMIT = 20;
const pageNumber = ref(+route.query.page || 1);

const filterList = computed(() => ({
	cityIds: cityIds.value,
	languageIds: languageIds.value,
	name: name.value,
}));

const { pending: isLoadingClinics, data: clinicsList } = await useFetch(
	'/api/clinics/list',
	{
		key: 'clinics-list',
		method: 'POST',
		body: filterList,
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

const filteredClinics = computed(() => {
	let filtered = clinicsList.value?.clinics || [];

	// Filter by city
	if (cityIds.value.length > 0) {
		filtered = filtered.filter((clinic) =>
			cityIds.value.includes(clinic.cityId),
		);
	}

	// Filter by language
	if (languageIds.value.length > 0) {
		filtered = filtered.filter((clinic) => {
			const clinicLanguageIds = clinic.languageIds
				.split(',')
				.map((id) => parseInt(id));
			return languageIds.value.some((langId) =>
				clinicLanguageIds.includes(langId),
			);
		});
	}

	// Filter by name
	if (name.value) {
		const searchTerm = name.value.toLowerCase();
		filtered = filtered.filter((clinic) =>
			clinic.name.toLowerCase().includes(searchTerm),
		);
	}

	return filtered;
});

const clinicsOnPage = computed(() => {
	return filteredClinics.value.slice(
		(pageNumber.value - 1) * PAGE_LIMIT,
		pageNumber.value * PAGE_LIMIT,
	);
});

const showClinicOnMap = (clinic: ClinicData) => {
	clinicsMapRef.value.openClinicPopup(clinic);
};

const onMapReady = () => {
	watch(
		cityIds,
		() => {
			clinicsMapRef.value?.centerOnLocations(
				cityIds.value.map((cityId) => CITY_COORDINATES[cityId]),
			);
		},
		{ immediate: true },
	);
};

const pageTitle = computed(() => {
	if (languageIds.value.length === 1) {
		if (cityIds.value.length === 1) {
			return t('ClinicsLanguageCity', {
				language: t(`language_${languageIds.value[0]}_genitive`),
				city: t(`city_${cityIds.value[0]}_genitive`),
			});
		}
		return t('ClinicsLanguage', {
			language: t(`language_${languageIds.value[0]}_genitive`),
		});
	}

	if (cityIds.value.length === 1) {
		return t('ClinicsCity', {
			city: t(`city_${cityIds.value[0]}_genitive`),
		});
	}

	return t('Clinics');
});

const pageTitleWithCount = computed(() => {
	return `${pageTitle.value} (${filteredClinics.value.length})`;
});

const robotsMeta = computed(() => {
	if (filteredClinics.value.length === 0) {
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
		if (clinicsListRef.value) {
			clinicsListRef.value.scrollTo(0, 0);
		}
	});
});
</script>

<template>
	<div class="clinics-page">
		<div ref="clinicsListRef" class="clinics-sidebar">
			<h1 class="page-title">{{ pageTitleWithCount }}</h1>

			<div class="clinics-list-container">
				<div class="filters-sidebar">
					<FilterName />
					<FilterCitySelect v-model:value="cityIds" />
					<FilterLanguageSelect v-model:value="languageIds" />
				</div>

				<div class="clinics-list-content">
					<div v-if="isLoadingClinics" class="loading">
						<div class="loading-spinner"></div>
						<p>{{ t('LoadingClinics') }}</p>
					</div>

					<div v-else class="clinics-list">
						<div v-if="filteredClinics.length === 0" class="empty-state">
							<p>{{ t('NoClinicsFound') }}</p>
						</div>

						<ClinicSummary
							v-for="clinic in clinicsOnPage"
							:key="clinic.id"
							:clinic="clinic"
							@show-on-map="showClinicOnMap($event)"
						/>
					</div>

					<Pagination
						:total="filteredClinics.length"
						:page-size="PAGE_LIMIT"
						v-model:current-page="pageNumber"
					/>
				</div>
			</div>
		</div>

		<div class="map-container">
			<DoctorsMap
				ref="clinicsMapRef"
				:doctors="[]"
				:clinics="filteredClinics"
				@ready="onMapReady"
			/>
		</div>
	</div>
</template>

<style lang="less" scoped>
@import url('~/assets/css/vars.less');

.clinics-page {
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

.clinics-sidebar {
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

.clinics-list-container {
	display: flex;
	flex-direction: row;
	gap: var(--spacing-2xl);

	.clinics-list-content {
		flex: 1 1 auto;
	}
}

.clinics-list {
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

	.clinics-list-container {
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
	.clinics-page {
		height: auto;
		flex-wrap: wrap;
	}

	.map-container {
		max-height: 60vh;
		overflow: hidden;
	}
}

@media (max-width: 500px) {
	.clinics-sidebar {
		padding: var(--spacing-sm);
	}
}
</style>
