<template>
	<ContactsLine :value="instagramUrl" link :tooltip="t('Instagram')">
		<IconInstagram :size="20" class="messenger-icon" />
		<span>{{ profile }}</span>
	</ContactsLine>
</template>

<script setup lang="ts">
import { normalizeInstagramUrl } from './utils';

const props = defineProps<{
	profile: string;
}>();

const { t } = useI18n();

const instagramUrl = computed(() => normalizeInstagramUrl(props.profile));
</script>

<style scoped src="./style.css" />

<i18n lang="json">
{
	"en": {
		"Instagram": "Instagram"
	},
	"ru": {
		"Instagram": "Instagram"
	},
	"sr": {
		"Instagram": "Instagram"
	},
	"ba": {
		"Instagram": "Instagram"
	},
	"me": {
		"Instagram": "Instagram"
	},
	"de": {
		"Instagram": "Instagram"
	},
	"tr": {
		"Instagram": "Instagram"
	}
}
</i18n>
