<template>
	<FilterWrapper :label="t('Rating')">
		<KitSelect
			v-model="minRating"
			:options="ratingOptions"
			:placeholder="t('AnyRating')"
			:aria-label="t('Rating')"
			:no-data-text="uiText('NothingFound')"
			size="large"
			class="filter-rating"
		/>
	</FilterWrapper>
</template>

<script setup lang="ts">
import ratingI18n from '~/i18n/rating';

// Значения согласованы с validateMinRating (1..5, шаг 0.5)
const RATING_OPTIONS = [4.5, 4, 3.5, 3];

const props = defineProps<{
	value: number;
}>();

const emit = defineEmits<{
	(e: 'update:value', value: number): void;
}>();

const { t, n } = useI18n(ratingI18n);
const { uiText } = useUiText();

/* «Любой рейтинг» первым пунктом, дальше шкала — как было в el-option */
const ratingOptions = computed(() => [
	{ value: 0, label: t('AnyRating') },
	...RATING_OPTIONS.map((option) => ({
		value: option,
		label: `★ ${n(option)}+`,
	})),
]);

const minRating = computed({
	get: () => props.value,
	set: (value: number) => {
		emit('update:value', value);
	},
});
</script>
