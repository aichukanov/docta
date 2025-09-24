<template>
	<ContactsLine :value="websiteUrl" link :tooltip="t('Website')">
		<IconWebsite :size="20" class="messenger-icon" />
		<span>{{ websiteUrl }}</span>
	</ContactsLine>
</template>

<script setup lang="ts">
const props = defineProps<{
	websiteUrl: string;
}>();

const { t } = useI18n();
</script>

<style scoped src="./style.css" />

<i18n lang="json">
{
	"en": {
		"Website": "Official website"
	},
	"ru": {
		"Website": "Официальный сайт"
	},
	"sr": {
		"Website": "Oficijelni sajt"
	},
	"ba": {
		"Website": "Oficijelni sajt"
	},
	"me": {
		"Website": "Oficijelni sajt"
	},
	"de": {
		"Website": "Offizielle Website"
	},
	"tr": {
		"Website": "Ofisielle Website"
	}
}
</i18n>
