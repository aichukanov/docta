<template>
	<ContactsLine :value="instagramUrl" link>
		<IconInstagram :size="20" class="messenger-icon" />
		<span>{{ profile }}</span>
	</ContactsLine>
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
