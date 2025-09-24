<template>
	<ContactsLine :value="facebookUrl" link :tooltip="t('Facebook')">
		<IconFacebook :size="20" class="messenger-icon" />
		<span>{{ profile }}</span>
	</ContactsLine>
</template>

<script setup lang="ts">
const props = defineProps<{
	profile: string;
}>();

const { t } = useI18n();

const facebookUrl = computed(() => `https://${props.profile}`);
</script>

<style scoped src="./style.css" />

<i18n lang="json">
{
	"en": {
		"Facebook": "Facebook"
	},
	"ru": {
		"Facebook": "Facebook"
	},
	"sr": {
		"Facebook": "Facebook"
	},
	"ba": {
		"Facebook": "Facebook"
	},
	"me": {
		"Facebook": "Facebook"
	},
	"de": {
		"Facebook": "Facebook"
	},
	"tr": {
		"Facebook": "Facebook"
	}
}
</i18n>
