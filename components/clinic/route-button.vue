<template>
	<el-link target="_blank" :href="googleMapsUrl" underline="never">
		<span class="link-with-icon">
			<IconRoute :size="20" />
			<slot>
				{{ t('BuildRoute') }}
			</slot>
		</span>
	</el-link>
</template>

<script setup lang="ts">
import { createRouteUrl } from '~/common/google-maps';
import type { ClinicData } from '~/interfaces/clinic';

const props = defineProps<{
	clinic: ClinicData;
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

<i18n lang="json">
{
	"en": {
		"BuildRoute": "Build Route"
	},
	"ru": {
		"BuildRoute": "Построить маршрут"
	},
	"de": {
		"BuildRoute": "Route erstellen"
	},
	"tr": {
		"BuildRoute": "Rota oluştur"
	},
	"sr": {
		"BuildRoute": "Napravi rutu"
	}
}
</i18n>
