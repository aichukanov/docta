<script setup lang="ts">
import {
	buildDoctorListSchema,
	buildBreadcrumbsSchema,
} from '~/common/schema-org-builders';
import { SITE_URL } from '~/common/constants';
import { combineI18nMessages } from '~/i18n/utils';

import breadcrumbI18n from '~/i18n/breadcrumb';
import cityI18n from '~/i18n/city';
import doctorI18n from '~/i18n/doctor';
import languageI18n from '~/i18n/language';
import specialtyI18n from '~/i18n/specialty';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		breadcrumbI18n,
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
	locale: locale.value,
}));

const filterQuery = computed(() => getRouteParams().query);

const clinicsStore = useClinicsStore();
await clinicsStore.fetchClinics(locale.value);

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
	const count = doctorsList.value?.totalCount || 0;
	const hasFilters =
		specialtyIds.value.length > 0 ||
		cityIds.value.length > 0 ||
		languageIds.value.length > 0 ||
		clinicIds.value.length > 0;

	if (hasFilters) {
		return t('DoctorsListDescriptionFiltered', {
			count,
			title: pageTitle.value,
		});
	}
	return t('DoctorsListDescription');
});

// Schema.org for doctors list
const schemaOrgStore = useSchemaOrgStore();
const route = useRoute();

const ogImage = `${SITE_URL}/apple-touch-icon.png`;

useSeoMeta({
	title: pageTitleWithCount,
	description: pageDescription,
	ogTitle: pageTitleWithCount,
	ogDescription: pageDescription,
	ogImage: ogImage,
	twitterCard: 'summary',
	twitterTitle: pageTitleWithCount,
	twitterDescription: pageDescription,
	twitterImage: ogImage,
});
const isFiltered = computed(() => {
	return (
		specialtyIds.value.length > 0 ||
		cityIds.value.length > 0 ||
		languageIds.value.length > 0 ||
		clinicIds.value.length > 0 ||
		!!name.value
	);
});
watchEffect(() => {
	if (doctorsList.value) {
		const pageUrl = `${SITE_URL}${route.fullPath}`;
		schemaOrgStore.setSchemas([
			...buildDoctorListSchema({
				siteUrl: SITE_URL,
				pageUrl,
				locale: locale.value,
				title: pageTitle.value,
				description: pageDescription.value,
				totalCount: doctorsList.value.totalCount,
				doctors: doctorsList.value.doctors,
				isFiltered: isFiltered.value,
				getSpecialtyName: (id) => t(`specialty_${id}`),
			}),
			buildBreadcrumbsSchema(pageUrl, [
				{ name: t('BreadcrumbHome'), url: `${SITE_URL}/` },
				{ name: t('BreadcrumbDoctors') },
			]),
		]);
	}
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

		<template #tips>
			<TipsList v-if="doctorsList.doctors.length <= 5">
				<TipsDoctors :cityIds="cityIds" :specialtyIds="specialtyIds" />
			</TipsList>
		</template>
	</ListPage>
</template>
