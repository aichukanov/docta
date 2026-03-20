<script setup lang="ts">
import { OG_IMAGE, SITE_URL } from '~/common/constants';
import {
	buildBreadcrumbsSchema,
	buildMedicalProcedureSchema,
} from '~/common/schema-org-builders';
import breadcrumbI18n from '~/i18n/breadcrumb';
import cityI18n from '~/i18n/city';
import medicalServiceI18n from '~/i18n/medical-service';
import medicalServiceCategoryI18n from '~/i18n/medical-service-category';
import { combineI18nMessages } from '~/i18n/utils';
import type { ClinicData } from '~/interfaces/clinic';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		breadcrumbI18n,
		medicalServiceI18n,
		cityI18n,
		medicalServiceCategoryI18n,
	]),
});

const route = useRoute();

const { pending: isLoading, data: medicalServiceData } = await useFetch(
	'/api/services/details',
	{
		key: 'service-details',
		method: 'POST',
		body: computed(() => ({
			serviceId: route.params.serviceId,
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

const medicalServiceClinics = computed(() =>
	isFound.value
		? clinicsStore.getClinicsByIds(medicalServiceData.value?.clinicIds)
		: [],
);

const getPriceInfo = (clinicId: number) => {
	return medicalServiceData.value?.clinicPrices?.find(
		(p) => p.clinicId === clinicId,
	);
};

const mapRef = ref<InstanceType<typeof ClinicServicesMap> | null>(null);

const showClinicOnMap = (clinic: ClinicData) => {
	const el = document.getElementById('map');
	if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' });
	mapRef.value?.openClinicPopup(clinic);
};

const tabs = computed(() => {
	const result = [];
	if (medicalServiceClinics.value.length > 0) {
		result.push({ id: 'clinics', label: t('TabClinics') });
	}
	result.push({ id: 'map', label: t('TabMap') });
	return result;
});

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
		const serviceUrl = `${SITE_URL}/services/${medicalServiceData.value.id}`;

		schemaOrgStore.setSchemas([
			...buildMedicalProcedureSchema({
				siteUrl: SITE_URL,
				id: medicalServiceData.value.id,
				name: medicalServiceData.value.name,
				locale: locale.value,
				pageTitle: pageTitle.value,
				pageDescription: pageDescription.value,
				clinics: medicalServiceClinics.value,
				clinicPrices: medicalServiceData.value.clinicPrices,
				getCityName,
			}),
			buildBreadcrumbsSchema(serviceUrl, [
				{ name: t('BreadcrumbHome'), url: `${SITE_URL}/` },
				{ name: t('BreadcrumbServices'), url: `${SITE_URL}/services` },
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
		backRouteName="services"
		:loadingText="t('LoadingMedicalServices')"
		:notFoundText="t('NoMedicalServicesFound')"
		:tabs="tabs"
	>
		<template #hero v-if="medicalServiceData">
			<div class="medical-service-hero">
				<h1 class="medical-service-name">{{ medicalServiceData.name }}</h1>
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
					<span
						v-for="categoryId in medicalServiceData.categoryIds"
						:key="categoryId"
						class="category-tag"
					>
						{{ t(`medical_service_category_${categoryId}`) }}
					</span>
				</div>
			</div>
		</template>

		<template #sections>
			<EntityPageSection
				v-if="medicalServiceClinics.length > 0"
				sectionId="clinics"
				:title="t('TabClinics')"
				:count="medicalServiceClinics.length"
			>
				<template #icon><IconClinic :size="20" /></template>
				<div class="clinics-list">
					<ClinicSummary
						v-for="clinic in medicalServiceClinics"
						:key="clinic.id"
						:clinic="clinic"
						:priceInfo="getPriceInfo(clinic.id)"
						:showPrice="true"
						@show-on-map="showClinicOnMap(clinic)"
					/>
				</div>
			</EntityPageSection>

			<EntityPageSection sectionId="map" :title="t('TabMap')">
				<template #icon><IconMapPin :size="20" color="#ffffff" /></template>
				<div class="service-map">
					<ClinicServicesMap
						ref="mapRef"
						:services="[]"
						:clinics="medicalServiceClinics"
						:showAllClinics="true"
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
	font-size: 1.75rem;
	font-weight: 700;
	color: var(--color-text-primary);
	margin: 0;
	font-family: system-ui, -apple-system, sans-serif;
	word-break: break-word;
	line-height: 1.2;
}

.medical-service-local-name {
	font-size: 1.1rem;
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

	.category-tag {
		display: inline-block;
		font-size: 0.85rem;
		color: var(--color-primary);
		background: rgba(79, 70, 229, 0.08);
		padding: 4px 12px;
		border-radius: 4px;
		border: 1px solid rgba(79, 70, 229, 0.15);
	}
}

.clinics-list {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
}

.service-map {
	height: 400px;
	border-radius: var(--border-radius-md);
	overflow: hidden;
	border: 1px solid var(--color-border-light);
}
</style>
