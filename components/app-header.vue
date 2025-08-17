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

				<!-- Центральная часть - поиск (только в компактном режиме) -->
				<div class="app-header__search-compact" v-if="!isExpanded">
					<SearchBar compact @search="handleSearch" />
				</div>

				<!-- Правая часть - переключатель языка -->
				<div class="app-header__actions">
					<LanguageSwitcher />
				</div>
			</div>
		</div>

		<!-- Расширенная часть (табы + поиск) -->
		<div class="app-header__expanded" v-if="isExpanded">
			<CategoryTabs @category-change="handleCategoryChange" />
			<SearchBar @search="handleSearch" />
		</div>

		<!-- Кнопка переключения состояния -->
		<button
			class="app-header__toggle"
			@click="toggleExpanded"
			:aria-label="isExpanded ? t('CollapseSearch') : t('ExpandSearch')"
		>
			<svg
				class="app-header__toggle-icon"
				:class="{ 'app-header__toggle-icon--expanded': isExpanded }"
				viewBox="0 0 24 24"
				fill="none"
			>
				<path
					d="M6 9L12 15L18 9"
					stroke="currentColor"
					stroke-width="2"
					stroke-linecap="round"
					stroke-linejoin="round"
				/>
			</svg>
		</button>
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

const isExpanded = ref(false);

const mainPageLink = computed(() => ({
	name: 'index',
	query: getRegionalQuery(country.value, locale.value, uiCurrency.value),
}));

const toggleExpanded = () => {
	isExpanded.value = !isExpanded.value;
};

const handleCategoryChange = (category: string) => {
	console.log('Category changed:', category);
	// TODO: Implement category change logic
};

const handleSearch = () => {
	console.log('Search triggered');
	// TODO: Implement search logic
};
</script>

<i18n lang="json">
{
	"en": {
		"GoToMainPage": "Go to main page",
		"CollapseSearch": "Collapse search",
		"ExpandSearch": "Expand search"
	},
	"ru": {
		"GoToMainPage": "Перейти на главную страницу",
		"CollapseSearch": "Свернуть поиск",
		"ExpandSearch": "Развернуть поиск"
	},
	"sr": {
		"GoToMainPage": "Idi na početnu stranicu",
		"CollapseSearch": "Smanji pretragu",
		"ExpandSearch": "Proširi pretragu"
	},
	"ba": {
		"GoToMainPage": "Idi na početnu stranicu",
		"CollapseSearch": "Smanji pretragu",
		"ExpandSearch": "Proširi pretragu"
	},
	"me": {
		"GoToMainPage": "Idi na početnu stranicu",
		"CollapseSearch": "Smanji pretragu",
		"ExpandSearch": "Proširi pretragu"
	},
	"de": {
		"GoToMainPage": "Zur Startseite gehen",
		"CollapseSearch": "Suche reduzieren",
		"ExpandSearch": "Suche erweitern"
	},
	"tr": {
		"GoToMainPage": "Ana sayfaya git",
		"CollapseSearch": "Aramayı daralt",
		"ExpandSearch": "Aramayı genişlet"
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

	&__search-compact {
		flex: 1;
		max-width: 600px;
		margin: 0 @base-padding;
	}

	&__actions {
		display: flex;
		align-items: center;
		gap: @base-offset;
		flex-shrink: 0;
	}

	&__expanded {
		border-top: 1px solid @light-gray-color;
		background: #fafafa;
		padding: @base-padding 0;
	}

	&__toggle {
		position: absolute;
		bottom: -16px;
		left: 50%;
		transform: translateX(-50%);
		width: 32px;
		height: 32px;
		border: 1px solid @light-gray-color;
		background: white;
		border-radius: 50%;
		display: flex;
		align-items: center;
		justify-content: center;
		cursor: pointer;
		transition: all 0.2s ease;
		box-shadow: 0 2px 4px rgba(0, 0, 0, 0.08);

		&:hover {
			background: #f8f9fa;
			box-shadow: 0 4px 8px rgba(0, 0, 0, 0.12);
		}
	}

	&__toggle-icon {
		width: 16px;
		height: 16px;
		color: @dark-gray-color;
		transition: transform 0.2s ease;

		&--expanded {
			transform: rotate(180deg);
		}
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

		&__search-compact {
			margin: 0 @base-offset;
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

		&__search-compact {
			margin: 0 @base-offset;
		}
	}
}
</style>
