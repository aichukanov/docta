<template>
	<FilterWrapper :label="t('ConsultationLanguage')">
		<KitSelect
			v-model="languageIds"
			:options="languageOptions"
			:placeholder="t('AnyLanguage')"
			:aria-label="t('ConsultationLanguage')"
			:no-data-text="uiText('NothingFound')"
			size="large"
			multiple
			:max-tags="3"
			class="filter-language"
		/>
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
const { uiText } = useUiText();

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
	{
		text: t(`language_${LanguageId.FR}`),
		value: LanguageId.FR,
	},
	{
		text: t(`language_${LanguageId.DE}`),
		value: LanguageId.DE,
	},
]);

const languageOptions = computed(() =>
	languages.value.map(({ text, value }) => ({ value, label: text })),
);
</script>
