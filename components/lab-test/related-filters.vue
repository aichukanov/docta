<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import cityI18n from '~/i18n/city';
import labTestCategoryI18n from '~/i18n/labtest-category';
import { combineI18nMessages } from '~/i18n/utils';

// Хаб перелинковки на /labtests: когда выбрана ровно одна категория —
// ссылки на неё же в других городах; когда выбран ровно один город —
// ссылки на другие категории анализов в этом городе (см.
// docs/audit/seo-2026-07.md, пункт 1b).
const props = defineProps<{
	categoryIds: number[];
	cityIds: number[];
}>();

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([cityI18n, labTestCategoryI18n]),
});

const { data } = await useFetch('/api/labtests/category-city-combinations', {
	key: 'labtests-category-city-combinations',
});

const combinations = computed(
	() => data.value?.categoryCityCombinations ?? [],
);

const selectedCategoryId = computed(() =>
	props.categoryIds.length === 1 ? props.categoryIds[0] : null,
);
const selectedCityId = computed(() =>
	props.cityIds.length === 1 ? props.cityIds[0] : null,
);

const otherCitiesForCategory = computed(() => {
	if (selectedCategoryId.value === null) return [];
	return combinations.value
		.filter((c) => c.categoryId === selectedCategoryId.value)
		.map((c) => c.cityId)
		.filter((cityId) => cityId !== selectedCityId.value);
});

const otherCategoriesForCity = computed(() => {
	if (selectedCityId.value === null) return [];
	return combinations.value
		.filter((c) => c.cityId === selectedCityId.value)
		.map((c) => c.categoryId)
		.filter((categoryId) => categoryId !== selectedCategoryId.value);
});

const categoryCityLink = (categoryId: number, cityId: number) => ({
	name: 'labtests',
	query: {
		...getRegionalQuery(locale.value),
		categoryIds: String(categoryId),
		cityIds: String(cityId),
	},
});

const hasHub = computed(
	() =>
		otherCitiesForCategory.value.length > 0 ||
		otherCategoriesForCity.value.length > 0,
);
</script>

<template>
	<div v-if="hasHub" class="labtests-related-filters">
		<div
			v-if="otherCitiesForCategory.length"
			class="labtests-related-filters__group"
		>
			<h3 class="labtests-related-filters__title">
				{{ t(`lab_test_category_${selectedCategoryId}`) }}
				{{ t('InOtherCities') }}
			</h3>
			<div class="labtests-related-filters__links">
				<NuxtLink
					v-for="cityId in otherCitiesForCategory"
					:key="cityId"
					:to="categoryCityLink(selectedCategoryId!, cityId)"
				>
					{{ t(`city_${cityId}_genitive`) }}
				</NuxtLink>
			</div>
		</div>

		<div
			v-if="otherCategoriesForCity.length"
			class="labtests-related-filters__group"
		>
			<h3 class="labtests-related-filters__title">
				{{ t('OtherCategoriesIn', { city: t(`city_${selectedCityId}_genitive`) }) }}
			</h3>
			<div class="labtests-related-filters__links">
				<NuxtLink
					v-for="categoryId in otherCategoriesForCity"
					:key="categoryId"
					:to="categoryCityLink(categoryId, selectedCityId!)"
				>
					{{ t(`lab_test_category_${categoryId}`) }}
				</NuxtLink>
			</div>
		</div>
	</div>
</template>

<style scoped lang="less">
.labtests-related-filters {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xl);
	margin-top: var(--spacing-2xl);
}

.labtests-related-filters__title {
	margin: 0 0 var(--spacing-md);
	font-size: var(--font-size-md);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-secondary);
}

.labtests-related-filters__links {
	display: flex;
	flex-wrap: wrap;
	gap: var(--spacing-sm);

	a {
		padding: var(--spacing-xs) var(--spacing-md);
		border-radius: var(--border-radius-md);
		background: var(--color-surface-secondary);
		color: var(--color-primary);
		text-decoration: none;
		font-size: var(--font-size-sm);
		transition: background var(--transition-fast);

		&:hover {
			background: var(--color-surface-primary);
			text-decoration: underline;
		}
	}
}
</style>

<i18n lang="json">
{
	"en": { "InOtherCities": "in other cities", "OtherCategoriesIn": "Other lab test categories in {city}" },
	"ru": { "InOtherCities": "в других городах", "OtherCategoriesIn": "Другие категории анализов в {city}" },
	"sr": { "InOtherCities": "u drugim gradovima", "OtherCategoriesIn": "Druge kategorije analiza u {city}" },
	"sr-cyrl": { "InOtherCities": "у другим градовима", "OtherCategoriesIn": "Друге категорије анализа у {city}" },
	"de": { "InOtherCities": "in anderen Städten", "OtherCategoriesIn": "Andere Laborkategorien in {city}" },
	"tr": { "InOtherCities": "diğer şehirlerde", "OtherCategoriesIn": "{city} içindeki diğer tahlil kategorileri" }
}
</i18n>
