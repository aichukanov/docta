<template>
	<div class="contact-item">
		<a :href="instagramUrl" class="contact-link messenger-link" target="_blank">
			<IconInstagram :size="20" class="messenger-icon" />
			<span>{{ profile }}</span>
		</a>
	</div>
</template>

<script setup lang="ts">
const props = defineProps<{
	profile: string;
}>();

const instagramUrl = computed(() =>
	props.profile.replace('@', 'https://instagram.com/'),
);
</script>

<style scoped src="./style.css" />
