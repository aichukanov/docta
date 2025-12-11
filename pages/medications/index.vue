<script setup lang="ts">
import { combineI18nMessages } from '~/i18n/utils';

import cityI18n from '~/i18n/city';
import medicationI18n from '~/i18n/medication';

const { t } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([cityI18n, medicationI18n]),
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
</script>

<template>
	<ListPage
		:pageTitle="pageTitleWithCount"
		:pageDescription="pageDescription"
		:list="medicationsList?.medications || []"
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
