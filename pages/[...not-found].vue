<script setup lang="ts">
const { t } = useI18n();
// nuxt хак, в квадратных скобках возьмется параметр и сматчит любой путь сюда, которого нет по-настоящему
</script>

<template>
	<main class="not-found-page" role="main" :aria-label="t('AriaErrorMessage')">
		<ErrorBlock :code="404" :title="t('Error404Title')" />
	</main>
</template>

<i18n lang="json">
{
	"en": {
		"Error404Title": "Page not found",
		"AriaErrorMessage": "Error message"
	},
	"ru": {
		"Error404Title": "Страница не найдена",
		"AriaErrorMessage": "Сообщение об ошибке"
	},
	"sr": {
		"Error404Title": "Stranica nije pronađena",
		"AriaErrorMessage": "Poruka o grešci"
	},
	"de": {
		"Error404Title": "Seite nicht gefunden",
		"AriaErrorMessage": "Fehlermeldung"
	},
	"tr": {
		"Error404Title": "Sayfa bulunamadı",
		"AriaErrorMessage": "Hata mesajı"
	},
	"sr-cyrl": {
		"Error404Title": "Страница није пронађена",
		"AriaErrorMessage": "Порука о грешци"
	}
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
