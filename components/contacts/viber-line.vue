<template>
	<div class="contact-item">
		<a :href="viberUrl" class="contact-link messenger-link" target="_blank">
			<IconViber :size="20" class="messenger-icon" />
			<span>Viber {{ viberContact }}</span>
		</a>
	</div>
</template>

<script setup lang="ts">
import { formatPhoneNumber, isPhoneNumber } from './utils';

const props = defineProps<{
	contact: string;
}>();

const viberUrl = computed(
	() => `viber://chat?number=${props.contact.replace(/[^+\d]/g, '')}`,
);
const viberContact = computed(() =>
	isPhoneNumber(props.contact)
		? formatPhoneNumber(props.contact)
		: props.contact,
);
</script>

<style scoped src="./style.css" />
