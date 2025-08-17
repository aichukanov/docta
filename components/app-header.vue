<template>
	<header class="app-header" :class="{ 'app-header--expanded': isExpanded }">
		<!-- Основная строка хедера -->
		<div class="app-header__main">
			<div class="app-header__main-content">
				<!-- Левая часть - логотип и название -->
				<NuxtLink
					class="app-header__brand"
					:to="mainPageLink"
					:aria-label="t('GoToMainPage')"
				>
					<div class="app-header__logo"></div>
					<div class="app-header__brand-text">docta.me</div>
				</NuxtLink>

				<!-- Центральная часть -->
				<div class="app-header__center">
					<!-- Поиск в компактном режиме -->
					<div class="app-header__search-compact" v-if="!isExpanded">
						<SearchBar compact @search="handleSearch" />
					</div>

					<!-- Табы категорий в расширенном режиме -->
					<div class="app-header__category-tabs" v-if="isExpanded">
						<CategoryTabs @category-change="handleCategoryChange" />
					</div>
				</div>

				<!-- Правая часть - переключатель языка -->
				<div class="app-header__actions">
					<LanguageSwitcher />
				</div>
			</div>
		</div>

		<!-- Расширенная часть (только поиск) -->
		<div class="app-header__expanded" v-if="isExpanded">
			<SearchBar flat @search="handleSearch" />
		</div>
	</header>
</template>

<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import CategoryTabs from '~/components/app-header/category-tabs.vue';
import SearchBar from '~/components/app-header/search-bar.vue';

const { t } = useI18n();
const { country } = useCountry();
const { locale } = useI18n({ useScope: 'global' });
const { uiCurrency } = useCurrency();

// Используем filters composable
const { isExpanded, setCategory } = useFilters();

const mainPageLink = computed(() => ({
	name: 'index',
	query: getRegionalQuery(country.value, locale.value, uiCurrency.value),
}));

const handleCategoryChange = (category: 'doctors' | 'pharmacies') => {
	setCategory(category);
};

const handleSearch = () => {
	console.log('Search triggered');
	// TODO: Implement search logic
};
</script>

<i18n lang="json">
{
	"en": {
		"GoToMainPage": "Go to main page"
	},
	"ru": {
		"GoToMainPage": "Перейти на главную страницу"
	},
	"sr": {
		"GoToMainPage": "Idi na početnu stranicu"
	},
	"ba": {
		"GoToMainPage": "Idi na početnu stranicu"
	},
	"me": {
		"GoToMainPage": "Idi na početnu stranicu"
	},
	"de": {
		"GoToMainPage": "Zur Startseite gehen"
	},
	"tr": {
		"GoToMainPage": "Ana sayfaya git"
	}
}
</i18n>

<style lang="less" scoped>
@import url('~/assets/css/vars.less');

.app-header {
	position: sticky;
	top: 0;
	z-index: 999;
	background: white;
	border-bottom: 1px solid @light-gray-color;
	transition: all 0.3s ease;

	&--expanded {
		box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
	}

	&__main {
		width: 100%;
	}

	&__main-content {
		display: flex;
		align-items: center;
		justify-content: space-between;
		height: 80px;
		gap: @base-padding;
		padding: 0 @base-padding;
		box-sizing: border-box;
	}

	&__brand {
		display: flex;
		align-items: center;
		text-decoration: none;
		color: inherit;
		gap: 12px;
		flex-shrink: 0;
		transition: opacity 0.2s ease;

		&:hover {
			opacity: 0.8;
		}
	}

	&__logo {
		width: 40px;
		height: 40px;
		background-image: url('/logo-site.png');
		background-size: contain;
		background-repeat: no-repeat;
		background-position: center;
		flex-shrink: 0;
	}

	&__brand-text {
		font-size: 24px;
		font-weight: 700;
		color: @primary-color;
		white-space: nowrap;
	}

	&__center {
		flex: 1;
		display: flex;
		justify-content: center;
		align-items: center;
		margin: 0 @base-padding;
	}

	&__search-compact {
		width: 100%;
		max-width: 600px;
	}

	&__category-tabs {
		display: flex;
		justify-content: center;
		align-items: center;

		:deep(.category-tabs) {
			padding: 0;
		}
	}

	&__actions {
		display: flex;
		align-items: center;
		gap: @base-offset;
		flex-shrink: 0;
	}

	&__expanded {
		padding: @base-offset 0 @base-padding 0;
	}
}

@media only screen and (max-width: 1200px) {
	.app-header {
		&__search-compact {
			max-width: 500px;
		}
	}
}

@media only screen and (max-width: 900px) {
	.app-header {
		&__main-content {
			height: 70px;
		}

		&__brand-text {
			font-size: 20px;
		}

		&__center {
			margin: 0 @base-offset;
		}

		&__search-compact {
			max-width: 400px;
		}
	}
}

@media only screen and (max-width: 700px) {
	.app-header {
		&__main-content {
			height: 60px;
			gap: @base-offset;
		}

		&__brand-text {
			font-size: 18px;
		}

		&__logo {
			width: 32px;
			height: 32px;
		}

		&__center {
			margin: 0 @base-offset / 2;
		}

		&__search-compact {
			margin: 0;
		}
	}
}

@media only screen and (max-width: 500px) {
	.app-header {
		&__main-content {
			padding: 0 @base-offset;
		}

		&__brand-text {
			display: none;
		}

		&__center {
			margin: 0;
		}

		&__search-compact {
			margin: 0;
		}
	}
}
</style>
