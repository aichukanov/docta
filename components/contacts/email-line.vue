<template>
	<ContactsLine :value="emailAddress">
		<IconEmail :size="20" class="messenger-icon" />
		<span>{{ emailAddress }}</span>
	</ContactsLine>
</template>

<script setup lang="ts">
defineProps<{
	emailAddress: string;
}>();
</script>

<style scoped src="./style.css" />
