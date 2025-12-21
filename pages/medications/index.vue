<script setup lang="ts">
import { combineI18nMessages } from '~/i18n/utils';
import {
	buildEntityListSchema,
	buildBreadcrumbsSchema,
} from '~/common/schema-org-builders';

import breadcrumbI18n from '~/i18n/breadcrumb';
import cityI18n from '~/i18n/city';
import medicationI18n from '~/i18n/medication';

const { t } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([breadcrumbI18n, cityI18n, medicationI18n]),
});

const { cityIds, clinicIds, name, updateFromRoute, getRouteParams } =
	useFilters();

updateFromRoute(useRoute().query);

const filterList = computed(() => ({
	cityIds: cityIds.value,
	clinicIds: clinicIds.value,
	name: name.value,
}));

const filterQuery = computed(() => getRouteParams().query);

const { pending: isLoadingMedications, data: medicationsList } = await useFetch(
	'/api/medications/list',
	{
		key: 'medications-list',
		method: 'POST',
		body: filterList,
	},
);

const clinicsStore = useClinicsStore();

const clinicName = computed(() => {
	if (clinicIds.value.length === 1) {
		const clinic = clinicsStore.clinics.find(
			(c) => c.id === clinicIds.value[0],
		);
		return clinic?.name || '';
	}
	return '';
});

const pageTitle = computed(() => {
	if (cityIds.value.length === 1) {
		if (clinicIds.value.length === 1) {
			return t('MedicationsCityClinic', {
				city: t(`city_${cityIds.value[0]}_genitive`),
				clinic: clinicName.value,
			});
		}
		return t('MedicationsCity', {
			city: t(`city_${cityIds.value[0]}_genitive`),
		});
	}

	if (clinicIds.value.length === 1) {
		return t('MedicationsClinic', {
			clinic: clinicName.value,
		});
	}

	return t('Medications');
});

const pageTitleWithCount = computed(() => {
	return `${pageTitle.value} (${medicationsList.value?.totalCount || 0})`;
});

const pageDescription = computed(() => {
	if (cityIds.value.length === 1) {
		return t('MedicationsListDescriptionCity', {
			city: t(`city_${cityIds.value[0]}_genitive`),
		});
	}
	return t('MedicationsListDescription');
});

useSeoMeta({
	title: pageTitleWithCount,
	description: pageDescription,
});

// Schema.org for medications list
const { locale } = useI18n();
const schemaOrgStore = useSchemaOrgStore();
const route = useRoute();
const runtimeConfig = useRuntimeConfig();
const isFiltered = computed(() => {
	return cityIds.value.length > 0 || clinicIds.value.length > 0 || !!name.value;
});
watchEffect(() => {
	if (medicationsList.value) {
		const siteUrl = runtimeConfig.public.siteUrl;
		const pageUrl = `${siteUrl}${route.fullPath}`;
		schemaOrgStore.setSchemas([
			...buildEntityListSchema({
				siteUrl,
				pageUrl,
				locale: locale.value,
				title: pageTitle.value,
				description: pageDescription.value,
				totalCount: medicationsList.value.totalCount,
				items: medicationsList.value.items,
				buildPath: (medication) => `/medications/${medication.id}`,
				isFiltered: isFiltered.value,
			}),
			buildBreadcrumbsSchema(pageUrl, [
				{ name: t('BreadcrumbHome'), url: `${siteUrl}/` },
				{ name: t('BreadcrumbMedications') },
			]),
		]);
	}
});
</script>

<template>
	<ListPage
		:pageTitle="pageTitleWithCount"
		:pageDescription="pageDescription"
		:list="medicationsList?.items || []"
		:totalCount="medicationsList?.totalCount || 0"
		:isLoading="isLoadingMedications"
		:filterQuery="filterQuery"
		:cityIds="cityIds"
		detailsRouteName="medications-medicationId"
		detailsParamName="medicationId"
	>
		<template #filters>
			<FilterName
				:label="t('MedicationName')"
				:placeholder="t('InsertMedicationName')"
			/>
			<FilterCitySelect v-model:value="cityIds" />
			<FilterClinicSelect v-model:value="clinicIds" />
		</template>
	</ListPage>
</template>
