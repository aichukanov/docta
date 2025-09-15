<template>
	<FilterWrapper :label="t('ConsultationLanguage')">
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
	</FilterWrapper>
</template>

<script setup lang="ts">
import { LanguageId, Language } from '~/enums/language';
import languageI18n from '~/i18n/language';

const { t } = useI18n(languageI18n);

const { languageIds } = useFilters();

const languages = computed(() => [
	{
		text: t(`language_${Language.SR}`),
		value: LanguageId.SR,
	},
	{
		text: t(`language_${Language.EN}`),
		value: LanguageId.EN,
	},
	{
		text: t(`language_${Language.RU}`),
		value: LanguageId.RU,
	},
]);
</script>
