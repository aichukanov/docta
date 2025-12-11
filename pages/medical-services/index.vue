<script setup lang="ts">
import { combineI18nMessages } from '~/i18n/utils';

import cityI18n from '~/i18n/city';
import medicalServiceI18n from '~/i18n/medical-service';

const { t } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([cityI18n, medicalServiceI18n]),
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

const { pending: isLoadingMedicalServices, data: medicalServicesList } =
	await useFetch('/api/medical-services/list', {
		key: 'medical-services-list',
		method: 'POST',
		body: filterList,
	});

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
			return t('MedicalServicesCityClinic', {
				city: t(`city_${cityIds.value[0]}_genitive`),
				clinic: clinicName.value,
			});
		}
		return t('MedicalServicesCity', {
			city: t(`city_${cityIds.value[0]}_genitive`),
		});
	}

	if (clinicIds.value.length === 1) {
		return t('MedicalServicesClinic', {
			clinic: clinicName.value,
		});
	}

	return t('MedicalServices');
});

const pageTitleWithCount = computed(() => {
	return `${pageTitle.value} (${medicalServicesList.value?.totalCount || 0})`;
});
</script>

<template>
	<ListPage
		:pageTitle="pageTitleWithCount"
		:list="medicalServicesList?.medicalServices || []"
		:totalCount="medicalServicesList?.totalCount || 0"
		:isLoading="isLoadingMedicalServices"
		:filterQuery="filterQuery"
		:cityIds="cityIds"
		detailsRouteName="medical-services-serviceId"
		detailsParamName="serviceId"
	>
		<template #filters>
			<FilterName />
			<FilterCitySelect v-model:value="cityIds" />
			<FilterClinicSelect v-model:value="clinicIds" />
		</template>
	</ListPage>
</template>
