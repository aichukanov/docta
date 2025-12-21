<template>
	<ContactsLine :value="telegramUrl" link :tooltip="t('Telegram')">
		<IconTelegram :size="20" class="messenger-icon" />
		<span>{{ telegramContact }}</span>
	</ContactsLine>
</template>

<script setup lang="ts">
import {
	formatPhoneNumber,
	isPhoneNumber,
	normalizeTelegramUrl,
} from './utils';

const props = defineProps<{
	contact: string;
}>();

const telegramUrl = computed(() => normalizeTelegramUrl(props.contact));

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
	"de": {
		"Telegram": "Telegram"
	},
	"tr": {
		"Telegram": "Telegram"
	}
}
</i18n>
