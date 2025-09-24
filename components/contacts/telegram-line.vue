<template>
	<ContactsLine :value="telegramUrl" link>
		<IconTelegram :size="20" class="messenger-icon" />
		<span>{{ telegramContact }}</span>
	</ContactsLine>
</template>

<script setup lang="ts">
import { formatPhoneNumber, isPhoneNumber } from './utils';

const props = defineProps<{
	contact: string;
}>();

const telegramUrl = computed(() =>
	props.contact.startsWith('http')
		? props.contact
		: `https://t.me/${props.contact.replace(/[^+\\d]/g, '')}`,
);

const telegramContact = computed(() =>
	isPhoneNumber(props.contact)
		? formatPhoneNumber(props.contact)
		: props.contact,
);
</script>

<style scoped src="./style.css" />
