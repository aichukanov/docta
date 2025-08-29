<template>
	<div class="contact-item">
		<a :href="`mailto:${emailAddress}`" class="contact-link">
			<IconMail :size="20" class="messenger-icon" />
			<span>{{ emailAddress }}</span>
		</a>
	</div>
</template>

<script setup lang="ts">
defineProps<{
	emailAddress: string;
}>();
</script>

<style scoped src="./style.css" />
