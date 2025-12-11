<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import { CITY_COORDINATES } from '~/enums/cities';
import { combineI18nMessages } from '~/i18n/utils';
import type { ClinicData } from '~/interfaces/clinic';

import cityI18n from '~/i18n/city';
import doctorI18n from '~/i18n/doctor';
import languageI18n from '~/i18n/language';
import specialtyI18n from '~/i18n/specialty';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		doctorI18n,
		specialtyI18n,
		cityI18n,
		languageI18n,
	]),
});

const {
	specialtyIds,
	cityIds,
	languageIds,
	clinicIds,
	name,
	updateFromRoute,
	getRouteParams,
} = useFilters();

updateFromRoute(useRoute().query);

const filterList = computed(() => ({
	specialtyIds: specialtyIds.value,
	cityIds: cityIds.value,
	languageIds: languageIds.value,
	clinicIds: clinicIds.value,
	name: name.value,
}));

const filterQuery = computed(() => getRouteParams().query);

const clinicsStore = useClinicsStore();
await clinicsStore.fetchClinics();

const clinicName = computed(() => {
	if (clinicIds.value.length === 1) {
		const clinic = clinicsStore.clinics.find(
			(c) => c.id === clinicIds.value[0],
		);
		return clinic?.name || '';
	}
	return '';
});

const { pending: isLoadingDoctors, data: doctorsList } = await useFetch(
	'/api/doctors/list',
	{
		key: 'doctors-list',
		method: 'POST',
		body: filterList,
	},
);

const pageTitle = computed(() => {
	if (languageIds.value.length === 1) {
		if (specialtyIds.value.length === 1) {
			if (cityIds.value.length === 1) {
				if (clinicIds.value.length === 1) {
					return t('DoctorsLanguageSpecialtyCityClinic', {
						language: t(`language_${languageIds.value[0]}_genitive`),
						specialtyDoctors: t(`doctors_${specialtyIds.value[0]}`),
						city: t(`city_${cityIds.value[0]}_genitive`),
						clinic: clinicName.value,
					});
				}
				return t('DoctorsLanguageSpecialtyCity', {
					language: t(`language_${languageIds.value[0]}_genitive`),
					specialtyDoctors: t(`doctors_${specialtyIds.value[0]}`),
					city: t(`city_${cityIds.value[0]}_genitive`),
				});
			} else {
				if (clinicIds.value.length === 1) {
					return t('DoctorsLanguageSpecialtyClinic', {
						language: t(`language_${languageIds.value[0]}_genitive`),
						specialtyDoctors: t(`doctors_${specialtyIds.value[0]}`),
						clinic: clinicName.value,
					});
				}
				return t('DoctorsLanguageSpecialty', {
					language: t(`language_${languageIds.value[0]}_genitive`),
					specialtyDoctors: t(`doctors_${specialtyIds.value[0]}`),
				});
			}
		} else {
			if (cityIds.value.length === 1) {
				if (clinicIds.value.length === 1) {
					return t('DoctorsLanguageCityClinic', {
						language: t(`language_${languageIds.value[0]}_genitive`),
						city: t(`city_${cityIds.value[0]}_genitive`),
						clinic: clinicName.value,
					});
				}
				return t('DoctorsLanguageCity', {
					language: t(`language_${languageIds.value[0]}_genitive`),
					city: t(`city_${cityIds.value[0]}_genitive`),
				});
			} else {
				if (clinicIds.value.length === 1) {
					return t('DoctorsLanguageClinic', {
						language: t(`language_${languageIds.value[0]}_genitive`),
						clinic: clinicName.value,
					});
				}
				return t('DoctorsLanguage', {
					language: t(`language_${languageIds.value[0]}_genitive`),
				});
			}
		}
	} else {
		if (specialtyIds.value.length === 1) {
			if (cityIds.value.length === 1) {
				if (clinicIds.value.length === 1) {
					return t('DoctorsSpecialtyCityClinic', {
						specialtyDoctors: t(`doctors_${specialtyIds.value[0]}`),
						city: t(`city_${cityIds.value[0]}_genitive`),
						clinic: clinicName.value,
					});
				}
				return t('DoctorsSpecialtyCity', {
					specialtyDoctors: t(`doctors_${specialtyIds.value[0]}`),
					city: t(`city_${cityIds.value[0]}_genitive`),
				});
			}

			if (clinicIds.value.length === 1) {
				return t('DoctorsSpecialtyClinic', {
					specialtyDoctors: t(`doctors_${specialtyIds.value[0]}`),
					clinic: clinicName.value,
				});
			}
			return t('DoctorsSpecialty', {
				specialtyDoctors: t(`doctors_${specialtyIds.value[0]}`),
			});
		} else {
			if (cityIds.value.length === 1) {
				if (clinicIds.value.length === 1) {
					return t('DoctorsCityClinic', {
						city: t(`city_${cityIds.value[0]}_genitive`),
						clinic: clinicName.value,
					});
				}
				return t('DoctorsCity', {
					city: t(`city_${cityIds.value[0]}_genitive`),
				});
			}
		}
	}

	if (clinicIds.value.length === 1) {
		return t('DoctorsClinic', {
			clinic: clinicName.value,
		});
	}

	return t('Doctors');
});

const pageTitleWithCount = computed(() => {
	return `${pageTitle.value} (${doctorsList.value?.totalCount})`;
});

const pageDescription = computed(() => {
	if (cityIds.value.length === 1) {
		return t('DoctorsListDescriptionCity', {
			city: t(`city_${cityIds.value[0]}_genitive`),
		});
	}
	return t('DoctorsListDescription');
});
</script>

<template>
	<ListPage
		:pageTitle="pageTitleWithCount"
		:pageDescription="pageDescription"
		:list="doctorsList.doctors"
		:totalCount="doctorsList.totalCount"
		:isLoading="isLoadingDoctors"
		:filterQuery="filterQuery"
		:cityIds="cityIds"
	>
		<template #filters>
			<FilterName
				:label="t('DoctorName')"
				:placeholder="t('InsertDoctorName')"
			/>
			<FilterCitySelect v-model:value="cityIds" />
			<FilterLanguageSelect v-model:value="languageIds" />
			<FilterSpecialtySelect v-model:value="specialtyIds" />
			<FilterClinicSelect v-model:value="clinicIds" />
		</template>

		<template #item="{ item }">
			<DoctorInfo :service="item" />
		</template>

		<template #map-clinic-popup="{ service }">
			<DoctorInfo :service="service" short />
		</template>
	</ListPage>
</template>
