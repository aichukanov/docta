<script setup lang="ts">
import { combineI18nMessages } from '~/i18n/utils';
import type { ClinicData } from '~/interfaces/clinic';

import cityI18n from '~/i18n/city';
import clinicI18n from '~/i18n/clinic';
import languageI18n from '~/i18n/language';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([clinicI18n, cityI18n, languageI18n]),
});

const { cityIds, languageIds, name, updateFromRoute, getRouteParams } =
	useFilters();

updateFromRoute(useRoute().query);

const filterList = computed(() => ({
	cityIds: cityIds.value,
	languageIds: languageIds.value,
	name: name.value,
}));

const filterQuery = computed(() => getRouteParams().query);

const { pending: isLoadingClinics, data: clinicsList } = await useFetch(
	'/api/clinics/list',
	{
		key: 'clinics-list',
		method: 'POST',
		body: filterList,
	},
);

const filteredClinics = computed(() => {
	let filtered = clinicsList.value?.clinics || [];

	// Filter by city
	if (cityIds.value.length > 0) {
		filtered = filtered.filter((clinic) =>
			cityIds.value.includes(clinic.cityId),
		);
	}

	// Filter by language
	if (languageIds.value.length > 0) {
		filtered = filtered.filter((clinic) => {
			const clinicLanguageIds = clinic.languageIds
				.split(',')
				.map((id) => parseInt(id));
			return languageIds.value.some((langId) =>
				clinicLanguageIds.includes(langId),
			);
		});
	}

	// Filter by name
	if (name.value) {
		const searchTerm = name.value.toLowerCase();
		filtered = filtered.filter((clinic) =>
			clinic.name.toLowerCase().includes(searchTerm),
		);
	}

	return filtered;
});

const pageTitle = computed(() => {
	if (languageIds.value.length === 1) {
		if (cityIds.value.length === 1) {
			return t('ClinicsLanguageCity', {
				language: t(`language_${languageIds.value[0]}_genitive`),
				city: t(`city_${cityIds.value[0]}_genitive`),
			});
		}
		return t('ClinicsLanguage', {
			language: t(`language_${languageIds.value[0]}_genitive`),
		});
	}

	if (cityIds.value.length === 1) {
		return t('ClinicsCity', {
			city: t(`city_${cityIds.value[0]}_genitive`),
		});
	}

	return t('Clinics');
});

const pageTitleWithCount = computed(() => {
	return `${pageTitle.value} (${filteredClinics.value.length})`;
});

const pageDescription = computed(() => {
	if (cityIds.value.length === 1) {
		return t('ClinicsListDescriptionCity', {
			city: t(`city_${cityIds.value[0]}_genitive`),
		});
	}
	return t('ClinicsListDescription');
});

useSeoMeta({
	title: pageTitleWithCount,
	description: pageDescription,
});

const { setClinicsListSchema } = useSchemaOrg();
const isFiltered = computed(() => {
	return (
		cityIds.value.length > 0 || languageIds.value.length > 0 || !!name.value
	);
});
watchEffect(() => {
	if (filteredClinics.value) {
		setClinicsListSchema({
			title: pageTitle.value,
			description: pageDescription.value,
			totalCount: filteredClinics.value.length,
			clinics: filteredClinics.value,
			isFiltered: isFiltered.value,
		});
	}
});
</script>

<template>
	<ListPage
		:pageTitle="pageTitleWithCount"
		:pageDescription="pageDescription"
		:list="filteredClinics"
		:totalCount="filteredClinics.length"
		:isLoading="isLoadingClinics"
		:filterQuery="filterQuery"
		:cityIds="cityIds"
		:mapClinics="filteredClinics"
	>
		<template #filters>
			<FilterName
				:label="t('ClinicName')"
				:placeholder="t('InsertClinicName')"
			/>
			<FilterCitySelect v-model:value="cityIds" />
			<FilterLanguageSelect v-model:value="languageIds" />
		</template>

		<template #card="{ item, showClinicOnMap }">
			<ClinicSummary
				:clinic="item as ClinicData"
				linkable
				@show-on-map="showClinicOnMap(item)"
			/>
		</template>
	</ListPage>
</template>
