<script setup lang="ts">
import { combineI18nMessages } from '~/i18n/utils';
import {
	buildEntityListSchema,
	buildBreadcrumbsSchema,
} from '~/common/schema-org-builders';
import { SITE_URL, OG_IMAGE } from '~/common/constants';

import breadcrumbI18n from '~/i18n/breadcrumb';
import cityI18n from '~/i18n/city';
import labTestI18n from '~/i18n/labtest';
import labTestCategoryI18n from '~/i18n/labtest-category';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		breadcrumbI18n,
		cityI18n,
		labTestI18n,
		labTestCategoryI18n,
	]),
});

const {
	cityIds,
	categoryIds,
	clinicIds,
	name,
	updateFromRoute,
	getRouteParams,
} = useFilters();

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
	categoryIds: categoryIds.value,
	clinicIds: clinicIds.value,
	name: name.value,
	locale: locale.value,
	page: pageNumber.value,
}));

const filterQuery = computed(() => getRouteParams().query);

const clinicsStore = useClinicsStore();

const [{ pending: isLoadingLabTests, data: labTestsList }] = await Promise.all([
	useFetch('/api/labtests/list', {
		key: 'labtests-list',
		method: 'POST',
		body: filterList,
	}),
	clinicsStore.fetchClinics(),
]);

const clinicName = computed(() => {
	if (clinicIds.value.length === 1) {
		const clinic = clinicsStore.clinics.find(
			(c) => c.id === clinicIds.value[0],
		);
		return clinic?.name || '';
	}
	return '';
});

const categoryName = computed(() => {
	if (categoryIds.value.length === 1) {
		return t(`lab_test_category_${categoryIds.value[0]}_title`);
	}
	return '';
});

const pageTitle = computed(() => {
	if (categoryIds.value.length === 1) {
		if (cityIds.value.length === 1) {
			if (clinicIds.value.length === 1) {
				return t('LabTestsCategoryCityClinic', {
					category: categoryName.value,
					city: t(`city_${cityIds.value[0]}_genitive`),
					clinic: clinicName.value,
				});
			}
			return t('LabTestsCategoryCity', {
				category: categoryName.value,
				city: t(`city_${cityIds.value[0]}_genitive`),
			});
		}
		if (clinicIds.value.length === 1) {
			return t('LabTestsCategoryClinic', {
				category: categoryName.value,
				clinic: clinicName.value,
			});
		}
		return t('LabTestsCategory', {
			category: categoryName.value,
		});
	}

	if (cityIds.value.length === 1) {
		if (clinicIds.value.length === 1) {
			return t('LabTestsCityClinic', {
				city: t(`city_${cityIds.value[0]}_genitive`),
				clinic: clinicName.value,
			});
		}
		return t('LabTestsCity', {
			city: t(`city_${cityIds.value[0]}_genitive`),
		});
	}

	if (clinicIds.value.length === 1) {
		return t('LabTestsClinic', {
			clinic: clinicName.value,
		});
	}

	return t('LabTests');
});

const pageTitleWithCount = computed(() => {
	return `${pageTitle.value} (${labTestsList.value?.totalCount})`;
});

const pageDescription = computed(() => {
	if (categoryIds.value.length === 1) {
		if (cityIds.value.length === 1) {
			return t('LabTestsListDescriptionCategoryCity', {
				category: categoryName.value,
				city: t(`city_${cityIds.value[0]}_genitive`),
			});
		}
		return t('LabTestsListDescriptionCategory', {
			category: categoryName.value,
		});
	}

	if (cityIds.value.length === 1) {
		return t('LabTestsListDescriptionCity', {
			city: t(`city_${cityIds.value[0]}_genitive`),
		});
	}
	return t('LabTestsListDescription');
});

// Schema.org for lab tests list
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
		categoryIds.value.length > 0 ||
		clinicIds.value.length > 0 ||
		!!name.value
	);
});

watchEffect(() => {
	if (labTestsList.value) {
		const pageUrl = `${SITE_URL}${route.fullPath}`;

		schemaOrgStore.setSchemas([
			...buildEntityListSchema({
				siteUrl: SITE_URL,
				pageUrl,
				locale: locale.value,
				title: pageTitle.value,
				description: pageDescription.value,
				totalCount: labTestsList.value.totalCount,
				items: labTestsList.value.items,
				buildPath: (test) => `/labtests/${test.id}`,
				isFiltered: isFiltered.value,
			}),
			buildBreadcrumbsSchema(pageUrl, [
				{ name: t('BreadcrumbHome'), url: `${SITE_URL}/` },
				{ name: t('BreadcrumbLabTests') },
			]),
		]);
	}
});
</script>

<template>
	<ListPage
		:pageTitle="pageTitleWithCount"
		:pageDescription="pageDescription"
		:list="labTestsList?.items || []"
		:totalCount="labTestsList?.totalCount || 0"
		:isLoading="isLoadingLabTests"
		:filterQuery="filterQuery"
		:cityIds="cityIds"
		detailsRouteName="labtests-labTestId"
		detailsParamName="labTestId"
	>
		<template #filters>
			<FilterName
				:label="t('LabTestName')"
				:placeholder="t('InsertLabTestName')"
			/>
			<FilterCitySelect v-model:value="cityIds" />
			<FilterCategorySelect v-model:value="categoryIds" />
			<FilterClinicSelect v-model:value="clinicIds" />
		</template>

		<template #item="{ item }">
			<LabTestInfo
				:name="item.name"
				:localName="item.localName"
				:synonyms="item.synonyms"
				:categoryIds="item.categoryIds"
				:itemId="item.id"
				detailsRouteName="labtests-labTestId"
				detailsParamName="labTestId"
			/>
		</template>
	</ListPage>
</template>
