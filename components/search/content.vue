<template>
	<div
		class="search__content"
		v-if="searchParam.length"
		role="listbox"
		:aria-label="t('SearchResults')"
	>
		<div
			class="search__content-block"
			role="group"
			:aria-label="t('MenuItems')"
		>
			<div
				v-for="{ name, text } in matchedMenutItems"
				:key="name"
				class="search__content-line search__content-line-tech clamped-text"
				role="option"
			>
				<NuxtLink
					class="search__content-link link-no-decoration"
					:to="getArticleLink(name)"
				>
					— {{ text }}
				</NuxtLink>
			</div>
		</div>

		<div class="search__content-block" role="group" :aria-label="t('Articles')">
			<div
				v-if="isLoading"
				class="search__content-skeleton-wrapper"
				role="status"
				:aria-label="t('Loading')"
			>
				<el-skeleton :rows="0" animated>
					<template #template>
						<el-skeleton-item
							class="search__content-skeleton"
							variant="text"
							style="width: 30%"
						/>
						<el-skeleton-item
							class="search__content-skeleton"
							variant="text"
							style="width: 80%"
						/>
						<el-skeleton-item
							class="search__content-skeleton"
							variant="text"
							style="width: 50%"
						/>
					</template>
				</el-skeleton>
			</div>

			<template v-else>
				<div
					v-for="article in articles"
					:key="article.id"
					class="search__content-line clamped-text"
					role="option"
				>
					<NuxtLink
						class="search__content-link link-no-decoration"
						:to="article.path"
					>
						{{ article.fullName }}
					</NuxtLink>
				</div>
			</template>
		</div>
		<div
			class="search__content-block"
			role="group"
			:aria-label="t('MoreResults')"
		>
			<div class="search__content-line search__content-line-tech clamped-text">
				<NuxtLink
					class="search__content-link link-no-decoration"
					:to="searchResultsPath"
				>
					→ {{ t('More') }}
				</NuxtLink>
			</div>
		</div>
	</div>
</template>

<script setup lang="ts">
import { refDebounced } from '@vueuse/core';

const props = defineProps({
	searchString: { type: String, default: '' },
	searchResultsPath: { type: Object, default: '' },
});

// const { t } = useI18n();
// const { t: $t } = useI18n({ useScope: 'global' });
// const { getArticleLink } = useRouteUtils();
// const { country } = useCountry();
// const { uiCurrency } = useCurrency();

// function normalizeText(str: string) {
// 	return str
// 		.trim()
// 		.normalize('NFD')
// 		.replace(/[\u0300-\u036f]/g, '')
// 		.toLowerCase();
// }

// const searchParam = computed((): string => {
// 	return props.searchString.trim();
// });

// const searchStringDebounced = refDebounced(searchParam, 300);

// const { pending: isLoading, data } = await useFetch('/api/article/search', {
// 	key: `article-list-search`,
// 	method: 'POST',
// 	body: computed(() => ({
// 		search: searchStringDebounced.value,
// 		pageNumber: 1,
// 		country: country.value,
// 		currency: uiCurrency.value,
// 	})),
// });

// const articles = computed(() => {
// 	if (isLoading.value || !searchParam.value.length) {
// 		return [];
// 	}

// 	if (!searchParam.value) {
// 		return [];
// 	}
// 	const sliced = data.value?.articles.slice(0, 10);

// 	return sliced?.map((article) => {
// 		const menuPath =
// 			categoryLinksMap[article.categoryId as ArticleCategory] ||
// 			'other-other-other';

// 		const nameParts = [];

// 		if (article.brand !== 'unknown') {
// 			nameParts.push(article.brand);
// 		}

// 		if (article.seriesName) {
// 			nameParts.push(article.seriesName);
// 		}

// 		nameParts.push(article.name);

// 		return {
// 			...article,
// 			fullName: nameParts.join(' '),
// 			path: getArticleLink(menuPath, article.id),
// 		};
// 	});
// });
</script>

<style lang="less" scoped>
@import url('~/assets/css/vars.less');

.search__content {
	position: absolute;
	z-index: -1;
	background: white;
	width: 100%;
	border: 1px solid @light-gray-color;
	border-top: 0;
	border-bottom-left-radius: 4px;
	border-bottom-right-radius: 4px;
	padding: @base-offset 0 @base-offset 0;
	box-sizing: border-box;
	max-height: calc(100vh - 60px);
	overflow: auto;

	.search__content-block {
		font-size: 14px;
		border-bottom: 1px solid @light-gray-color;
		padding-bottom: 6px;
		margin-bottom: 6px;

		&:last-child,
		&:empty {
			border-bottom: 0;
			margin-bottom: 0;
		}
	}

	.search__content-skeleton-wrapper {
		box-sizing: border-box;
		pointer-events: none;
		padding: 0 @base-padding;

		.search__content-skeleton {
			height: 18px;
			margin: 4px 0;
		}
	}

	.search__content-line {
		box-sizing: border-box;

		.search__content-link {
			width: 100%;
			display: block;
			padding: 4px @base-padding 4px @base-padding;
			box-sizing: border-box;
		}

		&:hover,
		&:focus {
			background-color: #80f1fb36;
			outline: none;

			a {
				text-decoration: none;
			}
		}

		&.search__content-line-tech {
			text-transform: uppercase;
		}
	}
}

.clamped-text {
	display: -webkit-box; /* Используем flex-контейнер */
	-webkit-box-orient: vertical; /* Устанавливаем направление блоков */
	overflow: hidden; /* Скрываем лишний текст */
	text-overflow: ellipsis; /* Добавляем многоточие */
	-webkit-line-clamp: 2; /* Ограничиваем текст двумя строками */
	line-height: 1.25; /* Интерлиньяж, можно настроить */
	max-height: calc(1.5em * 2); /* Рассчитываем высоту на основе строк */
}
</style>

<i18n lang="json">
{
	"en": {
		"More": "all results",
		"SearchResults": "Search results",
		"MenuItems": "Menu items",
		"Articles": "Articles",
		"MoreResults": "More results",
		"Loading": "Loading search results"
	},
	"ru": {
		"More": "все результаты",
		"SearchResults": "Результаты поиска",
		"MenuItems": "Пункты меню",
		"Articles": "Статьи",
		"MoreResults": "Другие результаты",
		"Loading": "Загрузка результатов поиска"
	},
	"sr": {
		"More": "svi rezultati",
		"SearchResults": "Rezultati pretrage",
		"MenuItems": "Stavke menija",
		"Articles": "Članci",
		"MoreResults": "Više rezultata",
		"Loading": "Učitavanje rezultata pretrage"
	},
	"ba": {
		"More": "svi rezultati",
		"SearchResults": "Rezultati pretrage",
		"MenuItems": "Stavke menija",
		"Articles": "Članci",
		"MoreResults": "Više rezultata",
		"Loading": "Učitavanje rezultata pretrage"
	},
	"me": {
		"More": "svi rezultati",
		"SearchResults": "Rezultati pretrage",
		"MenuItems": "Stavke menija",
		"Articles": "Članci",
		"MoreResults": "Više rezultata",
		"Loading": "Učitavanje rezultata pretrage"
	},
	"de": {
		"More": "alle Ergebnisse",
		"SearchResults": "Suchergebnisse",
		"MenuItems": "Menüpunkte",
		"Articles": "Artikel",
		"MoreResults": "Weitere Ergebnisse",
		"Loading": "Suchergebnisse werden geladen"
	},
	"tr": {
		"More": "tüm sonuçlar",
		"SearchResults": "Arama sonuçları",
		"MenuItems": "Menü öğeleri",
		"Articles": "Makaleler",
		"MoreResults": "Daha fazla sonuç",
		"Loading": "Arama sonuçları yükleniyor"
	}
}
</i18n>
