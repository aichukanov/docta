<script setup lang="ts">
import breadcrumbI18n from '~/i18n/breadcrumb';
import cityI18n from '~/i18n/city';
import medicalServiceI18n from '~/i18n/medical-service';
import { combineI18nMessages } from '~/i18n/utils';
import {
	buildMedicalProcedureSchema,
	buildBreadcrumbsSchema,
} from '~/common/schema-org-builders';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([breadcrumbI18n, medicalServiceI18n, cityI18n]),
});

const route = useRoute();

const { pending: isLoading, data: medicalServiceData } = await useFetch(
	'/api/services/details',
	{
		key: 'service-details',
		method: 'POST',
		body: computed(() => ({
			serviceId: route.params.serviceId,
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

const medicalServiceClinics = computed(() => {
	if (!isFound.value || !clinicsStore.clinics) {
		return [];
	}

	return clinicsStore.clinics.filter((clinic) =>
		medicalServiceData.value?.clinicIds
			.split(',')
			.map(Number)
			.includes(clinic.id),
	);
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

	return `${medicalServiceData.value?.name} | ${locationText}`;
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
const runtimeConfig = useRuntimeConfig();

const ogImage = `${runtimeConfig.public.siteUrl}/logo-site.png`;
const robotsMeta = computed(() => (isFound.value ? undefined : 'noindex'));

useSeoMeta({
	title: pageTitle,
	description: pageDescription,
	ogTitle: pageTitle,
	ogDescription: pageDescription,
	ogImage: ogImage,
	ogType: 'article',
	twitterCard: 'summary',
	twitterTitle: pageTitle,
	twitterDescription: pageDescription,
	twitterImage: ogImage,
	robots: robotsMeta,
});

const getCityName = (id: number): string | undefined => {
	const key = `city_${id}`;
	const value = t(key);
	return value && value !== key ? value : undefined;
};

watchEffect(() => {
	if (medicalServiceData.value && isFound.value) {
		const siteUrl = runtimeConfig.public.siteUrl;
		const serviceUrl = `${siteUrl}/services/${medicalServiceData.value.id}`;

		schemaOrgStore.setSchemas([
			...buildMedicalProcedureSchema({
				siteUrl,
				id: medicalServiceData.value.id,
				name: medicalServiceData.value.name,
				locale: locale.value,
				pageTitle: pageTitle.value,
				pageDescription: pageDescription.value,
				clinics: medicalServiceClinics.value,
				getCityName,
			}),
			buildBreadcrumbsSchema(serviceUrl, [
				{ name: t('BreadcrumbHome'), url: `${siteUrl}/` },
				{ name: t('BreadcrumbServices'), url: `${siteUrl}/services` },
				{ name: pageTitle.value },
			]),
		]);
	}
});
</script>

<template>
	<DetailsPage
		:isLoading="isLoading || clinicsStore.isLoadingClinics || false"
		:isFound="isFound"
		:clinics="medicalServiceClinics"
		:clinicPrices="medicalServiceData?.clinicPrices"
		backRouteName="services"
		:loadingText="t('LoadingMedicalServices')"
		:notFoundText="t('NoMedicalServicesFound')"
	>
		<template #info v-if="medicalServiceData">
			<div class="medical-service-header">
				<h1 class="medical-service-name">{{ medicalServiceData.name }}</h1>
			</div>
		</template>
	</DetailsPage>
</template>

<style lang="less" scoped>
.medical-service-header {
	background: var(--color-surface-secondary);
	border: 1px solid var(--color-border-primary);
	border-radius: var(--border-radius-lg);
	padding: var(--spacing-xl) var(--spacing-2xl);
	box-shadow: var(--shadow-xs);

	.medical-service-name {
		font-size: 2rem;
		font-weight: 600;
		color: #1f2937;
		margin: 0;
		font-family: system-ui, -apple-system, sans-serif;
	}
}
</style>
