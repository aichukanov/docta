<script setup lang="ts"></script>

<template>
	<div class="layout-content">
		<div class="main-title__wrapper" v-if="$slots.header">
			<h1 class="main-title" v-if="$slots.header">
				<slot name="header" />
			</h1>
		</div>

		<div class="content-wrapper">
			<div class="page-block">
				<slot />
			</div>
		</div>
	</div>
</template>

<style lang="less" scoped>
@import url('~/assets/css/vars.less');

@header-height: 75px;
@footer-height: 65px;

.localrent-widget {
	padding: 8px;
}

.layout-content {
	display: flex;
	flex-direction: column;
}

.main-title__wrapper {
	display: flex;
	flex-direction: column;
	padding: @base-offset @base-padding (@base-padding + @base-offset)
		@base-padding;
	gap: @base-padding;

	.main-title {
		margin: 0;

		&:first-letter {
			text-transform: uppercase;
		}
	}
}

.page-block {
	display: flex;
	flex-direction: column;
	flex: 1 1 auto;
	padding: 0 @base-padding;
	width: 100%;
	box-sizing: border-box;
}

.content-wrapper {
	display: flex;
	min-height: calc(
		100vh - @base-padding - @header-height - @footer-height - 49px
	); // можно добавить - 2px, чтобы убрать скрол, но так прыгает при загрузке новых страниц
}
</style>

<i18n lang="json">
{
	"en": {
		"Back": "Back",
		"Filters": "Sorting and Filters",
		"ShowFilters": "Show filters",
		"BackToMainView": "Back to main view"
	},
	"ru": {
		"Back": "Назад",
		"Filters": "Сортировка и Фильтры",
		"ShowFilters": "Показать фильтры",
		"BackToMainView": "Вернуться к основному виду"
	},
	"sr": {
		"Back": "Nazad",
		"Filters": "Sortiranje i Filteri",
		"ShowFilters": "Prikaži filtere",
		"BackToMainView": "Nazad na glavni prikaz"
	},
	"ba": {
		"Back": "Nazad",
		"Filters": "Sortiranje i Filteri",
		"ShowFilters": "Prikaži filtere",
		"BackToMainView": "Nazad na glavni prikaz"
	},
	"me": {
		"Back": "Nazad",
		"Filters": "Sortiranje i Filteri",
		"ShowFilters": "Prikaži filtere",
		"BackToMainView": "Nazad na glavni prikaz"
	},
	"de": {
		"Back": "Zurück",
		"Filters": "Sortierung und Filter",
		"ShowFilters": "Filter anzeigen",
		"BackToMainView": "Zurück zur Hauptansicht"
	},
	"tr": {
		"Back": "Geri",
		"Filters": "Sıralama ve Filtreler",
		"ShowFilters": "Filtreleri göster",
		"BackToMainView": "Ana görünüme dön"
	}
}
</i18n>
