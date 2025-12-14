<script setup lang="ts">
import cityI18n from '~/i18n/city';
import medicationI18n from '~/i18n/medication';
import { combineI18nMessages } from '~/i18n/utils';

const { t } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([medicationI18n, cityI18n]),
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
await clinicsStore.fetchClinics();

const isFound = computed(() => medicationData.value?.id != null);

const medicationClinics = computed(() => {
	if (!isFound.value || !clinicsStore.clinics) {
		return [];
	}

	return clinicsStore.clinics.filter((clinic) =>
		medicationData.value?.clinicIds.split(',').map(Number).includes(clinic.id),
	);
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

useSeoMeta({
	title: pageTitle,
	description: pageDescription,
});

const { setMedicationSchema } = useSchemaOrg();
watchEffect(() => {
	if (medicationData.value && isFound.value) {
		setMedicationSchema({
			id: medicationData.value.id,
			name: medicationData.value.name,
			clinics: medicationClinics.value.map((clinic) => ({ name: clinic.name })),
		});
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
