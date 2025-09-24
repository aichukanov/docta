<template>
	<ContactsLine :value="websiteUrl" link>
		<IconWebsite :size="20" class="messenger-icon" />
		<span>{{ websiteUrl }}</span>
	</ContactsLine>
</template>

<script setup lang="ts">
const props = defineProps<{
	websiteUrl: string;
}>();
</script>

<style scoped src="./style.css" />
