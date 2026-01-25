<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import { CITY_COORDINATES } from '~/enums/cities';
import { LIST_PAGE_SIZE } from '~/common/constants';
import type { ClinicData, ClinicPrice } from '~/interfaces/clinic';
import { LanguageId } from '~/enums/language';

interface ClinicServiceItem {
	id: number;
	name: string;
	localName: string;
	price: number | null;
}

interface ClinicServicesMap {
	[clinicId: number]: ClinicServiceItem[];
}

interface ListItem {
	id: number;
	name?: string;
	localName?: string;
	synonyms?: string[];
	clinicIds?: string;
	clinicPrices?: ClinicPrice[];
	clinicServices?: ClinicServicesMap;
}

const props = withDefaults(
	defineProps<{
		list: ListItem[];
		totalCount: number;
		isLoading: boolean;
		pageTitle: string;
		pageDescription?: string;
		filterQuery: Record<string, any>;
		cityIds: number[];
		mapClinics?: ClinicData[];
		detailsRouteName?: string;
		detailsParamName?: string;
		showPrice?: boolean;
	}>(),
	{
		showPrice: true,
	},
);

const { t, locale } = useI18n({ useScope: 'local' });

const router = useRouter();
const route = useRoute();

const mapRef = ref<HTMLElement>();
const pageNumber = ref(+route.query.page || 1);
const isSyncingFromRoute = ref(false);

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


const normalizeQuery = (query: Record<string, any>) => {
	const normalized: Record<string, string | string[]> = {};
	Object.keys(query)
		.sort()
		.forEach((key) => {
			const value = query[key];
			if (value == null || value === '') {
				return;
			}
			if (Array.isArray(value)) {
				normalized[key] = value.map(String);
			} else {
				normalized[key] = String(value);
			}
		});
	return JSON.stringify(normalized);
};

const syncRoute = async (replace = false) => {
	const target = routeWithParams.value;
	if (normalizeQuery(route.query) === normalizeQuery(target.query)) {
		return;
	}
	if (replace) {
		await router.replace(target);
		return;
	}
	await router.push(target);
};

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
	description: props.pageDescription,
	robots: robotsMeta,
});

watch(
	() => route.query,
	(query) => {
		isSyncingFromRoute.value = true;
		pageNumber.value = +query.page || 1;
		nextTick(() => {
			isSyncingFromRoute.value = false;
		});
	},
	{ immediate: true },
);

onMounted(async () => {
	await nextTick();
	await syncRoute(true);

	watch(
		() => props.filterQuery,
		() => {
			if (isSyncingFromRoute.value) {
				return;
			}
			pageNumber.value = 1;

			syncRoute();
		},
	);

	watch(pageNumber, () => {
		if (isSyncingFromRoute.value) {
			return;
		}
		syncRoute();

		window.scrollTo(0, 0);
	});
});
</script>

<template>
	<div class="list-page" role="main" :aria-label="t('AriaMainContent')">
		<div class="list-sidebar">
			<h1 class="page-title">{{ pageTitle }}</h1>

			<div class="list-container">
				<aside
					class="filters-sidebar"
					role="search"
					:aria-label="t('AriaSearchFilters')"
				>
					<slot name="filters" />
				</aside>

				<section
					class="list-content"
					:aria-label="t('AriaSearchResults')"
					:aria-busy="isLoading || clinicsStore.isLoadingClinics"
				>
					<div class="list-wrapper">
						<div
							v-if="list.length === 0 && !isLoading"
							class="empty-state"
							role="status"
							aria-live="polite"
						>
							<p>{{ t('NotFound') }}</p>
						</div>

						<ul
							v-else
							class="results-list"
							role="list"
							:aria-label="t('AriaResultsList')"
						>
							<li
								v-for="item in list"
								:key="item.id"
								role="listitem"
								class="results-list-item"
							>
								<slot
									name="card"
									:item="item"
									:showClinicOnMap="showClinicOnMap"
								>
									<ListCard
										:title="item.name"
										:localName="item.localName"
										:itemId="item.id"
										:clinicIds="item.clinicIds"
										:clinicPrices="item.clinicPrices"
										:detailsRouteName="detailsRouteName"
										:detailsParamName="detailsParamName"
										:clinicServices="item.clinicServices"
										:showPrice="showPrice"
										@show-on-map="showClinicOnMap($event)"
									>
										<slot name="item" :item="item" />
									</ListCard>
								</slot>
							</li>
						</ul>

						<slot name="tips" />
					</div>

					<div
						v-if="isLoading || clinicsStore.isLoadingClinics"
						class="loading-overlay"
						role="status"
						aria-live="polite"
						:aria-label="t('AriaLoadingResults')"
					>
						<div class="loading-bar" aria-hidden="true"></div>
					</div>

					<nav :aria-label="t('AriaPagination')">
						<Pagination
							:total="totalCount"
							:page-size="LIST_PAGE_SIZE"
							v-model:current-page="pageNumber"
						/>
					</nav>
				</section>
			</div>
		</div>

		<aside class="map-container" :aria-label="t('AriaMapSection')">
			<ClinicServicesMap
				ref="mapRef"
				:services="mapClinics ? [] : list"
				:clinics="mapClinics || clinicsStore.clinics"
				:showAllClinics="!!mapClinics"
				:detailsRouteName="detailsRouteName"
				:detailsParamName="detailsParamName"
				@ready="onMapReady"
			>
				<template #map-clinic-popup="slotProps">
					<slot name="map-clinic-popup" v-bind="slotProps" />
				</template>
			</ClinicServicesMap>
		</aside>
	</div>
</template>

<style lang="less" scoped>
@import url('~/assets/css/vars.less');

.list-page {
	display: flex;
	min-height: calc(100vh - 120px);
	gap: 0;
	width: 100%;
	box-sizing: border-box;
}

.filters-sidebar {
	display: flex;
	box-sizing: border-box;
	flex-direction: column;
	flex: 0 0 280px;
	width: 280px;
	background: #ffffff;
	gap: var(--spacing-lg);
	position: sticky;
	top: calc(60px + var(--spacing-lg));
	align-self: flex-start;
	max-height: calc(100vh - 60px - 2 * var(--spacing-lg));
	overflow-y: auto;
}

.list-sidebar {
	flex: 1 1 60%;
	min-width: 0;
	box-sizing: border-box;
	background: #ffffff;
	border-right: 1px solid rgba(0, 0, 0, 0.06);
	padding: var(--spacing-lg);
}

.page-title {
	font-size: 2rem;
	font-weight: 600;
	color: #1f2937;
	margin: 0 0 @double-padding 0;
	font-family: system-ui, -apple-system, sans-serif;
	word-wrap: break-word;
}

.list-container {
	display: flex;
	flex-direction: row;
	gap: var(--spacing-2xl);
	width: 100%;
	box-sizing: border-box;

	.list-content {
		flex: 1 1 auto;
		min-width: 0;
		min-height: 400px;
		box-sizing: border-box;
		position: relative;
	}
}

.list-wrapper {
	display: flex;
	flex-direction: column;
	gap: @base-padding;
	width: 100%;
	box-sizing: border-box;
}

.results-list {
	list-style: none;
	padding: 0;
	margin: 0;
	display: flex;
	flex-direction: column;
	gap: @base-padding;
	width: 100%;
	box-sizing: border-box;
}

.results-list-item {
	display: block;
	width: 100%;
	box-sizing: border-box;
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

.loading-overlay {
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background: rgba(255, 255, 255, 0.4);
	pointer-events: none;
}

.loading-bar {
	height: 3px;
	width: 100%;
	background: linear-gradient(
		90deg,
		var(--color-primary) 0%,
		var(--color-primary-light, #a5b4fc) 50%,
		var(--color-primary) 100%
	);
	animation: loading-slide 0.8s linear infinite;
}

@keyframes loading-slide {
	0% {
		transform: translateX(-40%);
	}
	100% {
		transform: translateX(40%);
	}
}

.map-container {
	flex: 1 1 40%;
	min-width: 0;
	box-sizing: border-box;
	position: sticky;
	top: 60px;
	height: calc(100vh - 60px);
	align-self: flex-start;
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
			max-height: none;
			overflow-y: visible;
			gap: var(--spacing-sm);
		}
	}
}

@media (max-width: 950px) {
	.list-page {
		flex-direction: column;
	}

	.list-sidebar {
		flex: none;
		width: 100%;
		border-right: none;
	}

	.map-container {
		flex: none;
		width: 100%;
		position: static;
		height: 450px;
		margin-bottom: var(--spacing-2xl);
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
		"NotFound": "No results found",
		"AriaMainContent": "Main content",
		"AriaSearchFilters": "Search filters",
		"AriaSearchResults": "Search results",
		"AriaResultsList": "List of results",
		"AriaLoadingResults": "Loading results",
		"AriaPagination": "Results pagination",
		"AriaMapSection": "Map with locations"
	},
	"ru": {
		"Loading": "Загрузка...",
		"NotFound": "Результаты не найдены",
		"AriaMainContent": "Основное содержимое",
		"AriaSearchFilters": "Фильтры поиска",
		"AriaSearchResults": "Результаты поиска",
		"AriaResultsList": "Список результатов",
		"AriaLoadingResults": "Загрузка результатов",
		"AriaPagination": "Постраничная навигация",
		"AriaMapSection": "Карта с расположениями"
	},
	"sr": {
		"Loading": "Učitavanje...",
		"NotFound": "Rezultati nisu pronađeni",
		"AriaMainContent": "Glavni sadržaj",
		"AriaSearchFilters": "Filteri pretrage",
		"AriaSearchResults": "Rezultati pretrage",
		"AriaResultsList": "Lista rezultata",
		"AriaLoadingResults": "Učitavanje rezultata",
		"AriaPagination": "Navigacija po stranicama",
		"AriaMapSection": "Mapa sa lokacijama"
	},
	"sr-cyrl": {
		"Loading": "Учитавање...",
		"NotFound": "Резултати нису пронађени",
		"AriaMainContent": "Главни садржај",
		"AriaSearchFilters": "Филтери претраге",
		"AriaSearchResults": "Резултати претраге",
		"AriaResultsList": "Листа резултата",
		"AriaLoadingResults": "Учитавање резултата",
		"AriaPagination": "Навигација по страницама",
		"AriaMapSection": "Мапа са локацијама"
	},
	"de": {
		"Loading": "Laden...",
		"NotFound": "Keine Ergebnisse gefunden",
		"AriaMainContent": "Hauptinhalt",
		"AriaSearchFilters": "Suchfilter",
		"AriaSearchResults": "Suchergebnisse",
		"AriaResultsList": "Ergebnisliste",
		"AriaLoadingResults": "Ergebnisse werden geladen",
		"AriaPagination": "Seitennavigation",
		"AriaMapSection": "Karte mit Standorten"
	},
	"tr": {
		"Loading": "Yükleniyor...",
		"NotFound": "Sonuç bulunamadı",
		"AriaMainContent": "Ana içerik",
		"AriaSearchFilters": "Arama filtreleri",
		"AriaSearchResults": "Arama sonuçları",
		"AriaResultsList": "Sonuç listesi",
		"AriaLoadingResults": "Sonuçlar yükleniyor",
		"AriaPagination": "Sayfa navigasyonu",
		"AriaMapSection": "Konumlu harita"
	}
}
</i18n>
