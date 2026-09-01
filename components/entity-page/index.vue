<script setup lang="ts">
import IconBack from '~/components/icon/back.vue';
import { getRegionalQuery } from '~/common/url-utils';
import { useFiltersStore, type FilterNamespace } from '~/stores/filters';
import type { TabItem } from './tab-bar.vue';

const props = defineProps<{
	isLoading: boolean;
	isFound: boolean;
	backRouteName: FilterNamespace;
	loadingText: string;
	notFoundText: string;
	tabs: TabItem[];
}>();

const { t, locale } = useI18n();
const router = useRouter();
const filtersStore = useFiltersStore();

const backToSearch = () => {
	router.push({
		name: props.backRouteName,
		query: {
			...filtersStore.getRouteParams(props.backRouteName).query,
			...getRegionalQuery(locale.value),
		},
	});
};
</script>

<template>
	<div
		class="entity-page"
		:class="{ 'entity-page--with-nav': isFound && tabs.length > 1 }"
		role="main"
		:aria-label="t('AriaMainContent')"
	>
		<nav class="entity-page__back" :aria-label="t('AriaBackToSearch')">
			<el-button @click="backToSearch()" :icon="IconBack">
				{{ t('ToSearchPage') }}
			</el-button>
		</nav>

		<div
			v-if="isLoading"
			class="entity-page__loading"
			role="status"
			aria-live="polite"
		>
			<div class="entity-page__spinner" aria-hidden="true"></div>
			<p>{{ loadingText }}</p>
		</div>

		<div v-else-if="isFound" class="entity-page__layout">
			<div class="entity-page__hero">
				<slot name="hero" />
			</div>

			<ClientOnly>
				<EntityPageTabBar
					v-if="tabs.length > 1"
					:tabs="tabs"
					class="entity-page__nav"
				/>
				<!-- Мобильный вариант таб-бара — sticky, то есть занимает место в
				     потоке. Без заглушки серверная разметка его не содержит, и
				     после гидратации между героблоком и телом вставляется полоса,
				     сдвигая весь контент вниз. Заглушка держит ту же высоту
				     (кнопка + вертикальные отступы полосы). На десктопе полоса
				     display:none, поэтому заглушка тоже скрыта. -->
				<template #fallback>
					<div
						v-if="tabs.length > 1"
						class="entity-page__nav entity-page__nav-placeholder"
						aria-hidden="true"
					></div>
				</template>
			</ClientOnly>

			<div class="entity-page__body">
				<slot name="sections" />
			</div>
		</div>

		<div v-else class="entity-page__not-found" role="status" aria-live="polite">
			<p>{{ notFoundText }}</p>
		</div>
	</div>
</template>

<style lang="less" scoped>
.entity-page {
	box-sizing: border-box;
	max-width: 900px;
	margin: 0 auto;
	width: 100%;
	padding: 0 var(--kit-spacing-md);
}

.entity-page__back {
	padding: var(--kit-spacing-md) 0;
}

.entity-page__hero {
	margin-bottom: 0;
}

.entity-page__body {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-2xl);
	padding: var(--kit-spacing-2xl) 0;
}

/* Повторяет коробку .section-nav__mobile из tab-bar.vue: отступы полосы,
   рамка снизу и высота кнопки — её вертикальные отступы, рамка и строка
   текста в var(--kit-font-size-sm). Считаем токенами, а не готовыми пикселями,
   чтобы правка отступов в теме не рассинхронизировала заглушку с баром. */
.entity-page__nav-placeholder {
	box-sizing: border-box;
	padding: var(--kit-spacing-sm) 0;
	border-bottom: 1px solid var(--kit-color-border-light);

	&::before {
		content: '';
		display: block;
		height: calc(
			2 * var(--kit-spacing-sm) + 2px + var(--kit-font-size-sm) * 1.2
		);
	}
}

/* Широкие экраны: навигация по секциям выносится в левый рельс вне колонки
   контента. Рельс (грид-область nav) охватывает высоту hero+body, поэтому
   sticky-список внутри него прокручивается вместе со страницей. */
@media (min-width: 1024px) {
	.entity-page--with-nav {
		max-width: 1152px; /* 220 рельс + 32 gap + ~900 контент */
	}

	.entity-page--with-nav .entity-page__layout {
		display: grid;
		grid-template-columns: 220px minmax(0, 1fr);
		column-gap: var(--kit-spacing-2xl);
		grid-template-areas:
			'nav hero'
			'nav body';
	}

	.entity-page--with-nav .entity-page__hero {
		grid-area: hero;
	}

	.entity-page--with-nav .entity-page__nav {
		grid-area: nav;
	}

	.entity-page--with-nav .entity-page__body {
		grid-area: body;
	}

	/* На десктопе мобильной полосы нет — рельс стоит в отдельной колонке
	   грида и сдвига не даёт, резервировать нечего. */
	.entity-page__nav-placeholder {
		display: none;
	}
}

@media (max-width: 500px) {
	.entity-page {
		padding: 0 var(--kit-spacing-sm);
	}

	.entity-page__body {
		gap: var(--kit-spacing-lg);
		padding: var(--kit-spacing-lg) 0;
	}
}

.entity-page__loading {
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	padding: 40px;
	color: var(--kit-color-text-muted);
}

.entity-page__spinner {
	width: 40px;
	height: 40px;
	border: 3px solid var(--kit-color-border-secondary);
	border-top: 3px solid var(--kit-color-primary);
	border-radius: 50%;
	animation: spin 1s linear infinite;
	margin-bottom: 16px;
}

@keyframes spin {
	0% {
		transform: rotate(0deg);
	}
	100% {
		transform: rotate(360deg);
	}
}

.entity-page__not-found {
	padding: 40px;
	text-align: center;
	color: var(--kit-color-text-muted);
}
</style>

<i18n lang="json">
{
	"en": {
		"ToSearchPage": "Back to search",
		"AriaMainContent": "Main content",
		"AriaBackToSearch": "Back to search results"
	},
	"ru": {
		"ToSearchPage": "К поиску",
		"AriaMainContent": "Основное содержимое",
		"AriaBackToSearch": "Вернуться к результатам поиска"
	},
	"de": {
		"ToSearchPage": "Zurück zur Suche",
		"AriaMainContent": "Hauptinhalt",
		"AriaBackToSearch": "Zurück zu den Suchergebnissen"
	},
	"tr": {
		"ToSearchPage": "Aramaya geri dön",
		"AriaMainContent": "Ana içerik",
		"AriaBackToSearch": "Arama sonuçlarına dön"
	},
	"sr": {
		"ToSearchPage": "Nazad na pretragu",
		"AriaMainContent": "Glavni sadržaj",
		"AriaBackToSearch": "Nazad na rezultate pretrage"
	},
	"sr-cyrl": {
		"ToSearchPage": "Назад на претрагу",
		"AriaMainContent": "Главни садржај",
		"AriaBackToSearch": "Назад на резултате претраге"
	}
}
</i18n>
