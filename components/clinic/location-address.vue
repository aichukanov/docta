<script setup lang="ts">
import { formatClinicAddressLine } from '~/common/clinic-address';
import type { ClinicData } from '~/interfaces/clinic';
import cityI18n from '~/i18n/city';

const props = defineProps<{
	clinic: Pick<ClinicData, 'address' | 'town' | 'postalCode' | 'cityId'>;
}>();

const { t: tCity } = useI18n(cityI18n);

const addressLine = computed(() => {
	return formatClinicAddressLine({
		clinic: props.clinic,
		cityName: tCity(`city_${props.clinic.cityId}`),
	});
});
</script>

<template>
	<span>{{ addressLine }}</span>
</template>
