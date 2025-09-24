<template>
	<ContactsLine :value="contact">
		<IconViber :size="20" class="messenger-icon" />
		<span>{{ viberContact }}</span>
	</ContactsLine>
</template>

<script setup lang="ts">
import { formatPhoneNumber, isPhoneNumber } from './utils';

const props = defineProps<{
	contact: string;
}>();

const viberContact = computed(() =>
	isPhoneNumber(props.contact)
		? formatPhoneNumber(props.contact)
		: props.contact,
);
</script>

<style scoped src="./style.css" />
