<template>
	<ContactsLine
		:value="websiteUrlWithUtm"
		link
		:tooltip="t('Website')"
		:nofollow="nofollow"
	>
		<IconWebsite :size="20" class="messenger-icon" />
		<span>{{ websiteUrl }}</span>
	</ContactsLine>
</template>

<script setup lang="ts">
import { normalizeWebsiteUrl } from './utils';
import { SITE_NAME } from '~/common/constants';

const props = withDefaults(
	defineProps<{
		websiteUrl: string;
		nofollow?: boolean;
	}>(),
	{
		nofollow: true,
	},
);

const { t } = useI18n();

const websiteUrlWithUtm = computed(() => {
	const normalized = normalizeWebsiteUrl(props.websiteUrl) ?? props.websiteUrl;
	try {
		const url = new URL(normalized);
		url.searchParams.set('utm_source', SITE_NAME);
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
	"sr-cyrl": {
		"Website": "Официјелни сајт"
	},
	"de": {
		"Website": "Offizielle Website"
	},
	"tr": {
		"Website": "Ofisielle Website"
	}
}
</i18n>
