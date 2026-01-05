<template>
	<ContactsLine :value="waUrl" link :tooltip="t('Whatsapp')">
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

const { t } = useI18n();
</script>

<style scoped src="./style.css" />

<i18n lang="json">
{
	"en": {
		"Whatsapp": "Whatsapp"
	},
	"ru": {
		"Whatsapp": "Whatsapp"
	},
	"sr": {
		"Whatsapp": "Whatsapp"
	},
	"sr-cyrl": {
		"Whatsapp": "Whatsapp"
	},
	"de": {
		"Whatsapp": "Whatsapp"
	},
	"tr": {
		"Whatsapp": "Whatsapp"
	}
}
</i18n>
