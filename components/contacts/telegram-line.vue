<template>
	<div class="contact-item">
		<a :href="telegramUrl" class="contact-link messenger-link" target="_blank">
			<IconTelegram :size="20" class="messenger-icon" />
			<span>Telegram {{ telegramContact }}</span>
		</a>
	</div>
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
