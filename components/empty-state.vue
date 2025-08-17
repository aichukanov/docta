<template>
	<div class="empty-state-wrapper">
		<el-empty v-if="canResetFilters" :description="t('TooStrict')">
			<el-button type="primary" @click="$emit('reset')">
				{{ t('ResetFilters') }}
			</el-button>
		</el-empty>
		<el-empty v-else :description="t('NothingFound')" />
	</div>
</template>

<script setup lang="ts">
defineProps({
	canResetFilters: { type: Boolean, default: false },
});

const { t } = useI18n();
</script>

<style lang="less" scoped>
.empty-state-wrapper {
	flex-grow: 1;
	justify-content: center;
	display: flex;
}
</style>

<i18n lang="json">
{
	"en": {
		"TooStrict": "The filter is too strict, nothing found",
		"ResetFilters": "Reset filters",
		"NothingFound": "Hmm, nothing found"
	},
	"ru": {
		"TooStrict": "Слишком жесткий фильтр, ничего нет",
		"ResetFilters": "Сбросить фильтры",
		"NothingFound": "Хм, ничего нет"
	},
	"sr": {
		"TooStrict": "Filter je previše strog, ništa nije pronađeno",
		"ResetFilters": "Poništi filtere",
		"NothingFound": "Hmm, ništa nije pronađeno"
	},
	"ba": {
		"TooStrict": "Filter je previše strog, ništa nije pronađeno",
		"ResetFilters": "Poništi filtere",
		"NothingFound": "Hmm, ništa nije pronađeno"
	},
	"me": {
		"TooStrict": "Filter je previše strog, ništa nije pronađeno",
		"ResetFilters": "Poništi filtere",
		"NothingFound": "Hmm, ništa nije pronađeno"
	},
	"de": {
		"TooStrict": "Der Filter ist zu streng, nichts gefunden",
		"ResetFilters": "Filter zurücksetzen",
		"NothingFound": "Hmm, nichts gefunden"
	},
	"tr": {
		"TooStrict": "Filtre çok katı, hiçbir şey bulunamadı",
		"ResetFilters": "Filtreleri sıfırla",
		"NothingFound": "Hmm, hiçbir şey bulunamadı"
	}
}
</i18n>
