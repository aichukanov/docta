<script setup lang="ts">
import { OG_IMAGE, SITE_URL } from '~/common/constants';
import {
	buildBreadcrumbsSchema,
	buildEntityListSchema,
} from '~/common/schema-org-builders';
import { combineI18nMessages } from '~/i18n/utils';
import type { ClinicData } from '~/interfaces/clinic';

import breadcrumbI18n from '~/i18n/breadcrumb';
import cityI18n from '~/i18n/city';
import clinicI18n from '~/i18n/clinic';
import clinicTypeI18n from '~/i18n/clinic-type';
import languageI18n from '~/i18n/language';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		breadcrumbI18n,
		clinicI18n,
		clinicTypeI18n,
		cityI18n,
		languageI18n,
	]),
});

const {
	cityIds,
	languageIds,
	clinicTypeIds,
	name,
	updateFromRoute,
	getRouteParams,
} = useFilters();
const route = useRoute();
const pageNumber = ref(Number(route.query.page || 1));
const routeName = route.name;
watch(
	() => route.query,
	(query) => {
		if (route.name !== routeName) return;
		pageNumber.value = Number(query.page || 1);
		updateFromRoute(query);
	},
	{ immediate: true },
);

const filterList = computed(() => ({
	cityIds: cityIds.value,
	languageIds: languageIds.value,
	clinicTypeIds: clinicTypeIds.value,
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

const clinicTypeName = computed(() => {
	if (clinicTypeIds.value.length === 1) {
		return t(`clinic_type_${clinicTypeIds.value[0]}_plural`);
	}
	return '';
});

const pageTitle = computed(() => {
	const hasType = clinicTypeIds.value.length === 1;
	const hasLang = languageIds.value.length === 1;
	const hasCity = cityIds.value.length === 1;

	const type = clinicTypeName.value;
	const language = hasLang
		? t(`language_${languageIds.value[0]}_genitive`)
		: '';
	const city = hasCity ? t(`city_${cityIds.value[0]}_genitive`) : '';

	if (hasType) {
		if (hasLang) {
			if (hasCity) {
				return t('ClinicsTypeLanguageCity', { type, language, city });
			}
			return t('ClinicsTypeLanguage', { type, language });
		}
		if (hasCity) {
			return t('ClinicsTypeCity', { type, city });
		}
		return t('ClinicsType', { type });
	}

	if (hasLang) {
		if (hasCity) {
			return t('ClinicsLanguageCity', { language, city });
		}
		return t('ClinicsLanguage', { language });
	}

	if (hasCity) {
		return t('ClinicsCity', { city });
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
		cityIds.value.length > 0 ||
		languageIds.value.length > 0 ||
		clinicTypeIds.value.length > 0 ||
		!!name.value
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
				buildPath: (clinic) => `/clinics/${clinic.slug}`,
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
		:clinicMode="true"
	>
		<template #filters>
			<FilterName
				:label="t('ClinicName')"
				:placeholder="t('InsertClinicName')"
			/>
			<FilterClinicTypeSelect v-model:value="clinicTypeIds" />
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

		<template #tips>
			<TipsList v-if="clinicTypeIds.length === 1">
				<TipsClinics
					:clinicTypeIds="clinicTypeIds"
					:languageIds="languageIds"
					:cityIds="cityIds"
				/>
			</TipsList>
		</template>
	</ListPage>
</template>
