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
	await useFetch('/api/services/list', {
		key: 'services-list',
		method: 'POST',
		body: filterList,
	});

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

const pageDescription = computed(() => {
	if (cityIds.value.length === 1) {
		return t('MedicalServicesListDescriptionCity', {
			city: t(`city_${cityIds.value[0]}_genitive`),
		});
	}
	return t('MedicalServicesListDescription');
});
</script>

<template>
	<ListPage
		:pageTitle="pageTitleWithCount"
		:pageDescription="pageDescription"
		:list="medicalServicesList?.items || []"
		:totalCount="medicalServicesList?.totalCount || 0"
		:isLoading="isLoadingMedicalServices"
		:filterQuery="filterQuery"
		:cityIds="cityIds"
		detailsRouteName="services-serviceId"
		detailsParamName="serviceId"
	>
		<template #filters>
			<FilterName
				:label="t('ServiceName')"
				:placeholder="t('InsertServiceName')"
			/>
			<FilterCitySelect v-model:value="cityIds" />
			<FilterClinicSelect v-model:value="clinicIds" />
		</template>
	</ListPage>
</template>
