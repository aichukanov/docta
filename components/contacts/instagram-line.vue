<template>
	<ContactsLine :value="instagramUrl" link :tooltip="t('Instagram')">
		<IconInstagram :size="20" class="messenger-icon" />
		<span>{{ profile }}</span>
	</ContactsLine>
</template>

<script setup lang="ts">
const props = defineProps<{
	profile: string;
}>();

const { t } = useI18n();

const instagramUrl = computed(() =>
	props.profile.replace('@', 'https://instagram.com/'),
);
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
