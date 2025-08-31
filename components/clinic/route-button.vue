<template>
	<el-link target="_blank" :href="googleMapsUrl" underline="never">
		<span class="link-with-icon">
			<IconRoute :size="20" />
			{{ text ?? t('BuildRoute') }}
		</span>
	</el-link>
</template>

<script setup lang="ts">
import { createRouteUrl } from '~/common/google-maps';
import type { ClinicData } from '~/interfaces/doctor';

const props = defineProps<{
	clinic: ClinicData;
	text?: string;
}>();

const { t } = useI18n();

const googleMapsUrl = computed(() => {
	return createRouteUrl(props.clinic.latitude, props.clinic.longitude);
});
</script>

<style scoped>
.link-with-icon {
	display: flex;
	align-items: center;
	gap: var(--spacing-xs);
}
</style>
