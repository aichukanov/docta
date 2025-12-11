<template>
	<FilterWrapper :label="label">
		<el-input v-model="name" :placeholder="placeholder" size="large" />
	</FilterWrapper>
</template>

<script setup lang="ts">
defineProps<{
	label: string;
	placeholder: string;
}>();

const { name } = useFilters();
</script>
