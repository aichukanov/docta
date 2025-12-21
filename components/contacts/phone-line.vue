<template>
	<ContactsLine :value="phoneNumber" :tooltip="t('Phone')">
		<IconPhone :size="20" class="phone-icon" />
		<span>{{ formatPhoneNumber(phoneNumber) }}</span>
	</ContactsLine>
</template>

<script setup lang="ts">
import { formatPhoneNumber } from './utils';

defineProps<{
	phoneNumber: string;
}>();

const { t } = useI18n();
</script>

<style scoped src="./style.css" />

<i18n lang="json">
{
	"en": {
		"Phone": "Phone number"
	},
	"ru": {
		"Phone": "Номер телефона"
	},
	"sr": {
		"Phone": "Broj telefona"
	},
	"de": {
		"Phone": "Telefonnummer"
	},
	"tr": {
		"Phone": "Telefon numarası"
	}
}
</i18n>
