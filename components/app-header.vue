<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';

const { t } = useI18n();
const { locale } = useI18n({ useScope: 'global' });

const mainPageLink = computed(() => ({
	name: 'doctors',
	query: getRegionalQuery(locale.value),
}));

const clinicsPageLink = computed(() => ({
	name: 'clinics',
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

				<nav class="app-header__nav">
					<NuxtLink class="app-header__nav-link" :to="mainPageLink">
						{{ t('Doctors') }}
					</NuxtLink>
					<NuxtLink class="app-header__nav-link" :to="clinicsPageLink">
						{{ t('Clinics') }}
					</NuxtLink>
				</nav>

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
		"GoToMainPage": "Go to main page",
		"Doctors": "Doctors",
		"Clinics": "Clinics"
	},
	"ru": {
		"GoToMainPage": "Перейти на главную страницу",
		"Doctors": "Врачи",
		"Clinics": "Клиники"
	},
	"sr": {
		"GoToMainPage": "Idi na početnu stranicu",
		"Doctors": "Lekari",
		"Clinics": "Klinike"
	},
	"ba": {
		"GoToMainPage": "Idi na početnu stranicu",
		"Doctors": "Ljekari",
		"Clinics": "Klinike"
	},
	"me": {
		"GoToMainPage": "Idi na početnu stranicu",
		"Doctors": "Lekari",
		"Clinics": "Klinike"
	},
	"de": {
		"GoToMainPage": "Zur Startseite gehen",
		"Doctors": "Ärzte",
		"Clinics": "Kliniken"
	},
	"tr": {
		"GoToMainPage": "Ana sayfaya git",
		"Doctors": "Doktorlar",
		"Clinics": "Klinikler"
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

	&__nav {
		display: flex;
		align-items: center;
		gap: var(--spacing-lg);
		flex: 1;
		margin-left: var(--spacing-lg);
	}

	&__nav-link {
		font-size: var(--font-size-md);
		font-weight: 500;
		color: #4b5563;
		text-decoration: none;
		transition: color 0.2s ease;
		white-space: nowrap;

		&:hover {
			color: #4f46e5;
		}

		&.router-link-active {
			color: #4f46e5;
			font-weight: 600;
		}
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

		&__nav {
			gap: var(--spacing-md);
			margin-left: var(--spacing-md);
		}

		&__nav-link {
			font-size: var(--font-size-sm);
		}
	}
}

@media only screen and (max-width: 500px) {
	.app-header {
		&__main-content {
			padding: 0 @base-offset;
		}

		&__nav {
			gap: var(--spacing-sm);
			margin-left: var(--spacing-sm);
		}
	}
}
</style>
