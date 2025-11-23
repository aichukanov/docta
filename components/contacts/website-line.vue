<template>
	<ContactsLine :value="websiteUrlWithUtm" link :tooltip="t('Website')">
		<IconWebsite :size="20" class="messenger-icon" />
		<span>{{ websiteUrl }}</span>
	</ContactsLine>
</template>

<script setup lang="ts">
const props = defineProps<{
	websiteUrl: string;
}>();

const { t } = useI18n();

const websiteUrlWithUtm = computed(() => {
	try {
		const url = new URL(props.websiteUrl);
		url.searchParams.set('utm_source', 'docta.me');
		return url.toString();
	} catch {
		// Если URL невалидный, возвращаем как есть
		return props.websiteUrl;
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
