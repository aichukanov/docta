<template>
	<div class="contact-item">
		<a :href="instagramUrl" class="contact-link messenger-link" target="_blank">
			<IconInstagram :size="20" class="messenger-icon" />
			<span>Instagram</span>
		</a>
	</div>
</template>

<script setup lang="ts">
const props = defineProps<{
	profile: string;
}>();

const instagramUrl = computed(() =>
	props.profile.startsWith('http')
		? props.profile
		: `https://instagram.com/${props.profile}`,
);
</script>

<style scoped src="./style.css" />
