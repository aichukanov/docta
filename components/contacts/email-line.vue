<template>
	<ContactsLine :value="emailAddress" :tooltip="t('Email')">
		<IconEmail :size="20" class="messenger-icon" />
		<span>{{ emailAddress }}</span>
	</ContactsLine>
</template>

<script setup lang="ts">
defineProps<{
	emailAddress: string;
}>();

const { t } = useI18n();
</script>

<style scoped src="./style.css" />

<i18n lang="json">
{
	"en": {
		"Email": "Email"
	},
	"ru": {
		"Email": "Email"
	},
	"sr": {
		"Email": "Email"
	},
	"de": {
		"Email": "Email"
	},
	"tr": {
		"Email": "Email"
	}
}
</i18n>
