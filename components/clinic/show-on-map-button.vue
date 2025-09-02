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
import type { DoctorClinicFull } from '~/interfaces/doctor';

const props = defineProps<{
	clinic: DoctorClinicFull;
}>();

const { t } = useI18n();
</script>
