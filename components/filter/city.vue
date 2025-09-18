<template>
	<FilterCitySelect v-model:value="cityIds" />
</template>

<script setup lang="ts">
const { cityIds } = useFilters();
</script>
