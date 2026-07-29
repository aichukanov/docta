<script setup lang="ts">
const { t } = useI18n();
// nuxt хак, в квадратных скобках возьмется параметр и сматчит любой путь сюда, которого нет по-настоящему

// Раньше страница отдавала 200: без статуса, без title, без noindex и с
// self-canonical на несуществующий URL (canonical снимается в app.vue — там же
// опознаётся этот роут по параметру `not-found`). Для краулера это была тонкая,
// но валидная страница с полным меню сайта, то есть неограниченная
// индексируемая поверхность: любая опечатка или ссылка от спамера превращалась
// в индексируемую страницу. См. prd/silent-200-index-hygiene, итерация 1.
if (import.meta.server) {
	setResponseStatus(useRequestEvent()!, 404);
}

useHead({
	title: () => t('Error404Title'),
	meta: [{ name: 'robots', content: 'noindex, follow' }],
});
</script>

<template>
	<main class="not-found-page" role="main" :aria-label="t('AriaErrorMessage')">
		<!-- Без ClientOnly: текст ошибки обязан быть в серверной разметке, иначе
		краулер видит страницу, в которой об ошибке нет ни слова. -->
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
