<script setup lang="ts">
import { LanguageId } from '~/enums/language';
import cityI18n from '~/i18n/city';
import doctorI18n from '~/i18n/doctor';
import languageI18n from '~/i18n/language';
import specialtyI18n from '~/i18n/specialty';
import { combineI18nMessages } from '~/i18n/utils';

const { t } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		doctorI18n,
		specialtyI18n,
		languageI18n,
		cityI18n,
	]),
});

const route = useRoute();

const { pending: isLoading, data: doctorData } = await useFetch(
	'/api/doctors/details',
	{
		key: 'doctor-details',
		method: 'POST',
		body: computed(() => ({
			doctorId: route.params.doctorId,
		})),
	},
);

const clinicsStore = useClinicsStore();
await clinicsStore.fetchClinics();

const isFound = computed(() => doctorData.value?.id != null);

const doctorClinics = computed(() => {
	if (!isFound.value || !clinicsStore.clinics) {
		return [];
	}

	return clinicsStore.clinics.filter((clinic) =>
		doctorData.value?.clinicIds.split(',').map(Number).includes(clinic.id),
	);
});

const pageTitle = computed(() => {
	if (!isFound.value) {
		return '';
	}

	const specialtiesText = doctorData.value?.specialtyIds
		?.split(',')
		.map((specialty) => t(`specialty_${specialty}`))
		.join(', ');

	const usedCities: { [key: string]: true } = {};
	const citiesText = doctorClinics.value
		.map((clinic) => {
			if (usedCities[clinic.cityId]) {
				return '';
			}
			usedCities[clinic.cityId] = true;
			return t(`city_${clinic.cityId}`);
		})
		.filter(Boolean)
		.join(', ');

	const titleParts = [doctorData.value?.name, specialtiesText, citiesText];
	return titleParts.filter(Boolean).join(' | ');
});

const pageDescription = computed(() => {
	if (!isFound.value || !doctorData.value || !doctorClinics.value) {
		return '';
	}

	const { specialtyIds, languageIds, professionalTitle, name } =
		doctorData.value;

	const specialtiesText = specialtyIds
		?.split(',')
		.map((specialty) => t(`doctor_${specialty}`).toLowerCase());

	const languagesText =
		languageIds === LanguageId.SR.toString()
			? null
			: joinWithAnd(
					languageIds
						.split(',')
						.map((language) => t(`language_${language}_prepositional`)),
			  );

	const usedCities: { [key: string]: true } = {};
	const citiesText = joinWithAnd(
		doctorClinics.value
			.map((clinic) => {
				if (usedCities[clinic.cityId]) {
					return '';
				}

				usedCities[clinic.cityId] = true;
				return t(`city_${clinic.cityId}_genitive`);
			})
			.filter(Boolean),
	);

	const visitText =
		citiesText && languagesText
			? t('VisitLanguageCity', {
					language: languagesText,
					city: citiesText,
			  })
			: citiesText
			? t('VisitCity', { city: citiesText })
			: languagesText
			? t('VisitLanguage', { language: languagesText })
			: t('Visit');

	const doctorName = (professionalTitle ? professionalTitle + ' ' : '') + name;

	return `${doctorName} — ${joinWithAnd(specialtiesText)}. ${visitText}`;
});

function joinWithAnd(items: string[]): string {
	if (items.length === 0) {
		return '';
	}

	if (items.length === 1) {
		return items[0];
	}

	return (
		items.slice(0, -1).join(', ') +
		' ' +
		t('And') +
		' ' +
		items[items.length - 1]
	);
}

useSeoMeta({
	title: pageTitle,
	description: pageDescription,
});
</script>

<template>
	<DetailsPage
		:isLoading="isLoading || clinicsStore.isLoadingClinics || false"
		:isFound="isFound"
		:clinics="doctorClinics"
		backRouteName="doctors"
		:loadingText="t('LoadingDoctor')"
		:notFoundText="t('DoctorNotFound')"
	>
		<template #info>
			<DoctorInfo v-if="doctorData" :service="doctorData" />
		</template>
	</DetailsPage>
</template>
