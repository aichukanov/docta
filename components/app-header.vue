<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';

const { t } = useI18n();
const { locale } = useI18n({ useScope: 'global' });

const mainPageLink = computed(() => ({
	name: 'doctors',
	query: getRegionalQuery(locale.value),
}));
</script>

<template>
	<header class="app-header">
		<div class="app-header__main">
			<div class="app-header__main-content">
				<NuxtLink
					class="app-header__brand"
					:to="mainPageLink"
					:aria-label="t('GoToMainPage')"
				>
					<div class="app-header__logo"></div>
				</NuxtLink>

				<div class="app-header__actions">
					<LanguageSwitcher />
				</div>
			</div>
		</div>
	</header>
</template>

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
	z-index: var(--z-header);
	background: white;
	border-bottom: 1px solid @light-gray-color;
	transition: all 0.3s ease;

	&__main {
		width: 100%;
	}

	&__main-content {
		display: flex;
		align-items: center;
		justify-content: space-between;
		height: 60px;
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
		width: 120px;
		height: 30px;
		background-image: url('/logo-site.png');
		background-size: contain;
		background-repeat: no-repeat;
		background-position: center;
		flex-shrink: 0;
	}

	&__actions {
		display: flex;
		align-items: center;
		gap: @base-offset;
		flex-shrink: 0;
	}
}

@media only screen and (max-width: 700px) {
	.app-header {
		&__main-content {
			height: 50px;
			gap: var(--spacing-md);
		}
	}
}

@media only screen and (max-width: 500px) {
	.app-header {
		&__main-content {
			padding: 0 @base-offset;
		}
	}
}
</style>
