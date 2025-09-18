<template>
	<FilterLanguageSelect v-model:value="languageIds" />
</template>

<script setup lang="ts">
const { languageIds } = useFilters();
</script>
