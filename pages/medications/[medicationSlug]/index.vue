<script setup lang="ts">
import type { ClinicServicesMap } from '#components';
import { OG_IMAGE, SITE_URL } from '~/common/constants';
import {
	computeEntityAutoFacts,
	priceFormatOptions,
} from '~/common/entity-auto-facts';
import {
	buildSeoDescription,
	buildSeoPriceSegment,
	fitSeoTitle,
	MAX_CITIES_IN_DESCRIPTION,
} from '~/common/seo-meta';
import { getCanonicalUrl, getRegionalUrl } from '~/common/url-utils';
import {
	buildBreadcrumbsSchema,
	buildDrugSchema,
} from '~/common/schema-org-builders';
import breadcrumbI18n from '~/i18n/breadcrumb';
import cityI18n from '~/i18n/city';
import medicationI18n from '~/i18n/medication';
import seoDescriptionI18n from '~/i18n/seo-description';
import { combineI18nMessages } from '~/i18n/utils';
import type { ClinicData } from '~/interfaces/clinic';

const { t, n, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		breadcrumbI18n,
		medicationI18n,
		cityI18n,
		seoDescriptionI18n,
	]),
});

const route = useRoute();

const clinicsStore = useClinicsStore();

// Детали сущности и каталог клиник независимы — грузим параллельно, иначе на
// SSR получается лишний последовательный round-trip (см. pages/doctors/index.vue)
const [{ pending: isLoading, data: medicationData }] = await Promise.all([
	useFetch('/api/medications/details', {
		key: 'medication-details',
		method: 'POST',
		body: computed(() => ({
			slug: route.params.medicationSlug,
			locale: locale.value,
		})),
	}),
	clinicsStore.fetchClinics(),
]);

const isFound = computed(() => medicationData.value?.id != null);

// Set HTTP 404 status for not found medication
if (import.meta.server && !isFound.value) {
	setResponseStatus(useRequestEvent()!, 404);
}

const { trackEvent } = useAnalytics();

provideAnalyticsEntity(
	computed(() =>
		medicationData.value?.id
			? {
					entity_type: 'medication' as const,
					entity_id: medicationData.value.id,
					entity_slug: route.params.medicationSlug as string,
				}
			: null,
	),
);

if (import.meta.client) {
	const trackMedicationView = () => {
		const medication = medicationData.value;
		if (!medication?.id) return;
		trackEvent('entity_viewed', {
			entity_type: 'medication',
			entity_id: medication.id,
			entity_slug: route.params.medicationSlug as string,
			entity_name: medication.name,
			clinics_count: medication.clinicIds
				? medication.clinicIds.split(',').length
				: 0,
		});
	};
	// onMounted — первый показ; watch — клиентский переход между лекарствами,
	// когда компонент страницы переиспользуется без remount
	onMounted(trackMedicationView);
	watch(
		() => medicationData.value?.id,
		(id, prevId) => {
			if (id && id !== prevId) trackMedicationView();
		},
	);
}

// Композитная пересортировка (rank_score + близость + бонус за цену):
// до определения локации совпадает с серверным порядком — гидрация не прыгает
const { rankClinics } = useClinicRanking();
const allMedicationClinics = computed(() =>
	isFound.value
		? rankClinics(
				clinicsStore.getClinicsByIds(medicationData.value?.clinicIds),
				medicationData.value?.clinicPrices,
			)
		: [],
);

const {
	cityIds,
	hasInvalidCityFilter,
	filteredClinics: medicationClinics,
	filteredClinicPrices,
} = useClinicCityFilter(
	'medications',
	allMedicationClinics,
	computed(() => medicationData.value?.clinicPrices),
);

// Авто-факты — по отфильтрованному списку клиник, как на карточках услуг и
// анализов: при фильтре по городу цифры обязаны совпадать с отрисованным.
const autoFacts = computed(() =>
	computeEntityAutoFacts(medicationClinics.value, filteredClinicPrices.value),
);

const formatPrice = (value: number) => n(value, priceFormatOptions(value));

const mapRef = ref<InstanceType<typeof ClinicServicesMap> | null>(null);
const { target: mapSentinel, hasBeenVisible: isMapVisible } = useInViewport();
const pendingMapAction = ref<(() => void) | null>(null);

const onMapReady = () => {
	if (pendingMapAction.value) {
		pendingMapAction.value();
		pendingMapAction.value = null;
	}
};

const showClinicOnMap = (clinic: ClinicData) => {
	const el = document.getElementById('map');
	if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' });
	const action = () => mapRef.value?.openClinicPopup(clinic);
	if (mapRef.value) {
		action();
	} else {
		pendingMapAction.value = action;
		isMapVisible.value = true;
	}
};

// Табы — на полном наборе клиник: фильтр не должен прятать таб «Клиники».
const tabs = computed(() => {
	const result = [];
	if (allMedicationClinics.value.length > 0) {
		result.push({ id: 'clinics', label: t('TabClinics') });
	}
	result.push({ id: 'map', label: t('TabMap') });
	return result;
});

// Заголовок, описание и JSON-LD — на отфильтрованном списке. cityIds сидит
// в URL, поэтому каждый город — отдельная каноническая страница со своим SEO.
const pageTitle = computed(() => {
	if (!isFound.value) {
		return '';
	}

	const usedCities: { [key: string]: true } = {};
	const uniqueCities = medicationClinics.value
		.map((clinic) => {
			if (usedCities[clinic.cityId]) {
				return null;
			}
			usedCities[clinic.cityId] = true;
			return clinic.cityId;
		})
		.filter(Boolean);

	const locationText =
		uniqueCities.length === 1
			? t(`city_${uniqueCities[0]}`)
			: t('InMontenegro');

	const name = medicationData.value?.name ?? '';

	return fitSeoTitle([[name, locationText].filter(Boolean).join(' | '), name]);
});

const pageDescription = computed(() => {
	if (!isFound.value || !medicationData.value || !medicationClinics.value) {
		return '';
	}

	const { name } = medicationData.value;

	const usedCities: { [key: string]: true } = {};
	const cityNames = medicationClinics.value
		.map((clinic) => {
			if (usedCities[clinic.cityId]) {
				return '';
			}

			usedCities[clinic.cityId] = true;
			return t(`city_${clinic.cityId}_genitive`);
		})
		.filter(Boolean);

	// Как на карточках услуг и анализов: длинный перечень городов уступает место
	// вилке цен.
	const citiesText =
		cityNames.length > 0 && cityNames.length <= MAX_CITIES_IN_DESCRIPTION
			? cityNames.join(', ')
			: '';

	const intro = citiesText
		? t('MedicationDescriptionCity', { name, city: citiesText })
		: t('MedicationDescriptionDefault', { name });

	return buildSeoDescription([
		intro,
		buildSeoPriceSegment(autoFacts.value, t, formatPrice),
		t('SeoDescCtaCompare'),
	]);
});

const heroTitle = computed(() => {
	const name = medicationData.value?.name ?? '';
	if (cityIds.value.length !== 1) return name;
	return t('NameInCity', {
		name,
		city: t(`city_${cityIds.value[0]}_genitive`),
	});
});

// Schema.org for medication details
const schemaOrgStore = useSchemaOrgStore();

// Невалидный `?cityIds=` в URL: страница отдаёт полный список с 200 и
// self-canonical на мусорный URL, поэтому уходит в noindex (follow — ссылки
// со страницы честные). Тот же приём, что у листингов в list-page.vue.
const robotsMeta = computed(() => {
	if (!isFound.value) return 'noindex';
	return hasInvalidCityFilter.value ? 'noindex, follow' : undefined;
});

useSeoMeta({
	title: pageTitle,
	description: pageDescription,
	ogTitle: pageTitle,
	ogDescription: pageDescription,
	ogImage: OG_IMAGE,
	ogType: 'article',
	twitterCard: 'summary',
	twitterTitle: pageTitle,
	twitterDescription: pageDescription,
	twitterImage: OG_IMAGE,
	robots: robotsMeta,
});

const getCityName = (id: number): string | undefined => {
	const key = `city_${id}`;
	const value = t(key);
	return value && value !== key ? value : undefined;
};

watchEffect(() => {
	if (medicationData.value && isFound.value) {
		const pageUrl = getCanonicalUrl(
			route.path,
			route.query as Record<string, string | string[]>,
			locale.value,
		);

		schemaOrgStore.setSchemas([
			...buildDrugSchema({
				siteUrl: SITE_URL,
				id: medicationData.value.id,
				slug: medicationData.value.slug,
				name: medicationData.value.name,
				locale: locale.value,
				pageTitle: pageTitle.value,
				pageDescription: pageDescription.value,
				pageUrl,
				clinics: medicationClinics.value,
				clinicPrices: filteredClinicPrices.value,
				getCityName,
			}),
			buildBreadcrumbsSchema(pageUrl, [
				{
					name: t('BreadcrumbHome'),
					url: getRegionalUrl(`${SITE_URL}/`, {}, locale.value),
				},
				{
					name: t('BreadcrumbMedications'),
					url: getRegionalUrl(`${SITE_URL}/medications`, {}, locale.value),
				},
				{ name: pageTitle.value },
			]),
		]);
	}
});
</script>

<template>
	<EntityPage
		:isLoading="isLoading || clinicsStore.isLoading || false"
		:isFound="isFound"
		backRouteName="medications"
		:loadingText="t('LoadingMedications')"
		:notFoundText="t('NoMedicationsFound')"
		:tabs="tabs"
	>
		<template #hero v-if="medicationData">
			<div class="medication-hero">
				<h1 class="medication-name">{{ heroTitle }}</h1>
				<div v-if="medicationData.localName" class="medication-local-name">
					{{ medicationData.localName }}
				</div>
			</div>
		</template>

		<template #sections>
			<EntityPageClinicsSection
				v-if="allMedicationClinics.length > 0"
				v-model:cityIds="cityIds"
				:allClinics="allMedicationClinics"
				:clinics="medicationClinics"
				:clinicPrices="medicationData?.clinicPrices"
				:title="t('TabClinics')"
				@show-on-map="showClinicOnMap"
			/>

			<EntityPageSection sectionId="map" :title="t('TabMap')">
				<template #icon><IconMapPin :size="20" color="#ffffff" /></template>
				<div ref="mapSentinel" class="medication-map">
					<LazyClinicServicesMap
						v-if="isMapVisible"
						ref="mapRef"
						:services="[]"
						:clinics="medicationClinics"
						:showAllClinics="true"
						@ready="onMapReady"
					/>
				</div>
			</EntityPageSection>
		</template>
	</EntityPage>
</template>

<style lang="less" scoped>
.medication-hero {
	padding: var(--kit-spacing-xl) 0;
}

.medication-name {
	font-size: var(--kit-font-size-4xl);
	font-weight: 700;
	color: var(--kit-color-text-primary);
	margin: 0;
	font-family:
		system-ui,
		-apple-system,
		sans-serif;
	line-height: 1.2;
}

.medication-local-name {
	font-size: var(--kit-font-size-md);
	font-weight: var(--kit-font-weight-medium);
	color: var(--kit-color-text-secondary);
	margin-top: var(--kit-spacing-xs);
}

.medication-map {
	height: 400px;
	border-radius: var(--kit-border-radius-md);
	overflow: hidden;
	border: 1px solid var(--kit-color-border-light);
}
</style>
