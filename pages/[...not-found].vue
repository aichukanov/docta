<script setup lang="ts">
const { t } = useI18n();
// nuxt хак, в квадратных скобках возьмется параметр и сматчит любой путь сюда, которого нет по-настоящему
</script>

<template>
	<div class="not-found-page">
		<ErrorBlock :code="404" :title="t('Error404Title')" />
	</div>
</template>

<i18n lang="json">
{
	"ru": { "Error404Title": "Страница не найдена" },
	"en": { "Error404Title": "Page not found" },
	"sr": { "Error404Title": "Stranica nije pronađena" },
	"ba": { "Error404Title": "Stranica nije pronađena" },
	"me": { "Error404Title": "Stranica nije pronađena" },
	"de": { "Error404Title": "Seite nicht gefunden" },
	"tr": { "Error404Title": "Sayfa bulunamadı" }
}
</i18n>

<style scoped>
.not-found-page {
	min-height: 50vh;
	display: flex;
	align-items: center;
	justify-content: center;
	padding: 24px;
}
</style>
