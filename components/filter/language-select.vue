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
import { LanguageId } from '~/enums/language';
import languageI18n from '~/i18n/language';

const props = defineProps<{
	value: number[];
}>();

const emit = defineEmits<{
	(e: 'update:value', value: number[]): void;
}>();

const { t } = useI18n(languageI18n);

const languageIds = computed({
	get: () => props.value,
	set: (value: number[]) => {
		emit('update:value', value);
	},
});

const languages = computed(() => [
	{
		text: t(`language_${LanguageId.SR}`),
		value: LanguageId.SR,
	},
	{
		text: t(`language_${LanguageId.EN}`),
		value: LanguageId.EN,
	},
	{
		text: t(`language_${LanguageId.RU}`),
		value: LanguageId.RU,
	},
	{
		text: t(`language_${LanguageId.IT}`),
		value: LanguageId.IT,
	},
]);
</script>
