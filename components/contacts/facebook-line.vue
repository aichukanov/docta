<template>
	<div class="contact-item">
		<a :href="facebookUrl" class="contact-link messenger-link" target="_blank">
			<IconFacebook :size="20" class="messenger-icon" />
			<span>Facebook</span>
		</a>
	</div>
</template>

<script setup lang="ts">
const props = defineProps<{
	profile: string;
}>();

const facebookUrl = computed(() =>
	props.profile.startsWith('http')
		? props.profile
		: `https://facebook.com/${props.profile}`,
);
</script>

<style scoped src="./style.css" />
