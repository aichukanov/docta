<template>
	<ContactsLine :value="contact" :tooltip="t('Viber')">
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

const { t } = useI18n();
</script>

<style scoped src="./style.css" />

<i18n lang="json">
{
	"en": {
		"Viber": "Viber"
	},
	"ru": {
		"Viber": "Viber"
	},
	"sr": {
		"Viber": "Viber"
	},
	"ba": {
		"Viber": "Viber"
	},
	"me": {
		"Viber": "Viber"
	},
	"de": {
		"Viber": "Viber"
	},
	"tr": {
		"Viber": "Viber"
	}
}
</i18n>
