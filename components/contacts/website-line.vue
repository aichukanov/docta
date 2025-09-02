<template>
	<div class="contact-item">
		<a :href="websiteUrl" class="contact-link messenger-link" target="_blank">
			<IconWebsite :size="20" class="messenger-icon" />
			<span>{{ websiteUrl }}</span>
		</a>
	</div>
</template>

<script setup lang="ts">
const props = defineProps<{
	websiteUrl: string;
}>();
</script>

<style scoped src="./style.css" />
