<template>
	<DsButton
		variant="white"
		size="sm"
		@click="handleRouteClick()"
		:title="t('BuildRoute')"
	>
		<template #icon>
			<IconRoute :size="20" />
		</template>
		{{ t('BuildRoute') }}
	</DsButton>
</template>

<script setup lang="ts">
import type { DoctorClinicFull } from '~/interfaces/doctor';

const props = defineProps<{
	clinic: DoctorClinicFull;
}>();

const { t } = useI18n();

function handleRouteClick() {
	const destination = encodeURIComponent(
		props.clinic.address || props.clinic.clinicName,
	);
	const googleMapsUrl = `https://www.google.com/maps/dir/?api=1&destination=${destination}&travelmode=driving`;
	window.open(googleMapsUrl, '_blank');
}
</script>
