<template>
	<ContactsLine :value="websiteUrlWithUtm" link :tooltip="t('Website')">
		<IconWebsite :size="20" class="messenger-icon" />
		<span>{{ websiteUrl }}</span>
	</ContactsLine>
</template>

<script setup lang="ts">
import { normalizeWebsiteUrl } from './utils';

const props = defineProps<{
	websiteUrl: string;
}>();

const { t } = useI18n();
const runtimeConfig = useRuntimeConfig();

const websiteUrlWithUtm = computed(() => {
	const normalized = normalizeWebsiteUrl(props.websiteUrl) ?? props.websiteUrl;
	try {
		const url = new URL(normalized);
		url.searchParams.set('utm_source', runtimeConfig.public.siteName);
		return url.toString();
	} catch {
		// Если URL невалидный, возвращаем как есть
		return normalized;
	}
});
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
