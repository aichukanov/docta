<template>
	<el-button :title="t('ShowOnMap')">
		<template #icon>
			<el-icon><LocationFilled /></el-icon>
		</template>
		{{ t('ShowOnMap') }}
	</el-button>
</template>

<script setup lang="ts">
import { LocationFilled } from '@element-plus/icons-vue';

const { t } = useI18n();
</script>
