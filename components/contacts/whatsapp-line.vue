<template>
	<ContactsLine :value="waUrl" link>
		<IconWhatsapp :size="20" class="messenger-icon" />
		<span>{{ waContact }}</span>
	</ContactsLine>
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
