<script setup lang="ts">
import { OfficeBuilding } from '@element-plus/icons-vue';

const props = withDefaults(
	defineProps<{
		logoUrl?: string | null;
		name: string;
		size?: number;
	}>(),
	{
		logoUrl: null,
		size: 80,
	},
);

const hasLogo = computed(() => !!props.logoUrl?.trim());
const imgError = ref(false);

function onError() {
	imgError.value = true;
}

watch(
	() => props.logoUrl,
	() => {
		imgError.value = false;
	},
);
</script>

<template>
	<div class="clinic-logo" :style="{ width: `${size}px`, height: `${size}px` }">
		<img
			v-if="hasLogo && !imgError"
			:src="logoUrl!"
			:alt="name"
			class="clinic-logo__img"
			:width="size"
			:height="size"
			@error="onError"
		/>
		<el-icon v-else class="clinic-logo__fallback" :size="size * 0.5">
			<OfficeBuilding />
		</el-icon>
	</div>
</template>

<style scoped lang="less">
.clinic-logo {
	flex-shrink: 0;
	border-radius: 12px;
	overflow: hidden;
	display: flex;
	align-items: center;
	justify-content: center;
	background: var(--color-surface-secondary);
}

.clinic-logo__img {
	width: 100%;
	height: 100%;
	object-fit: contain;
}

.clinic-logo__fallback {
	color: var(--color-text-tertiary);
}
</style>
