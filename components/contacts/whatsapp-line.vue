<template>
	<div class="contact-item">
		<a :href="waUrl" class="contact-link messenger-link" target="_blank">
			<IconWhatsApp :size="20" class="messenger-icon" />
			<span>WhatsApp {{ waContact }}</span>
		</a>
	</div>
</template>

<script setup lang="ts">
import { formatPhoneNumber, isPhoneNumber } from './utils';

const props = defineProps<{
	contact: string;
}>();

const waUrl = computed(
	() => `https://wa.me/${props.contact.replace(/[^+\d]/g, '')}`,
);

const waContact = computed(() =>
	isPhoneNumber(props.contact)
		? formatPhoneNumber(props.contact)
		: props.contact,
);
</script>

<style scoped src="./style.css" />
