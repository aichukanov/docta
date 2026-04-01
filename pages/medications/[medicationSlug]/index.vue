<script setup lang="ts">
import { OG_IMAGE, SITE_URL } from '~/common/constants';
import {
	buildBreadcrumbsSchema,
	buildDrugSchema,
} from '~/common/schema-org-builders';
import breadcrumbI18n from '~/i18n/breadcrumb';
import cityI18n from '~/i18n/city';
import medicationI18n from '~/i18n/medication';
import { combineI18nMessages } from '~/i18n/utils';
import type { ClinicData } from '~/interfaces/clinic';

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
			slug: route.params.medicationSlug,
			locale: locale.value,
		})),
	},
);

const clinicsStore = useClinicsStore();
await clinicsStore.fetchClinics();

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

const getPriceInfo = (clinicId: number) => {
	return medicationData.value?.clinicPrices?.find(
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
	if (medicationClinics.value.length > 0) {
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
	if (medicationData.value && isFound.value) {
		const medicationUrl = `${SITE_URL}/medications/${medicationData.value.slug}`;

		schemaOrgStore.setSchemas([
			...buildDrugSchema({
				siteUrl: SITE_URL,
				id: medicationData.value.id,
				slug: medicationData.value.slug,
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
	<EntityPage
		:isLoading="isLoading || clinicsStore.isLoadingClinics || false"
		:isFound="isFound"
		backRouteName="medications"
		:loadingText="t('LoadingMedications')"
		:notFoundText="t('NoMedicationsFound')"
		:tabs="tabs"
	>
		<template #hero v-if="medicationData">
			<div class="medication-hero">
				<h1 class="medication-name">{{ medicationData.name }}</h1>
				<div v-if="medicationData.localName" class="medication-local-name">
					{{ medicationData.localName }}
				</div>
			</div>
		</template>

		<template #sections>
			<EntityPageSection
				v-if="medicationClinics.length > 0"
				sectionId="clinics"
				:title="t('TabClinics')"
				:count="medicationClinics.length"
			>
				<template #icon><IconClinic :size="20" /></template>
				<div class="clinics-list">
					<ClinicSummary
						v-for="clinic in medicationClinics"
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
				<div class="medication-map">
					<ClinicServicesMap
						ref="mapRef"
						:services="[]"
						:clinics="medicationClinics"
						:showAllClinics="true"
					/>
				</div>
			</EntityPageSection>
		</template>
	</EntityPage>
</template>

<style lang="less" scoped>
.medication-hero {
	padding: var(--spacing-xl) 0;
}

.medication-name {
	font-size: 1.75rem;
	font-weight: 700;
	color: var(--color-text-primary);
	margin: 0;
	font-family: system-ui, -apple-system, sans-serif;
	line-height: 1.2;
}

.medication-local-name {
	font-size: var(--font-size-md);
	font-weight: var(--font-weight-medium);
	color: var(--color-text-secondary);
	margin-top: var(--spacing-xs);
}

.clinics-list {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
}

.medication-map {
	height: 400px;
	border-radius: var(--border-radius-md);
	overflow: hidden;
	border: 1px solid var(--color-border-light);
}
</style>
