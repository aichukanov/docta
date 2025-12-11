<script setup lang="ts">
import cityI18n from '~/i18n/city';
import labTestI18n from '~/i18n/lab-test';
import { combineI18nMessages } from '~/i18n/utils';

const { t } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([labTestI18n, cityI18n]),
});

const route = useRoute();

const { pending: isLoading, data: labTestData } = await useFetch(
	'/api/lab-tests/details',
	{
		key: 'lab-test-details',
		method: 'POST',
		body: computed(() => ({
			labTestId: route.params.labTestId,
		})),
	},
);

const clinicsStore = useClinicsStore();
await clinicsStore.fetchClinics();

const isFound = computed(() => labTestData.value?.id != null);

const labTestClinics = computed(() => {
	if (!isFound.value || !clinicsStore.clinics) {
		return [];
	}

	return clinicsStore.clinics.filter((clinic) =>
		labTestData.value?.clinicIds.split(',').map(Number).includes(clinic.id),
	);
});

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

	return `${labTestData.value?.name} | ${locationText}`;
});

const pageDescription = computed(() => {
	if (!isFound.value || !labTestData.value || !labTestClinics.value) {
		return '';
	}

	const { name } = labTestData.value;

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
		? t('LabTestDescriptionCity', { name, city: citiesText })
		: t('LabTestDescriptionDefault', { name });
});

useSeoMeta({
	title: pageTitle,
	description: pageDescription,
});
</script>

<template>
	<DetailsPage
		:isLoading="isLoading || clinicsStore.isLoadingClinics || false"
		:isFound="isFound"
		:clinics="labTestClinics"
		:clinicPrices="labTestData?.clinicPrices"
		backRouteName="lab-tests"
		:loadingText="t('LoadingLabTests')"
		:notFoundText="t('NoLabTestsFound')"
	>
		<template #info v-if="labTestData">
			<div class="lab-test-header">
				<h1 class="lab-test-name">{{ labTestData.name }}</h1>
			</div>
		</template>
	</DetailsPage>
</template>

<style lang="less" scoped>
.lab-test-header {
	background: var(--color-surface-secondary);
	border: 1px solid var(--color-border-primary);
	border-radius: var(--border-radius-lg);
	padding: var(--spacing-xl) var(--spacing-2xl);
	box-shadow: var(--shadow-xs);

	.lab-test-name {
		font-size: 2rem;
		font-weight: 600;
		color: #1f2937;
		margin: 0;
		font-family: system-ui, -apple-system, sans-serif;
	}
}
</style>
