<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import cityI18n from '~/i18n/city';
import medicalServiceCategoryI18n from '~/i18n/medical-service-category';
import { combineI18nMessages } from '~/i18n/utils';

// Хаб перелинковки на /services: когда выбрана ровно одна категория —
// ссылки на неё же в других городах; когда выбран ровно один город —
// ссылки на другие категории услуг в этом городе (см.
// docs/audit/seo-2026-07.md, пункт 1b).
const props = defineProps<{
	serviceCategoryIds: number[];
	cityIds: number[];
}>();

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([cityI18n, medicalServiceCategoryI18n]),
});

const { data } = await useFetch('/api/services/category-city-combinations', {
	key: 'services-category-city-combinations',
});

const combinations = computed(
	() => data.value?.categoryCityCombinations ?? [],
);

const selectedCategoryId = computed(() =>
	props.serviceCategoryIds.length === 1 ? props.serviceCategoryIds[0] : null,
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
	name: 'services',
	query: {
		...getRegionalQuery(locale.value),
		serviceCategoryIds: String(categoryId),
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
	<div v-if="hasHub" class="services-related-filters">
		<div
			v-if="otherCitiesForCategory.length"
			class="services-related-filters__group"
		>
			<h3 class="services-related-filters__title">
				{{ t(`medical_service_category_${selectedCategoryId}`) }}
				{{ t('InOtherCities') }}
			</h3>
			<div class="services-related-filters__links">
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
			class="services-related-filters__group"
		>
			<h3 class="services-related-filters__title">
				{{ t('OtherCategoriesIn', { city: t(`city_${selectedCityId}_genitive`) }) }}
			</h3>
			<div class="services-related-filters__links">
				<NuxtLink
					v-for="categoryId in otherCategoriesForCity"
					:key="categoryId"
					:to="categoryCityLink(categoryId, selectedCityId!)"
				>
					{{ t(`medical_service_category_${categoryId}`) }}
				</NuxtLink>
			</div>
		</div>
	</div>
</template>

<style scoped lang="less">
.services-related-filters {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xl);
	margin-top: var(--spacing-2xl);
}

.services-related-filters__title {
	margin: 0 0 var(--spacing-md);
	font-size: var(--font-size-md);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-secondary);
}

.services-related-filters__links {
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
	"en": { "InOtherCities": "in other cities", "OtherCategoriesIn": "Other service categories in {city}" },
	"ru": { "InOtherCities": "в других городах", "OtherCategoriesIn": "Другие категории услуг в {city}" },
	"sr": { "InOtherCities": "u drugim gradovima", "OtherCategoriesIn": "Druge kategorije usluga u {city}" },
	"sr-cyrl": { "InOtherCities": "у другим градовима", "OtherCategoriesIn": "Друге категорије услуга у {city}" },
	"de": { "InOtherCities": "in anderen Städten", "OtherCategoriesIn": "Andere Leistungskategorien in {city}" },
	"tr": { "InOtherCities": "diğer şehirlerde", "OtherCategoriesIn": "{city} içindeki diğer hizmet kategorileri" }
}
</i18n>
