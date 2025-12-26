<script setup lang="ts">
import { ArrowLeft } from '@element-plus/icons-vue';
import { getRegionalQuery } from '~/common/url-utils';
import type { ClinicData, ClinicPrice } from '~/interfaces/clinic';

const props = defineProps<{
	isLoading: boolean;
	isFound: boolean;
	backRouteName: string;
	loadingText: string;
	notFoundText: string;
	clinics: ClinicData[];
	clinicPrices?: ClinicPrice[];
}>();

const getPriceInfo = (clinicId: number) =>
	props.clinicPrices?.find((p) => p.clinicId === clinicId);

const sortedClinics = computed(() => {
	if (!props.clinicPrices || props.clinicPrices.length === 0) {
		return props.clinics;
	}

	return [...props.clinics].sort((a, b) => {
		const priceA = getPriceInfo(a.id)?.price;
		const priceB = getPriceInfo(b.id)?.price;

		const hasPriceA = priceA !== undefined && priceA !== null && priceA !== 0;
		const hasPriceB = priceB !== undefined && priceB !== null && priceB !== 0;

		if (!hasPriceA && !hasPriceB) return 0;
		if (!hasPriceA) return 1;
		if (!hasPriceB) return -1;

		return (priceA as number) - (priceB as number);
	});
});

const { t, locale } = useI18n({ useScope: 'local' });
const router = useRouter();
const { getRouteParams } = useFilters();

const mapRef = ref<
	HTMLElement & {
		centerOnClinics: (
			clinics: Array<{ latitude: number; longitude: number }>,
		) => void;
	}
>();

const showClinicOnMap = (clinic: ClinicData) => {
	mapRef.value?.centerOnClinics([clinic]);
};

const backToSearch = () => {
	router.push({
		name: props.backRouteName,
		query: { ...getRouteParams().query, ...getRegionalQuery(locale.value) },
	});
};

const onMapReady = () => {
	if (sortedClinics.value.length > 0) {
		mapRef.value?.centerOnClinics(sortedClinics.value);
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
				class="loading"
				role="status"
				aria-live="polite"
				:aria-label="t('AriaLoading')"
			>
				<div class="loading-spinner" aria-hidden="true"></div>
				<p>{{ loadingText }}</p>
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
								v-for="clinic in sortedClinics"
								:key="clinic.id"
								:clinic="clinic"
								:priceInfo="getPriceInfo(clinic.id)"
								linkable
								@show-on-map="showClinicOnMap(clinic)"
								role="listitem"
							/>
						</section>
					</slot>
				</article>
				<aside class="map-container" :aria-label="t('AriaMapSection')">
					<ClinicServicesMap
						ref="mapRef"
						:services="[]"
						:clinics="sortedClinics"
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
@import url('~/assets/css/vars.less');

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
	}
}
</i18n>
