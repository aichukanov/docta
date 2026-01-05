<script setup lang="ts">
import breadcrumbI18n from '~/i18n/breadcrumb';
import cityI18n from '~/i18n/city';
import medicationI18n from '~/i18n/medication';
import { combineI18nMessages } from '~/i18n/utils';
import {
	buildDrugSchema,
	buildBreadcrumbsSchema,
} from '~/common/schema-org-builders';
import { SITE_URL } from '~/common/constants';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([breadcrumbI18n, medicationI18n, cityI18n]),
});

const route = useRoute();

const { pending: isLoading, data: medicationData } = await useFetch(
	'/api/medications/details',
	{
		key: 'medication-details',
		method: 'POST',
		body: computed(() => ({
			medicationId: route.params.medicationId,
		})),
	},
);

const clinicsStore = useClinicsStore();
await clinicsStore.fetchClinics(locale.value);

const isFound = computed(() => medicationData.value?.id != null);

// Set HTTP 404 status for not found medication
if (import.meta.server && !isFound.value) {
	setResponseStatus(useRequestEvent()!, 404);
}

const medicationClinics = computed(() =>
	isFound.value
		? clinicsStore.getClinicsByIds(medicationData.value?.clinicIds)
		: [],
);

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

	return `${medicationData.value?.name} | ${locationText}`;
});

const pageDescription = computed(() => {
	if (!isFound.value || !medicationData.value || !medicationClinics.value) {
		return '';
	}

	const { name } = medicationData.value;

	const usedCities: { [key: string]: true } = {};
	const citiesText = medicationClinics.value
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
		? t('MedicationDescriptionCity', { name, city: citiesText })
		: t('MedicationDescriptionDefault', { name });
});

// Schema.org for medication details
const schemaOrgStore = useSchemaOrgStore();

const ogImage = `${SITE_URL}/apple-touch-icon.png`;
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
	if (medicationData.value && isFound.value) {
		const medicationUrl = `${SITE_URL}/medications/${medicationData.value.id}`;

		schemaOrgStore.setSchemas([
			...buildDrugSchema({
				siteUrl: SITE_URL,
				id: medicationData.value.id,
				name: medicationData.value.name,
				locale: locale.value,
				pageTitle: pageTitle.value,
				pageDescription: pageDescription.value,
				clinics: medicationClinics.value,
				clinicPrices: medicationData.value.clinicPrices,
				getCityName,
			}),
			buildBreadcrumbsSchema(medicationUrl, [
				{ name: t('BreadcrumbHome'), url: `${SITE_URL}/` },
				{ name: t('BreadcrumbMedications'), url: `${SITE_URL}/medications` },
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
		:clinics="medicationClinics"
		:clinicPrices="medicationData?.clinicPrices"
		backRouteName="medications"
		:loadingText="t('LoadingMedications')"
		:notFoundText="t('NoMedicationsFound')"
	>
		<template #info v-if="medicationData">
			<div class="medication-header">
				<h1 class="medication-name">{{ medicationData.name }}</h1>
			</div>
		</template>
	</DetailsPage>
</template>

<style lang="less" scoped>
.medication-header {
	background: var(--color-surface-secondary);
	border: 1px solid var(--color-border-primary);
	border-radius: var(--border-radius-lg);
	padding: var(--spacing-xl) var(--spacing-2xl);
	box-shadow: var(--shadow-xs);

	.medication-name {
		font-size: 2rem;
		font-weight: 600;
		color: #1f2937;
		margin: 0;
		font-family: system-ui, -apple-system, sans-serif;
	}
}
</style>
