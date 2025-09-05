<template>
	<el-select
		v-model="languageIds"
		:placeholder="t('AnyLanguage')"
		size="large"
		multiple
		collapse-tags
		collapse-tags-tooltip
		class="filter-language"
	>
		<el-option
			v-for="{ text, value } in languages"
			:key="value"
			:label="text"
			:value="value"
		/>
	</el-select>
</template>

<script setup lang="ts">
import { Language } from '~/enums/language';
import languageI18n from '~/i18n/language';

const { t } = useI18n(languageI18n);

const { languageIds } = useFilters();

const languages = computed(() => [
	{
		text: t(Language.SR),
		value: Language.SR,
	},
	{
		text: t(Language.EN),
		value: Language.EN,
	},
	{
		text: t(Language.RU),
		value: Language.RU,
	},
]);
</script>

<style lang="less" scoped>
.filter-language {
	max-width: 200px;
}
</style>
