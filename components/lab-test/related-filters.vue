<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import cityI18n from '~/i18n/city';
import labTestCategoryI18n from '~/i18n/labtest-category';
import { combineI18nMessages } from '~/i18n/utils';

// Хаб перелинковки на /labtests. Источник комбинаций — тот же запрос, что и у
// sitemap-фильтра (см. docs/audit/seo-2026-07.md, пункт 1b), поэтому ни одна
// ссылка отсюда не ведёт на пустой листинг с `noindex`.
//
// Три режима, в зависимости от того, что выбрано:
// 1. Ничего не выбрано (голый /labtests) — топ категорий. Раньше блок здесь
//    молчал, и в фасетную сеть неоткуда было войти: панель фильтров — чекбоксы,
//    а не ссылки, поэтому фасетные URL из sitemap не имели ни одной входящей
//    ссылки и весь внутренний вес уходил в футер.
// 2. Выбрана ровно одна категория — она же в других городах.
// 3. Выбран ровно один город — другие категории в этом городе.
// Режимы 2 и 3 совмещаются, когда выбрано и то и другое.
const props = defineProps<{
	categoryIds: number[];
	cityIds: number[];
}>();

// Сколько ссылок показываем на голом листинге. Полный список категорий уже
// стоит рядом в панели фильтров — выкладывать все 24 значками значило бы
// продублировать её ковром ссылок. Хаб — короткий срез «самое ходовое», а не
// второй фильтр; в фасетную сеть достаточно одной двери, дальше работают
// режимы 2 и 3.
const HUB_LINK_LIMIT = 12;

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([cityI18n, labTestCategoryI18n]),
});

const { data } = await useFetch('/api/labtests/category-city-combinations', {
	key: 'labtests-category-city-combinations',
});

const combinations = computed(() => data.value?.categoryCityCombinations ?? []);

const selectedCategoryId = computed(() =>
	props.categoryIds.length === 1 ? props.categoryIds[0] : null,
);
const selectedCityId = computed(() =>
	props.cityIds.length === 1 ? props.cityIds[0] : null,
);

// Голый листинг — ни категории, ни города. Другие фильтры (поиск, код тарифа)
// на выбор среза не влияют: ссылки всё равно ведут на чистые фасеты.
const isUnfiltered = computed(
	() => props.categoryIds.length === 0 && props.cityIds.length === 0,
);

/**
 * Топ категорий для голого листинга.
 *
 * Ранжируем по числу городов, где категория вообще представлена. Счётчика
 * анализов эндпоинт не отдаёт, а география — честный прокси востребованности:
 * категория, которая есть по всей стране, полезна читателю из любого города,
 * и её фасет заведомо не тонкая страница. При равенстве — меньший id enum'а:
 * там перечислены основные категории, редкие добавлялись позже.
 */
const categoryCityCount = computed(() => {
	const counts = new Map<number, number>();
	for (const combo of combinations.value) {
		counts.set(combo.categoryId, (counts.get(combo.categoryId) ?? 0) + 1);
	}
	return counts;
});

const topCategories = computed(() => {
	if (!isUnfiltered.value) return [];
	return [...categoryCityCount.value.entries()]
		.sort((a, b) => b[1] - a[1] || a[0] - b[0])
		.slice(0, HUB_LINK_LIMIT)
		.map(([categoryId]) => categoryId);
});

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

// Ссылка на категорию без города: и человеку — способ расширить поиск на всю
// страну, и краулеру — единственный вход на `?categoryIds=N` с фасетной
// страницы. Без неё в sitemap оставались бы недостижимы все категории,
// не попавшие в топ голого листинга.
const categoryLink = (categoryId: number) => ({
	name: 'labtests',
	query: {
		...getRegionalQuery(locale.value),
		categoryIds: String(categoryId),
	},
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
		topCategories.value.length > 0 ||
		otherCitiesForCategory.value.length > 0 ||
		otherCategoriesForCity.value.length > 0,
);
</script>

<template>
	<div v-if="hasHub" class="labtests-related-filters">
		<div v-if="topCategories.length" class="labtests-related-filters__group">
			<h3 class="labtests-related-filters__title">
				{{ t('PopularCategories') }}
			</h3>
			<div class="labtests-related-filters__links">
				<NuxtLink
					v-for="categoryId in topCategories"
					:key="categoryId"
					:to="categoryLink(categoryId)"
				>
					{{ t(`lab_test_category_${categoryId}`) }}
				</NuxtLink>
			</div>
		</div>

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
					v-if="selectedCityId !== null"
					:to="categoryLink(selectedCategoryId!)"
				>
					{{ t('AllCities') }}
				</NuxtLink>
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
				{{
					t('OtherCategoriesIn', { city: t(`city_${selectedCityId}_genitive`) })
				}}
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
	gap: var(--kit-spacing-xl);
	margin-top: var(--kit-spacing-2xl);
}

.labtests-related-filters__title {
	margin: 0 0 var(--kit-spacing-md);
	font-size: var(--kit-font-size-md);
	font-weight: var(--kit-font-weight-semibold);
	color: var(--kit-color-text-secondary);
}

.labtests-related-filters__links {
	display: flex;
	flex-wrap: wrap;
	gap: var(--kit-spacing-sm);

	a {
		padding: var(--kit-spacing-xs) var(--kit-spacing-md);
		border-radius: var(--kit-border-radius-md);
		background: var(--kit-color-surface-secondary);
		color: var(--kit-color-primary);
		text-decoration: none;
		font-size: var(--kit-font-size-sm);
		transition: background var(--kit-transition-fast);

		&:hover {
			background: var(--kit-color-surface-primary);
			text-decoration: underline;
		}
	}
}
</style>

<i18n lang="json">
{
	"en": {
		"InOtherCities": "in other cities",
		"OtherCategoriesIn": "Other lab test categories in {city}",
		"PopularCategories": "Popular lab test categories",
		"AllCities": "In all cities"
	},
	"ru": {
		"InOtherCities": "в других городах",
		"OtherCategoriesIn": "Другие категории анализов в {city}",
		"PopularCategories": "Популярные категории анализов",
		"AllCities": "Во всех городах"
	},
	"sr": {
		"InOtherCities": "u drugim gradovima",
		"OtherCategoriesIn": "Druge kategorije analiza u {city}",
		"PopularCategories": "Popularne kategorije analiza",
		"AllCities": "U svim gradovima"
	},
	"sr-cyrl": {
		"InOtherCities": "у другим градовима",
		"OtherCategoriesIn": "Друге категорије анализа у {city}",
		"PopularCategories": "Популарне категорије анализа",
		"AllCities": "У свим градовима"
	},
	"de": {
		"InOtherCities": "in anderen Städten",
		"OtherCategoriesIn": "Andere Laborkategorien in {city}",
		"PopularCategories": "Beliebte Laborkategorien",
		"AllCities": "In allen Städten"
	},
	"tr": {
		"InOtherCities": "diğer şehirlerde",
		"OtherCategoriesIn": "{city} içindeki diğer tahlil kategorileri",
		"PopularCategories": "Popüler tahlil kategorileri",
		"AllCities": "Tüm şehirlerde"
	}
}
</i18n>
