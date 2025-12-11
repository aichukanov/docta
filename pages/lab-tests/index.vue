<script setup lang="ts">
import { combineI18nMessages } from '~/i18n/utils';

import cityI18n from '~/i18n/city';
import labTestI18n from '~/i18n/lab-test';

const { t } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([cityI18n, labTestI18n]),
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

const { pending: isLoadingLabTests, data: labTestsList } = await useFetch(
	'/api/lab-tests/list',
	{
		key: 'lab-tests-list',
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
</script>

<template>
	<ListPage
		:pageTitle="pageTitleWithCount"
		:list="labTestsList.labTests"
		:totalCount="labTestsList.totalCount"
		:isLoading="isLoadingLabTests"
		:filterQuery="filterQuery"
		:cityIds="cityIds"
		detailsRouteName="lab-tests-labTestId"
		detailsParamName="labTestId"
	>
		<template #filters>
			<FilterName
				:label="t('LabTestName')"
				:placeholder="t('InsertLabTestName')"
			/>
			<FilterCitySelect v-model:value="cityIds" />
			<FilterClinicSelect v-model:value="clinicIds" />
		</template>
	</ListPage>
</template>
