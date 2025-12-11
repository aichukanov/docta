<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import { CITY_COORDINATES } from '~/enums/cities';
import type { ClinicData, ClinicPrice } from '~/interfaces/clinic';
import { LanguageId } from '~/enums/language';

interface ListItem {
	id: number;
	name?: string;
	clinicIds?: string;
	clinicPrices?: ClinicPrice[];
}

const props = defineProps<{
	list: ListItem[];
	totalCount: number;
	isLoading: boolean;
	pageTitle: string;
	filterQuery: Record<string, any>;
	cityIds: number[];
	mapClinics?: ClinicData[];
	detailsRouteName?: string;
	detailsParamName?: string;
}>();

const { t, locale } = useI18n({ useScope: 'local' });

const router = useRouter();
const route = useRoute();

const listRef = ref<HTMLElement>();
const mapRef = ref<HTMLElement>();
const PAGE_LIMIT = 20;
const pageNumber = ref(+route.query.page || 1);

const clinicsStore = useClinicsStore();

const routeWithParams = computed(() => {
	return {
		query: {
			page: pageNumber.value > 1 ? pageNumber.value : undefined,
			...props.filterQuery,
			...getRegionalQuery(locale.value),
		},
	};
});

const listOnPage = computed(() => {
	return props.list.slice(
		(pageNumber.value - 1) * PAGE_LIMIT,
		pageNumber.value * PAGE_LIMIT,
	);
});

const showClinicOnMap = (clinic: ClinicData) => {
	mapRef.value.openClinicPopup(clinic);
};

const onMapReady = () => {
	watch(
		() => props.cityIds,
		() => {
			mapRef.value?.centerOnLocations(
				props.cityIds.map((cityId) => CITY_COORDINATES[cityId]),
			);
		},
		{ immediate: true },
	);
};

const robotsMeta = computed(() => {
	if (props.list?.length === 0) {
		return 'noindex, follow';
	}

	return undefined;
});

await clinicsStore.fetchClinics();

useSeoMeta({
	title: props.pageTitle,
	robots: robotsMeta,
});

onMounted(async () => {
	await nextTick();
	router.replace(routeWithParams.value);

	watch(
		() => props.filterQuery,
		() => {
			pageNumber.value = 1;

			router.replace(routeWithParams.value);
		},
	);

	watch(pageNumber, () => {
		router.replace(routeWithParams.value);

		window.scrollTo(0, 0);
		if (listRef.value) {
			listRef.value.scrollTo(0, 0);
		}
	});
});
</script>

<template>
	<div class="list-page">
		<div ref="listRef" class="list-sidebar">
			<h1 class="page-title">{{ pageTitle }}</h1>

			<div class="list-container">
				<div class="filters-sidebar">
					<slot name="filters" />
				</div>

				<div class="list-content">
					<div
						v-if="isLoading || clinicsStore.isLoadingClinics"
						class="loading"
					>
						<!-- todo: skeleton -->
						<div class="loading-spinner"></div>
						<p>{{ t('Loading') }}</p>
					</div>

					<div v-else class="list-wrapper">
						<div v-if="list.length === 0" class="empty-state">
							<p>{{ t('NotFound') }}</p>
							<!-- todo: empty state -->
						</div>

						<template v-for="item in listOnPage" :key="item.id">
							<slot name="card" :item="item" :showClinicOnMap="showClinicOnMap">
								<ListCard
									:title="item.name"
									:itemId="item.id"
									:clinicIds="item.clinicIds"
									:clinicPrices="item.clinicPrices"
									:detailsRouteName="detailsRouteName"
									:detailsParamName="detailsParamName"
									@show-on-map="showClinicOnMap($event)"
								>
									<slot name="item" :item="item" />
								</ListCard>
							</slot>
						</template>
					</div>

					<Pagination
						:total="totalCount"
						:page-size="PAGE_LIMIT"
						v-model:current-page="pageNumber"
					/>
				</div>
			</div>
		</div>

		<div class="map-container">
			<ClinicServicesMap
				ref="mapRef"
				:services="mapClinics ? [] : list"
				:clinics="mapClinics || clinicsStore.clinics"
				@ready="onMapReady"
			>
				<template #map-clinic-popup>
					<slot name="map-clinic-popup" />
				</template>
			</ClinicServicesMap>
		</div>
	</div>
</template>

<style lang="less" scoped>
@import url('~/assets/css/vars.less');

.list-page {
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

.list-sidebar {
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

.list-container {
	display: flex;
	flex-direction: row;
	gap: var(--spacing-2xl);

	.list-content {
		flex: 1 1 auto;
	}
}

.list-wrapper {
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

	.list-container {
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
	.list-page {
		height: auto;
		flex-wrap: wrap;
	}

	.map-container {
		max-height: 60vh;
		overflow: hidden;
	}
}

@media (max-width: 500px) {
	.list-sidebar {
		padding: var(--spacing-sm);
	}
}
</style>

<i18n lang="json">
{
	"en": {
		"Loading": "Loading...",
		"NotFound": "No results found"
	},
	"ru": {
		"Loading": "Загрузка...",
		"NotFound": "Результаты не найдены"
	},
	"sr": {
		"Loading": "Učitavanje...",
		"NotFound": "Rezultati nisu pronađeni"
	},
	"de": {
		"Loading": "Laden...",
		"NotFound": "Keine Ergebnisse gefunden"
	},
	"tr": {
		"Loading": "Yükleniyor...",
		"NotFound": "Sonuç bulunamadı"
	}
}
</i18n>
