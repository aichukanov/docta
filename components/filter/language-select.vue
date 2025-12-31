<template>
	<FilterWrapper :label="t('ConsultationLanguage')">
		<el-select
			ref="selectRef"
			v-model="languageIds"
			:placeholder="t('AnyLanguage')"
			size="large"
			multiple
			collapse-tags
			collapse-tags-tooltip
			class="filter-language"
			@change="selectRef?.blur()"
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
import type { ElSelect } from 'element-plus';
import { LanguageId } from '~/enums/language';
import languageI18n from '~/i18n/language';

const selectRef = ref<InstanceType<typeof ElSelect>>();

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
	{
		text: t(`language_${LanguageId.FR}`),
		value: LanguageId.FR,
	},
	{
		text: t(`language_${LanguageId.DE}`),
		value: LanguageId.DE,
	},
]);
</script>
