<script setup lang="ts">
import type { ClinicServicesMap } from '#components';
import { OG_IMAGE, SITE_URL } from '~/common/constants';
import { getCanonicalUrl, getRegionalUrl } from '~/common/url-utils';
import {
	buildBreadcrumbsSchema,
	buildMedicalTestSchema,
} from '~/common/schema-org-builders';
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
import breadcrumbI18n from '~/i18n/breadcrumb';
import cityI18n from '~/i18n/city';
import entityAutoFactsI18n from '~/i18n/entity-auto-facts';
import labTestI18n from '~/i18n/labtest';
import labTestCategoryI18n from '~/i18n/labtest-category';
import seoDescriptionI18n from '~/i18n/seo-description';
import { combineI18nMessages } from '~/i18n/utils';
import type { ClinicData } from '~/interfaces/clinic';

const { t, n, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		breadcrumbI18n,
		labTestI18n,
		cityI18n,
		labTestCategoryI18n,
		entityAutoFactsI18n,
		seoDescriptionI18n,
	]),
});

const route = useRoute();

const clinicsStore = useClinicsStore();

// Детали сущности и каталог клиник независимы — грузим параллельно, иначе на
// SSR получается лишний последовательный round-trip (см. pages/doctors/index.vue)
const [{ pending: isLoading, data: labTestData }] = await Promise.all([
	useFetch('/api/labtests/details', {
		key: 'labtest-details',
		method: 'POST',
		body: computed(() => ({
			slug: route.params.labTestSlug,
			locale: locale.value,
		})),
	}),
	clinicsStore.fetchClinics(),
]);

const isFound = computed(() => labTestData.value?.id != null);

// Set HTTP 404 status for not found lab test
if (import.meta.server && !isFound.value) {
	setResponseStatus(useRequestEvent()!, 404);
}

const { trackEvent } = useAnalytics();

provideAnalyticsEntity(
	computed(() =>
		labTestData.value?.id
			? {
					entity_type: 'labtest' as const,
					entity_id: labTestData.value.id,
					entity_slug: route.params.labTestSlug as string,
				}
			: null,
	),
);

if (import.meta.client) {
	const trackLabTestView = () => {
		const labTest = labTestData.value;
		if (!labTest?.id) return;
		trackEvent('entity_viewed', {
			entity_type: 'labtest',
			entity_id: labTest.id,
			entity_slug: route.params.labTestSlug as string,
			entity_name: labTest.name,
			clinics_count: labTest.clinicIds
				? labTest.clinicIds.split(',').length
				: 0,
		});
	};
	// onMounted — первый показ; watch — клиентский переход анализ→анализ,
	// когда компонент страницы переиспользуется без remount
	onMounted(trackLabTestView);
	watch(
		() => labTestData.value?.id,
		(id, prevId) => {
			if (id && id !== prevId) trackLabTestView();
		},
	);
}

// Композитная пересортировка (rank_score + близость + бонус за цену):
// до определения локации совпадает с серверным порядком — гидрация не прыгает
const { rankClinics } = useClinicRanking();
const allLabTestClinics = computed(() =>
	isFound.value
		? rankClinics(
				clinicsStore.getClinicsByIds(labTestData.value?.clinicIds),
				labTestData.value?.clinicPrices,
			)
		: [],
);

const {
	cityIds,
	hasInvalidCityFilter,
	filteredClinics: labTestClinics,
	filteredClinicPrices,
} = useClinicCityFilter(
	'labtests',
	allLabTestClinics,
	computed(() => labTestData.value?.clinicPrices),
);

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

// Авто-факты считаются по ОТФИЛЬТРОВАННОМУ списку — как заголовок и JSON-LD
// ниже: при фильтре по городу страница каноническая для этого города, и цифры
// обязаны совпадать с тем, что реально отрисовано.
const autoFacts = computed(() =>
	computeEntityAutoFacts(labTestClinics.value, filteredClinicPrices.value),
);

const formatPrice = (value: number) => n(value, priceFormatOptions(value));

// Табы — на полном наборе клиник: фильтр не должен прятать таб «Клиники».
const tabs = computed(() => {
	const result = [];
	if (labTestData.value?.referenceInfo) {
		result.push({ id: 'reference', label: t('TabReference') });
	}
	if (allLabTestClinics.value.length > 0) {
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
	const uniqueCities = labTestClinics.value
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

	const categoryText = labTestData.value?.categoryIds?.length
		? t(`lab_test_category_${labTestData.value.categoryIds[0]}_title`)
		: '';

	const name = labTestData.value?.name ?? '';

	// Порядок отбрасывания как на карточке услуги: сначала категория, город
	// остаётся до последнего.
	return fitSeoTitle([
		[name, categoryText, locationText].filter(Boolean).join(' | '),
		[name, locationText].filter(Boolean).join(' | '),
		name,
	]);
});

const pageDescription = computed(() => {
	if (!isFound.value || !labTestData.value || !labTestClinics.value) {
		return '';
	}

	const { name, localName } = labTestData.value;
	const displayName =
		localName && localName !== name ? `${name} (${localName})` : name;

	const usedCities: { [key: string]: true } = {};
	const cityNames = labTestClinics.value
		.map((clinic) => {
			if (usedCities[clinic.cityId]) {
				return '';
			}

			usedCities[clinic.cityId] = true;
			return t(`city_${clinic.cityId}_genitive`);
		})
		.filter(Boolean);

	// Как на карточке услуги: от пяти городов перечисление сворачивается, место
	// уходит вилке цен.
	const citiesText =
		cityNames.length > 0 && cityNames.length <= MAX_CITIES_IN_DESCRIPTION
			? cityNames.join(', ')
			: '';

	const intro = citiesText
		? t('LabTestDescriptionCity', { name: displayName, city: citiesText })
		: t('LabTestDescriptionDefault', { name: displayName });

	return buildSeoDescription([
		intro,
		buildSeoPriceSegment(autoFacts.value, t, formatPrice),
		t('SeoDescCtaCompare'),
	]);
});

const heroTitle = computed(() => {
	const name = labTestData.value?.name ?? '';
	if (cityIds.value.length !== 1) return name;
	return t('NameInCity', {
		name,
		city: t(`city_${cityIds.value[0]}_genitive`),
	});
});

// Schema.org for lab test details
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
	if (labTestData.value && isFound.value) {
		const pageUrl = getCanonicalUrl(
			route.path,
			route.query as Record<string, string | string[]>,
			locale.value,
		);

		schemaOrgStore.setSchemas([
			...buildMedicalTestSchema({
				siteUrl: SITE_URL,
				id: labTestData.value.id,
				slug: labTestData.value.slug,
				name: labTestData.value.name,
				localName: labTestData.value.localName,
				synonyms: labTestData.value.synonyms,
				locale: locale.value,
				pageTitle: pageTitle.value,
				pageDescription: pageDescription.value,
				pageUrl,
				clinics: labTestClinics.value,
				clinicPrices: filteredClinicPrices.value,
				getCityName,
			}),
			buildBreadcrumbsSchema(pageUrl, [
				{
					name: t('BreadcrumbHome'),
					url: getRegionalUrl(`${SITE_URL}/`, {}, locale.value),
				},
				{
					name: t('BreadcrumbLabTests'),
					url: getRegionalUrl(`${SITE_URL}/labtests`, {}, locale.value),
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
		backRouteName="labtests"
		:loadingText="t('LoadingLabTests')"
		:notFoundText="t('NoLabTestsFound')"
		:tabs="tabs"
	>
		<template #hero v-if="labTestData">
			<div class="lab-test-hero">
				<h1 class="lab-test-name">{{ heroTitle }}</h1>
				<div v-if="labTestData.localName" class="lab-test-original">
					{{ labTestData.localName }}
				</div>
				<div v-if="labTestData.synonyms?.length" class="lab-test-synonyms">
					<span class="synonyms-label">{{ t('Synonyms') }}:</span>
					<span class="synonyms-list">{{
						labTestData.synonyms.join(', ')
					}}</span>
				</div>
				<div v-if="labTestData.categoryIds?.length" class="lab-test-categories">
					<CategoryTag
						v-for="categoryId in labTestData.categoryIds"
						:key="categoryId"
					>
						{{ t(`lab_test_category_${categoryId}`) }}
					</CategoryTag>
				</div>
				<EntityPageAutoFacts v-if="autoFacts" :facts="autoFacts" />
			</div>
		</template>

		<template #sections>
			<EntityPageReferenceSection
				v-if="labTestData?.referenceInfo"
				sectionId="reference"
				:title="t('TabReference')"
				:referenceInfo="labTestData.referenceInfo"
			/>

			<EntityPageClinicsSection
				v-if="allLabTestClinics.length > 0"
				v-model:cityIds="cityIds"
				:allClinics="allLabTestClinics"
				:clinics="labTestClinics"
				:clinicPrices="labTestData?.clinicPrices"
				:title="t('TabClinics')"
				@show-on-map="showClinicOnMap"
			/>

			<EntityPageSection sectionId="map" :title="t('TabMap')">
				<template #icon
					><IconMapPin :size="20" color="var(--kit-color-text-on-solid)"
				/></template>
				<div ref="mapSentinel" class="labtest-map">
					<LazyClinicServicesMap
						v-if="isMapVisible"
						ref="mapRef"
						:services="[]"
						:clinics="labTestClinics"
						:showAllClinics="true"
						@ready="onMapReady"
					/>
				</div>
			</EntityPageSection>
		</template>
	</EntityPage>
</template>

<style lang="less" scoped>
.lab-test-hero {
	padding: var(--kit-spacing-xl) 0;
}

.lab-test-name {
	font-size: var(--kit-font-size-4xl);
	font-weight: 700;
	color: var(--kit-color-text-primary);
	margin: 0;
	font-family:
		system-ui,
		-apple-system,
		sans-serif;
	word-break: break-word;
	line-height: 1.2;
}

.lab-test-original {
	font-size: var(--kit-font-size-md);
	color: var(--kit-color-text-secondary);
	margin-top: var(--kit-spacing-sm);
	font-style: italic;
	word-break: break-word;
}

.lab-test-categories {
	display: flex;
	flex-wrap: wrap;
	gap: var(--kit-spacing-xs);
	margin-top: var(--kit-spacing-md);
}

.lab-test-synonyms {
	font-size: var(--kit-font-size-base);
	color: var(--kit-color-text-secondary);
	margin-top: var(--kit-spacing-md);

	.synonyms-label {
		color: var(--kit-color-text-muted);
		margin-right: var(--kit-spacing-xs);
	}
}

.labtest-map {
	height: 400px;
	border-radius: var(--kit-border-radius-md);
	overflow: hidden;
	border: 1px solid var(--kit-color-border-light);
}
</style>
