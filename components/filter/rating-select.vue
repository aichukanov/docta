<template>
	<FilterWrapper :label="t('Rating')">
		<el-select
			ref="selectRef"
			v-model="minRating"
			:placeholder="t('AnyRating')"
			:aria-label="t('Rating')"
			size="large"
			class="filter-rating"
			@change="selectRef?.blur()"
		>
			<el-option :label="t('AnyRating')" :value="0" />
			<el-option
				v-for="option in RATING_OPTIONS"
				:key="option"
				:label="`★ ${n(option)}+`"
				:value="option"
			/>
		</el-select>
	</FilterWrapper>
</template>

<script setup lang="ts">
import type { ElSelect } from 'element-plus';
import ratingI18n from '~/i18n/rating';

// Значения согласованы с validateMinRating (1..5, шаг 0.5)
const RATING_OPTIONS = [4.5, 4, 3.5, 3];

const selectRef = ref<InstanceType<typeof ElSelect>>();

const props = defineProps<{
	value: number;
}>();

const emit = defineEmits<{
	(e: 'update:value', value: number): void;
}>();

const { t, n } = useI18n(ratingI18n);

const minRating = computed({
	get: () => props.value,
	set: (value: number) => {
		emit('update:value', value);
	},
});
</script>
