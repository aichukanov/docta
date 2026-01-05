<script setup lang="ts">
import { LocationFilled } from '@element-plus/icons-vue';

const { t } = useI18n();
</script>

<template>
	<el-button :title="t('ShowOnMap')">
		<template #icon>
			<el-icon><LocationFilled /></el-icon>
		</template>
		{{ t('ShowOnMap') }}
	</el-button>
</template>

<i18n lang="json">
{
	"en": {
		"ShowOnMap": "Show on map"
	},
	"ru": {
		"ShowOnMap": "Показать на карте"
	},
	"sr": {
		"ShowOnMap": "Prikaži na mapi"
	},
	"de": {
		"ShowOnMap": "Auf der Karte anzeigen"
	},
	"tr": {
		"ShowOnMap": "Haritada göster"
	},
	"sr-cyrl": {
		"ShowOnMap": "Прикажи на мапи"
	}
}
</i18n>
