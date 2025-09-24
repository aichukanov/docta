<template>
	<ContactsLine :value="telegramUrl" link :tooltip="t('Telegram')">
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

const { t } = useI18n();
</script>

<style scoped src="./style.css" />

<i18n lang="json">
{
	"en": {
		"Telegram": "Telegram"
	},
	"ru": {
		"Telegram": "Telegram"
	},
	"sr": {
		"Telegram": "Telegram"
	},
	"ba": {
		"Telegram": "Telegram"
	},
	"me": {
		"Telegram": "Telegram"
	},
	"de": {
		"Telegram": "Telegram"
	},
	"tr": {
		"Telegram": "Telegram"
	}
}
</i18n>
