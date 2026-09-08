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

// Видимые крошки из той же BreadcrumbList, которую страница уже отдала в
// разметку: раньше её отдавали все карточки, а крошек не было ни на одной.
// Тот же источник использует ListPage — обоснование в самом composable.
const breadcrumbs = useSchemaBreadcrumbs();

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
		<div class="entity-page__topbar">
			<AppBreadcrumbs
				v-if="isFound && breadcrumbs.length"
				class="entity-page__breadcrumbs"
				:items="breadcrumbs"
				:aria-label="t('AriaBreadcrumbs')"
			/>

			<nav class="entity-page__back" :aria-label="t('AriaBackToSearch')">
				<el-button
					link
					type="primary"
					:icon="IconBack"
					:aria-label="t('AriaBackToSearch')"
					@click="backToSearch()"
				>
					{{ t('ToSearchPage') }}
				</el-button>
			</nav>
		</div>

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

/* Крошки и «к результатам» — одна служебная строка над героем: крошки слева,
   ссылка справа. Это не дубль: крошка ведёт на чистый листинг раздела, а
   ссылка возвращает к листингу с фильтрами, которые человек выбирал.
   Верхний отступ тот же, что у листингов (.list-sidebar в list-page.vue),
   иначе разделы разъезжаются по вертикали. */
.entity-page__topbar {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: var(--kit-spacing-lg);
	min-height: 40px;
	padding: var(--kit-spacing-lg) 0 var(--kit-spacing-md);
}

.entity-page__breadcrumbs {
	min-width: 0;
}

/* Без крошек (загрузка, 404) ссылка всё равно остаётся справа. */
.entity-page__back {
	margin-left: auto;
	flex: none;
}

/* На узких экранах подпись не помещается рядом с крошками — остаётся одна
   стрелка, и она встаёт перед крошками, как кнопка «назад» в мобильных
   шапках. Подпись остаётся в aria-label кнопки. */
@media (max-width: 640px) {
	.entity-page__topbar {
		justify-content: flex-start;
		gap: var(--kit-spacing-sm);
	}

	.entity-page__back {
		order: -1;
		margin-left: calc(-1 * var(--kit-spacing-sm));
	}

	.entity-page__back :deep(.el-button) {
		width: 32px;
		height: 32px;
		justify-content: center;
	}

	.entity-page__back :deep(.el-icon) {
		margin: 0;
	}

	/* Обёртка слота от Element Plus: у неё свой отступ от иконки, поэтому
	   пряча подпись, прячем обёртку целиком. */
	.entity-page__back :deep(.el-button > span) {
		display: none;
	}
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
		"ToSearchPage": "Back to results",
		"AriaMainContent": "Main content",
		"AriaBackToSearch": "Back to search results",
		"AriaBreadcrumbs": "Breadcrumbs"
	},
	"ru": {
		"ToSearchPage": "К результатам поиска",
		"AriaMainContent": "Основное содержимое",
		"AriaBackToSearch": "Вернуться к результатам поиска",
		"AriaBreadcrumbs": "Хлебные крошки"
	},
	"de": {
		"ToSearchPage": "Zurück zu den Ergebnissen",
		"AriaMainContent": "Hauptinhalt",
		"AriaBackToSearch": "Zurück zu den Suchergebnissen",
		"AriaBreadcrumbs": "Brotkrümelnavigation"
	},
	"tr": {
		"ToSearchPage": "Sonuçlara dön",
		"AriaMainContent": "Ana içerik",
		"AriaBackToSearch": "Arama sonuçlarına dön",
		"AriaBreadcrumbs": "Site haritası yolu"
	},
	"sr": {
		"ToSearchPage": "Nazad na rezultate",
		"AriaMainContent": "Glavni sadržaj",
		"AriaBackToSearch": "Nazad na rezultate pretrage",
		"AriaBreadcrumbs": "Putanja navigacije"
	},
	"sr-cyrl": {
		"ToSearchPage": "Назад на резултате",
		"AriaMainContent": "Главни садржај",
		"AriaBackToSearch": "Назад на резултате претраге",
		"AriaBreadcrumbs": "Путања навигације"
	}
}
</i18n>
