<script setup lang="ts">
import { combineI18nMessages } from '~/i18n/utils';
import {
	buildEntityListSchema,
	buildBreadcrumbsSchema,
} from '~/common/schema-org-builders';
import { SITE_URL, OG_IMAGE } from '~/common/constants';
import type { ClinicData } from '~/interfaces/clinic';

import breadcrumbI18n from '~/i18n/breadcrumb';
import cityI18n from '~/i18n/city';
import clinicI18n from '~/i18n/clinic';
import languageI18n from '~/i18n/language';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		breadcrumbI18n,
		clinicI18n,
		cityI18n,
		languageI18n,
	]),
});

const { cityIds, languageIds, name, updateFromRoute, getRouteParams } =
	useFilters();
const route = useRoute();
const pageNumber = computed(() => Number(route.query.page || 1));

watch(
	() => route.query,
	(query) => {
		updateFromRoute(query);
	},
	{ immediate: true },
);

const filterList = computed(() => ({
	cityIds: cityIds.value,
	languageIds: languageIds.value,
	name: name.value,
	locale: locale.value,
	page: pageNumber.value,
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
	return `${pageTitle.value} (${clinicsList.value?.totalCount || 0})`;
});

const pageDescription = computed(() => {
	if (cityIds.value.length === 1) {
		return t('ClinicsListDescriptionCity', {
			city: t(`city_${cityIds.value[0]}_genitive`),
		});
	}
	return t('ClinicsListDescription');
});

// Schema.org for clinics list
const schemaOrgStore = useSchemaOrgStore();

useSeoMeta({
	title: pageTitleWithCount,
	description: pageDescription,
	ogTitle: pageTitleWithCount,
	ogDescription: pageDescription,
	ogImage: OG_IMAGE,
	twitterCard: 'summary',
	twitterTitle: pageTitleWithCount,
	twitterDescription: pageDescription,
	twitterImage: OG_IMAGE,
});
const isFiltered = computed(() => {
	return (
		cityIds.value.length > 0 || languageIds.value.length > 0 || !!name.value
	);
});
watchEffect(() => {
	if (clinicsList.value) {
		const pageUrl = `${SITE_URL}${route.fullPath}`;
		schemaOrgStore.setSchemas([
			...buildEntityListSchema({
				siteUrl: SITE_URL,
				pageUrl,
				locale: locale.value,
				title: pageTitle.value,
				description: pageDescription.value,
				totalCount: clinicsList.value.totalCount,
				items: clinicsList.value.clinics,
				buildPath: (clinic) => `/clinics/${clinic.id}`,
				isFiltered: isFiltered.value,
			}),
			buildBreadcrumbsSchema(pageUrl, [
				{ name: t('BreadcrumbHome'), url: `${SITE_URL}/` },
				{ name: t('BreadcrumbClinics') },
			]),
		]);
	}
});
</script>

<template>
	<ListPage
		:pageTitle="pageTitleWithCount"
		:pageDescription="pageDescription"
		:list="clinicsList?.clinics || []"
		:totalCount="clinicsList?.totalCount || 0"
		:isLoading="isLoadingClinics"
		:filterQuery="filterQuery"
		:cityIds="cityIds"
		:mapClinics="clinicsList?.clinics || []"
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
				:showPrice="false"
				@show-on-map="showClinicOnMap(item)"
			/>
		</template>
	</ListPage>
</template>
