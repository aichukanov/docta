<template>
	<ContactsLine :value="facebookUrl" link :tooltip="t('Facebook')">
		<IconFacebook :size="20" class="messenger-icon" />
		<span>{{ profile }}</span>
	</ContactsLine>
</template>

<script setup lang="ts">
import { normalizeFacebookUrl } from './utils';

const props = defineProps<{
	profile: string;
}>();

const { t } = useI18n();

const facebookUrl = computed(() => normalizeFacebookUrl(props.profile));
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
	"sr-cyrl": {
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
