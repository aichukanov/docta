<script setup lang="ts">
const { t: $t } = useI18n({ useScope: 'global' });

const seoTitle = computed(
	() => 'docta.me | ' + $t(enrichForCountry('ApplicationName')),
);

const seoDescription = computed(
	() => $t('index') + ' | ' + $t(enrichForCountry('OnePlatform')),
);

useSeoMeta({
	title: () => seoTitle.value,
	description: () => seoDescription.value,
	ogTitle: () => seoTitle.value,
	ogDescription: () => seoDescription.value,
	ogImage: () => `https://docta.me/logo-site.png`,
});
</script>

<template>
	<PageWrapper>
		<div class="main-page"> main page </div>
	</PageWrapper>
</template>

<style lang="less" scoped>
@import url('~/assets/css/vars.less');

.main-page {
	display: flex;
	flex-wrap: wrap;
	gap: @base-offset;
}
</style>
