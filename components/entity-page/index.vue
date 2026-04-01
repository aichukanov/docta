<script setup lang="ts">
import { ArrowLeft } from '@element-plus/icons-vue';
import { getRegionalQuery } from '~/common/url-utils';
import type { TabItem } from './tab-bar.vue';

const props = defineProps<{
	isLoading: boolean;
	isFound: boolean;
	backRouteName: string;
	loadingText: string;
	notFoundText: string;
	tabs: TabItem[];
}>();

const { t, locale } = useI18n();
const router = useRouter();
const { getRouteParams } = useFilters();

const backToSearch = () => {
	router.push({
		name: props.backRouteName,
		query: { ...getRouteParams().query, ...getRegionalQuery(locale.value) },
	});
};
</script>

<template>
	<div class="entity-page" role="main" :aria-label="t('AriaMainContent')">
		<nav class="entity-page__back" :aria-label="t('AriaBackToSearch')">
			<el-button @click="backToSearch()" :icon="ArrowLeft">
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

		<template v-else-if="isFound">
			<div class="entity-page__hero">
				<slot name="hero" />
			</div>

			<ClientOnly>
				<EntityPageTabBar v-if="tabs.length > 1" :tabs="tabs" />
			</ClientOnly>

			<div class="entity-page__body">
				<slot name="sections" />
			</div>
		</template>

		<div v-else class="entity-page__not-found" role="status" aria-live="polite">
			<p>{{ notFoundText }}</p>
		</div>
	</div>
</template>

<style lang="less" scoped>
.entity-page {
	max-width: 900px;
	margin: 0 auto;
	width: 100%;
	padding: 0 var(--spacing-md);
}

.entity-page__back {
	padding: var(--spacing-md) 0;
}

.entity-page__hero {
	margin-bottom: 0;
}

.entity-page__body {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-2xl);
	padding: var(--spacing-2xl) 0;
}

@media (max-width: 500px) {
	.entity-page {
		padding: 0 var(--spacing-sm);
	}

	.entity-page__body {
		gap: var(--spacing-lg);
		padding: var(--spacing-lg) 0;
	}
}

.entity-page__loading {
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	padding: 40px;
	color: #6b7280;
}

.entity-page__spinner {
	width: 40px;
	height: 40px;
	border: 3px solid #e5e7eb;
	border-top: 3px solid #4f46e5;
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
	color: #6b7280;
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
