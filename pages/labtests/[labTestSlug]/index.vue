<script setup lang="ts">
import { OG_IMAGE, SITE_URL } from '~/common/constants';
import {
	buildBreadcrumbsSchema,
	buildMedicalTestSchema,
} from '~/common/schema-org-builders';
import breadcrumbI18n from '~/i18n/breadcrumb';
import cityI18n from '~/i18n/city';
import labTestI18n from '~/i18n/labtest';
import labTestCategoryI18n from '~/i18n/labtest-category';
import { combineI18nMessages } from '~/i18n/utils';
import type { ClinicData } from '~/interfaces/clinic';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		breadcrumbI18n,
		labTestI18n,
		cityI18n,
		labTestCategoryI18n,
	]),
});

const route = useRoute();

const { pending: isLoading, data: labTestData } = await useFetch(
	'/api/labtests/details',
	{
		key: 'labtest-details',
		method: 'POST',
		body: computed(() => ({
			slug: route.params.labTestSlug,
			locale: locale.value,
		})),
	},
);

const clinicsStore = useClinicsStore();
await clinicsStore.fetchClinics();

const isFound = computed(() => labTestData.value?.id != null);

// Set HTTP 404 status for not found lab test
if (import.meta.server && !isFound.value) {
	setResponseStatus(useRequestEvent()!, 404);
}

const allLabTestClinics = computed(() =>
	isFound.value
		? clinicsStore.getClinicsByIds(labTestData.value?.clinicIds)
		: [],
);

const {
	cityIds,
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

// Табы — на полном наборе клиник: фильтр не должен прятать таб «Клиники».
const tabs = computed(() => {
	const result = [];
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

	return categoryText
		? `${labTestData.value?.name} | ${categoryText} | ${locationText}`
		: `${labTestData.value?.name} | ${locationText}`;
});

const pageDescription = computed(() => {
	if (!isFound.value || !labTestData.value || !labTestClinics.value) {
		return '';
	}

	const { name, localName } = labTestData.value;
	const displayName =
		localName && localName !== name ? `${name} (${localName})` : name;

	const usedCities: { [key: string]: true } = {};
	const citiesText = labTestClinics.value
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
		? t('LabTestDescriptionCity', { name: displayName, city: citiesText })
		: t('LabTestDescriptionDefault', { name: displayName });
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
	if (labTestData.value && isFound.value) {
		const testUrl = `${SITE_URL}/labtests/${labTestData.value.slug}`;

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
				clinics: labTestClinics.value,
				clinicPrices: filteredClinicPrices.value,
				getCityName,
			}),
			buildBreadcrumbsSchema(testUrl, [
				{ name: t('BreadcrumbHome'), url: `${SITE_URL}/` },
				{ name: t('BreadcrumbLabTests'), url: `${SITE_URL}/labtests` },
				{ name: pageTitle.value },
			]),
		]);
	}
});
</script>

<template>
	<EntityPage
		:isLoading="isLoading || clinicsStore.isLoadingClinics || false"
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
			</div>
		</template>

		<template #sections>
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
				<template #icon><IconMapPin :size="20" color="#ffffff" /></template>
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
	padding: var(--spacing-xl) 0;
}

.lab-test-name {
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

.lab-test-original {
	font-size: var(--font-size-md);
	color: var(--color-text-secondary);
	margin-top: var(--spacing-sm);
	font-style: italic;
	word-break: break-word;
}

.lab-test-categories {
	display: flex;
	flex-wrap: wrap;
	gap: var(--spacing-xs);
	margin-top: var(--spacing-md);
}

.lab-test-synonyms {
	font-size: var(--font-size-base);
	color: var(--color-text-secondary);
	margin-top: var(--spacing-md);

	.synonyms-label {
		color: var(--color-text-muted);
		margin-right: var(--spacing-xs);
	}
}

.labtest-map {
	height: 400px;
	border-radius: var(--border-radius-md);
	overflow: hidden;
	border: 1px solid var(--color-border-light);
}
</style>
