<template>
	<el-checkbox v-model="checked" size="large">{{ label }}</el-checkbox>
</template>

<script setup lang="ts">
defineProps<{
	label: string;
}>();

const { openNow } = useFilters();

const checked = computed({
	get: () => openNow.value,
	set: (value: boolean) => {
		openNow.value = value;
	},
});
</script>
