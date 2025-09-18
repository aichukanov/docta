<template>
	<FilterSpecialtySelect v-model:value="specialtyIds" />
</template>

<script setup lang="ts">
const { specialtyIds } = useFilters();
</script>
