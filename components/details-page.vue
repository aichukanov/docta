<script setup lang="ts">
import { ArrowLeft } from '@element-plus/icons-vue';
import { getRegionalQuery } from '~/common/url-utils';
import { useFiltersStore, type FilterNamespace } from '~/stores/filters';
import type { ClinicData, ClinicPrice } from '~/interfaces/clinic';

const props = withDefaults(
	defineProps<{
		isLoading: boolean;
		isFound: boolean;
		backRouteName: FilterNamespace;
		loadingText: string;
		notFoundText: string;
		clinics: ClinicData[];
		clinicPrices?: ClinicPrice[];
		showPrice?: boolean;
	}>(),
	{
		showPrice: true,
	},
);

const getPriceInfo = (clinicId: number) => {
	return props.clinicPrices?.find((p) => p.clinicId === clinicId);
};

const { t, locale } = useI18n();
const router = useRouter();
const filtersStore = useFiltersStore();

const mapRef = ref<
	HTMLElement & {
		centerOnClinics: (
			clinics: Array<{ latitude: number; longitude: number }>,
		) => void;
		centerOnLocations: (locations: Array<[number, number]>) => void;
	}
>();
const { target: mapSentinel, hasBeenVisible: isMapVisible } = useInViewport();
const pendingMapAction = ref<(() => void) | null>(null);

const showClinicOnMap = (clinic: ClinicData) => {
	const action = () => mapRef.value?.centerOnClinics([clinic]);
	if (mapRef.value) {
		action();
	} else {
		pendingMapAction.value = action;
		isMapVisible.value = true;
	}
};

const backToSearch = () => {
	router.push({
		name: props.backRouteName,
		query: {
			...filtersStore.getRouteParams(props.backRouteName).query,
			...getRegionalQuery(locale.value),
		},
	});
};

const onMapReady = () => {
	if (pendingMapAction.value) {
		pendingMapAction.value();
		pendingMapAction.value = null;
	}
	if (props.clinics.length > 0) {
		mapRef.value?.centerOnLocations(
			props.clinics.map((clinic) => [clinic.latitude, clinic.longitude]),
		);
	}
};
</script>

<template>
	<div class="details-page" role="main" :aria-label="t('AriaMainContent')">
		<nav class="details-page-header" :aria-label="t('AriaBackToSearch')">
			<el-button @click="backToSearch()" :icon="ArrowLeft">
				{{ t('ToSearchPage') }}
			</el-button>
		</nav>
		<div class="details-page-content" :aria-busy="isLoading">
			<div
				v-if="isLoading"
				class="details-skeleton"
				role="status"
				aria-live="polite"
				:aria-label="t('AriaLoading')"
			>
				<SkeletonCard :rows="4" />
				<SkeletonCard :rows="2" :show-media="false" />
				<SkeletonCard :rows="2" :show-media="false" />
			</div>
			<div v-else-if="isFound" class="details-info-container">
				<article
					class="details-info-wrapper"
					:aria-label="t('AriaDetailsContent')"
				>
					<slot name="info" :showClinicOnMap="showClinicOnMap" />
					<slot name="clinics" :showClinicOnMap="showClinicOnMap">
						<section
							class="clinics-list"
							role="list"
							:aria-label="t('AriaClinicsSection')"
						>
							<ClinicSummary
								v-for="clinic in props.clinics"
								:key="clinic.id"
								:clinic="clinic"
								:priceInfo="getPriceInfo(clinic.id)"
								:showPrice="showPrice"
								@show-on-map="showClinicOnMap(clinic)"
								role="listitem"
							/>
						</section>
					</slot>
					<slot name="reviews" />
				</article>
				<aside
					ref="mapSentinel"
					class="map-container"
					:aria-label="t('AriaMapSection')"
				>
					<ClinicServicesMap
						v-if="isMapVisible"
						ref="mapRef"
						:services="[]"
						:clinics="props.clinics"
						:showAllClinics="true"
						@ready="onMapReady"
					/>
				</aside>
			</div>
			<div
				v-else
				class="details-info-container"
				role="status"
				aria-live="polite"
			>
				<p>{{ notFoundText }}</p>
			</div>
		</div>
	</div>
</template>

<style lang="less" scoped>
.details-page {
	padding: var(--spacing-md);

	.details-page-header {
		margin-bottom: var(--spacing-md);
	}

	.details-page-content {
		display: flex;
		gap: var(--spacing-2xl);
		justify-content: center;

		.details-info-container {
			display: flex;
			flex-direction: row;
			align-items: flex-start;
			gap: var(--spacing-2xl);
			width: 100%;
			max-width: 1600px;

			.details-info-wrapper {
				flex: 1;
				display: flex;
				flex-direction: column;
				gap: var(--spacing-2xl);
				min-width: 0;
			}

			.map-container {
				flex: 1;
				position: sticky;
				top: calc(60px + var(--spacing-lg));
				height: calc(100vh - 60px - var(--spacing-lg) - var(--spacing-md));
				min-height: 400px;
				max-height: 700px;
			}
		}
	}
}

.clinics-list {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
}

.details-skeleton {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
	width: 100%;
	max-width: 800px;
}

@media (max-width: 650px) {
	.details-page {
		.details-page-content {
			.details-info-container {
				flex-direction: column;

				.details-info-wrapper {
					width: 100%;
				}
			}

			.map-container {
				width: 100%;
			}
		}
	}
}
</style>

<i18n lang="json">
{
	"en": {
		"ToSearchPage": "Back to search",
		"AriaMainContent": "Main content",
		"AriaBackToSearch": "Back to search results",
		"AriaLoading": "Loading",
		"AriaDetailsContent": "Detailed information",
		"AriaClinicsSection": "Available at clinics",
		"AriaMapSection": "Map with locations"
	},
	"ru": {
		"ToSearchPage": "К поиску",
		"AriaMainContent": "Основное содержимое",
		"AriaBackToSearch": "Вернуться к результатам поиска",
		"AriaLoading": "Загрузка",
		"AriaDetailsContent": "Подробная информация",
		"AriaClinicsSection": "Доступно в клиниках",
		"AriaMapSection": "Карта с расположениями"
	},
	"de": {
		"ToSearchPage": "Zurück zur Suche",
		"AriaMainContent": "Hauptinhalt",
		"AriaBackToSearch": "Zurück zu den Suchergebnissen",
		"AriaLoading": "Laden",
		"AriaDetailsContent": "Detaillierte Informationen",
		"AriaClinicsSection": "Verfügbar in Kliniken",
		"AriaMapSection": "Karte mit Standorten"
	},
	"tr": {
		"ToSearchPage": "Aramaya geri dön",
		"AriaMainContent": "Ana içerik",
		"AriaBackToSearch": "Arama sonuçlarına dön",
		"AriaLoading": "Yükleniyor",
		"AriaDetailsContent": "Detaylı bilgiler",
		"AriaClinicsSection": "Kliniklerde mevcut",
		"AriaMapSection": "Konumlu harita"
	},
	"sr": {
		"ToSearchPage": "Nazad na pretragu",
		"AriaMainContent": "Glavni sadržaj",
		"AriaBackToSearch": "Nazad na rezultate pretrage",
		"AriaLoading": "Učitavanje",
		"AriaDetailsContent": "Detaljne informacije",
		"AriaClinicsSection": "Dostupno u klinikama",
		"AriaMapSection": "Mapa sa lokacijama"
	},
	"sr-cyrl": {
		"ToSearchPage": "Назад на претрагу",
		"AriaMainContent": "Главни садржај",
		"AriaBackToSearch": "Назад на резултате претраге",
		"AriaLoading": "Учитавање",
		"AriaDetailsContent": "Детаљне информације",
		"AriaClinicsSection": "Доступно у клиникама",
		"AriaMapSection": "Мапа са локацијама"
	}
}
</i18n>
