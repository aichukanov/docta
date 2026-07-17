<script setup lang="ts">
import type { ClinicServicesMap } from '#components';
import { OG_IMAGE, SITE_URL } from '~/common/constants';
import { getCanonicalUrl, getRegionalUrl } from '~/common/url-utils';
import {
	buildBreadcrumbsSchema,
	buildMedicalProcedureSchema,
} from '~/common/schema-org-builders';
import breadcrumbI18n from '~/i18n/breadcrumb';
import cityI18n from '~/i18n/city';
import medicalServiceI18n from '~/i18n/medical-service';
import medicalServiceCategoryI18n from '~/i18n/medical-service-category';
import medicalServiceTariffI18n from '~/i18n/medical-service-tariff';
import { combineI18nMessages } from '~/i18n/utils';
import type { ClinicData } from '~/interfaces/clinic';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		breadcrumbI18n,
		medicalServiceI18n,
		cityI18n,
		medicalServiceCategoryI18n,
		medicalServiceTariffI18n,
	]),
});

const route = useRoute();

const { pending: isLoading, data: medicalServiceData } = await useFetch(
	'/api/services/details',
	{
		key: 'service-details',
		method: 'POST',
		body: computed(() => ({
			slug: route.params.serviceSlug,
			locale: locale.value,
		})),
	},
);

const clinicsStore = useClinicsStore();
await clinicsStore.fetchClinics();

const isFound = computed(() => medicalServiceData.value?.id != null);

// Set HTTP 404 status for not found service
if (import.meta.server && !isFound.value) {
	setResponseStatus(useRequestEvent()!, 404);
}

const { trackEvent } = useAnalytics();

provideAnalyticsEntity(
	computed(() =>
		medicalServiceData.value?.id
			? {
					entity_type: 'service' as const,
					entity_id: medicalServiceData.value.id,
					entity_slug: route.params.serviceSlug as string,
				}
			: null,
	),
);

if (import.meta.client) {
	const trackServiceView = () => {
		const service = medicalServiceData.value;
		if (!service?.id) return;
		trackEvent('entity_viewed', {
			entity_type: 'service',
			entity_id: service.id,
			entity_slug: route.params.serviceSlug as string,
			entity_name: service.name,
			clinics_count: service.clinicIds
				? service.clinicIds.split(',').length
				: 0,
		});
	};
	// onMounted — первый показ; watch — клиентский переход услуга→услуга,
	// когда компонент страницы переиспользуется без remount
	onMounted(trackServiceView);
	watch(
		() => medicalServiceData.value?.id,
		(id, prevId) => {
			if (id && id !== prevId) trackServiceView();
		},
	);
}

// Композитная пересортировка (rank_score + близость + бонус за цену):
// до определения локации совпадает с серверным порядком — гидрация не прыгает
const { rankClinics } = useClinicRanking();
const allMedicalServiceClinics = computed(() =>
	isFound.value
		? rankClinics(
				clinicsStore.getClinicsByIds(medicalServiceData.value?.clinicIds),
				medicalServiceData.value?.clinicPrices,
			)
		: [],
);

const {
	cityIds,
	filteredClinics: medicalServiceClinics,
	filteredClinicPrices,
} = useClinicCityFilter(
	'services',
	allMedicalServiceClinics,
	computed(() => medicalServiceData.value?.clinicPrices),
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

const tariffs = computed(() => medicalServiceData.value?.tariffs ?? []);
const hasTariffs = computed(() => tariffs.value.length > 0);

// Табы — на полном наборе клиник: фильтр не должен прятать таб «Клиники».
const tabs = computed(() => {
	const result = [];
	if (allMedicalServiceClinics.value.length > 0) {
		result.push({ id: 'clinics', label: t('TabClinics') });
	}
	if (hasTariffs.value) {
		result.push({ id: 'fzocg-tariff', label: t('TabFzocgTariff') });
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
	const uniqueCities = medicalServiceClinics.value
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

	const categoryText = medicalServiceData.value?.categoryIds?.length
		? t(`medical_service_category_${medicalServiceData.value.categoryIds[0]}`)
		: '';

	return categoryText
		? `${medicalServiceData.value?.name} | ${categoryText} | ${locationText}`
		: `${medicalServiceData.value?.name} | ${locationText}`;
});

const pageDescription = computed(() => {
	if (
		!isFound.value ||
		!medicalServiceData.value ||
		!medicalServiceClinics.value
	) {
		return '';
	}

	const { name } = medicalServiceData.value;

	const usedCities: { [key: string]: true } = {};
	const citiesText = medicalServiceClinics.value
		.map((clinic) => {
			if (usedCities[clinic.cityId]) {
				return '';
			}

			usedCities[clinic.cityId] = true;
			return t(`city_${clinic.cityId}_genitive`);
		})
		.filter(Boolean)
		.join(', ');

	return citiesText
		? t('MedicalServiceDescriptionCity', { name, city: citiesText })
		: t('MedicalServiceDescriptionDefault', { name });
});

const heroTitle = computed(() => {
	const name = medicalServiceData.value?.name ?? '';
	if (cityIds.value.length !== 1) return name;
	return t('NameInCity', {
		name,
		city: t(`city_${cityIds.value[0]}_genitive`),
	});
});

// Schema.org for medical service details
const schemaOrgStore = useSchemaOrgStore();

const robotsMeta = computed(() => (isFound.value ? undefined : 'noindex'));

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
	if (medicalServiceData.value && isFound.value) {
		const pageUrl = getCanonicalUrl(
			route.path,
			route.query as Record<string, string | string[]>,
			locale.value,
		);

		schemaOrgStore.setSchemas([
			...buildMedicalProcedureSchema({
				siteUrl: SITE_URL,
				id: medicalServiceData.value.id,
				slug: medicalServiceData.value.slug,
				name: medicalServiceData.value.name,
				locale: locale.value,
				pageTitle: pageTitle.value,
				pageDescription: pageDescription.value,
				pageUrl,
				clinics: medicalServiceClinics.value,
				clinicPrices: filteredClinicPrices.value,
				getCityName,
			}),
			buildBreadcrumbsSchema(pageUrl, [
				{
					name: t('BreadcrumbHome'),
					url: getRegionalUrl(`${SITE_URL}/`, {}, locale.value),
				},
				{
					name: t('BreadcrumbServices'),
					url: getRegionalUrl(`${SITE_URL}/services`, {}, locale.value),
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
		backRouteName="services"
		:loadingText="t('LoadingMedicalServices')"
		:notFoundText="t('NoMedicalServicesFound')"
		:tabs="tabs"
	>
		<template #hero v-if="medicalServiceData">
			<div class="medical-service-hero">
				<h1 class="medical-service-name">{{ heroTitle }}</h1>
				<div
					v-if="medicalServiceData.localName"
					class="medical-service-local-name"
				>
					{{ medicalServiceData.localName }}
				</div>
				<div
					v-if="medicalServiceData.categoryIds?.length"
					class="medical-service-categories"
				>
					<CategoryTag
						v-for="categoryId in medicalServiceData.categoryIds"
						:key="categoryId"
					>
						{{ t(`medical_service_category_${categoryId}`) }}
					</CategoryTag>
				</div>
			</div>
		</template>

		<template #sections>
			<EntityPageClinicsSection
				v-if="allMedicalServiceClinics.length > 0"
				v-model:cityIds="cityIds"
				:allClinics="allMedicalServiceClinics"
				:clinics="medicalServiceClinics"
				:clinicPrices="medicalServiceData?.clinicPrices"
				:title="t('TabClinics')"
				@show-on-map="showClinicOnMap"
			/>

			<EntityPageSection
				v-if="hasTariffs"
				sectionId="fzocg-tariff"
				:title="t('TabFzocgTariff')"
				:count="tariffs.length"
			>
				<template #icon><IconClinic :size="20" /></template>
				<aside class="tariff-info">
					<strong class="tariff-info__lead">
						{{ t('TariffInfoLead') }}
					</strong>
					<p class="tariff-info__body">{{ t('TariffInfoBody') }}</p>
				</aside>
				<div class="tariff-cards">
					<MedicalServiceFzocgTariffCard
						v-for="tariffItem in tariffs"
						:key="tariffItem.id"
						:tariff="tariffItem"
					/>
				</div>
			</EntityPageSection>

			<EntityPageSection sectionId="map" :title="t('TabMap')">
				<template #icon><IconMapPin :size="20" color="#ffffff" /></template>
				<div ref="mapSentinel" class="service-map">
					<LazyClinicServicesMap
						v-if="isMapVisible"
						ref="mapRef"
						:services="[]"
						:clinics="medicalServiceClinics"
						:showAllClinics="true"
						@ready="onMapReady"
					/>
				</div>
			</EntityPageSection>
		</template>
	</EntityPage>
</template>

<style lang="less" scoped>
.medical-service-hero {
	padding: var(--spacing-xl) 0;
}

.medical-service-name {
	font-size: var(--font-size-4xl);
	font-weight: 700;
	color: var(--color-text-primary);
	margin: 0;
	font-family:
		system-ui,
		-apple-system,
		sans-serif;
	word-break: break-word;
	line-height: 1.2;
}

.medical-service-local-name {
	font-size: var(--font-size-md);
	color: var(--color-text-secondary);
	margin-top: var(--spacing-sm);
	font-style: italic;
	word-break: break-word;
}

.medical-service-categories {
	display: flex;
	flex-wrap: wrap;
	gap: var(--spacing-xs);
	margin-top: var(--spacing-md);
}

.tariff-cards {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
}

.tariff-info {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
	background: var(--color-primary-bg);
	border-left: 4px solid var(--color-primary);
	border-radius: var(--border-radius-lg);
	padding: var(--spacing-xl) var(--spacing-2xl);
	margin-bottom: var(--spacing-lg);
}

.tariff-info__lead {
	font-size: var(--font-size-2xl);
	font-weight: var(--font-weight-bold);
	color: var(--color-text-heading);
	line-height: 1.3;
}

.tariff-info__body {
	margin: 0;
	font-size: var(--font-size-md);
	color: var(--color-text-primary);
	line-height: 1.6;
}

.service-map {
	height: 400px;
	border-radius: var(--border-radius-md);
	overflow: hidden;
	border: 1px solid var(--color-border-light);
}
</style>
