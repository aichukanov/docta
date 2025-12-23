<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import { CITY_COORDINATES } from '~/enums/cities';
import type { ClinicData, ClinicPrice } from '~/interfaces/clinic';
import { LanguageId } from '~/enums/language';

interface ListItem {
	id: number;
	name?: string;
	originalName?: string;
	synonyms?: string[];
	clinicIds?: string;
	clinicPrices?: ClinicPrice[];
}

const props = defineProps<{
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
}>();

const { t, locale } = useI18n({ useScope: 'local' });

const router = useRouter();
const route = useRoute();

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

const showTipsSection = computed(() => {
	return listOnPage.value.length <= 5;
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
	description: props.pageDescription,
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
					<div
						v-if="isLoading || clinicsStore.isLoadingClinics"
						class="loading"
						role="status"
						aria-live="polite"
						:aria-label="t('AriaLoadingResults')"
					>
						<div class="loading-spinner" aria-hidden="true"></div>
						<p>{{ t('Loading') }}</p>
					</div>

					<div v-else class="list-wrapper">
						<div
							v-if="list.length === 0"
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
								v-for="item in listOnPage"
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
							</li>
						</ul>

						<TipsList v-if="showTipsSection">
							<slot name="tips" />
						</TipsList>
					</div>

					<nav :aria-label="t('AriaPagination')">
						<Pagination
							:total="totalCount"
							:page-size="PAGE_LIMIT"
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
		box-sizing: border-box;
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
