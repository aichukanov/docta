<template>
	<ContactsLine :value="facebookUrl" link>
		<IconFacebook :size="20" class="messenger-icon" />
		<span>{{ profile }}</span>
	</ContactsLine>
</template>

<script setup lang="ts">
const props = defineProps<{
	profile: string;
}>();

const facebookUrl = computed(() => `https://${props.profile}`);
</script>

<style scoped src="./style.css" />
