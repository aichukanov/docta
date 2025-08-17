<template>
	<div class="layout-wrapper">
		<AppHeader />

		<div class="layout-body">
			<BreadCrumbs />
			<slot />
		</div>

		<div class="footer" :class="{ 'footer-tall': !isConsentGiven }">
			<div class="footer-content">
				<div>docta.me | {{ years }}</div>

				<div class="contact-us_wrapper">
					<NuxtLink
						to="mailto:contact@svad.net"
						target="_blank"
						:aria-label="t('ContactUs')"
					>
						<div class="icon email-icon"></div>
					</NuxtLink>
					<NuxtLink
						to="https://t.me/svad_net"
						target="_blank"
						:aria-label="t('NewsChannel')"
					>
						<div class="icon tg-icon"></div>
					</NuxtLink>
				</div>
			</div>
		</div>

		<ClientOnly>
			<CookieBanner v-if="!isConsentGiven" />
			<CookieModal />
		</ClientOnly>
	</div>
</template>

<script setup lang="ts">
const { isConsentGiven } = useCookieControl();
const { t } = useI18n();

const years = computed(() => `2025 - ${new Date().getFullYear()}`);

watch(
	isConsentGiven,
	() => {
		if (isConsentGiven.value) {
			const { initMixpanel, initCloudflare, initGTag } = useAnalytics();
			initMixpanel();
			initCloudflare();
			initGTag();
		}
	},
	{ immediate: true },
);
</script>

<i18n lang="json">
{
	"en": {
		"ContactUs": "Contact us by email",
		"NewsChannel": "Our news channel on Telegram"
	},
	"ru": {
		"ContactUs": "Связаться с нами по email",
		"NewsChannel": "Наш канал новостей в Telegram"
	},
	"sr": {
		"ContactUs": "Kontaktirajte nas putem emaila",
		"NewsChannel": "Naš kanal za vesti na Telegramu"
	},
	"ba": {
		"ContactUs": "Kontaktirajte nas putem emaila",
		"NewsChannel": "Naš kanal za vijesti na Telegramu"
	},
	"me": {
		"ContactUs": "Kontaktirajte nas putem emaila",
		"NewsChannel": "Naš kanal za vijesti na Telegramu"
	},
	"de": {
		"ContactUs": "Kontaktieren Sie uns per E-Mail",
		"NewsChannel": "Unser Nachrichtenkanal auf Telegram"
	},
	"tr": {
		"ContactUs": "Bize e-posta ile ulaşın",
		"NewsChannel": "Telegram'daki haber kanalımız"
	}
}
</i18n>

<style lang="less">
@import url('~/assets/css/vars.less');

:root {
	// Element Plus primary colors override
	--el-color-primary: #2b32f7;
	--el-color-primary-light-3: #5a5ff9;
	--el-color-primary-light-5: #7983fa;
	--el-color-primary-light-7: #9da6fb;
	--el-color-primary-light-8: #b1b8fc;
	--el-color-primary-light-9: #c5cafd;
	--el-color-primary-dark-2: #080eb4;
}

html,
body {
	margin: 0;
}

body {
	width: 100%;
	background-color: @base-bg-color;
	font-family: system-ui;
	overflow-x: hidden;
	overflow-y: auto;
	scrollbar-gutter: stable;
}

.footer {
	display: flex;
	align-items: center;
	justify-content: center;
	margin-top: 16px;
	margin-bottom: 50px;

	&.footer-tall {
		margin-bottom: 80vh;
	}

	.footer-content {
		box-sizing: border-box;
		flex-basis: 100%;
		border-top: 1px solid #e0e0e0;
		padding: 16px;
		min-width: 300px;
		max-width: @max-width;
		display: flex;
		align-items: center;
		justify-content: space-between;

		.contact-us_wrapper {
			display: flex;
			gap: 8px;
		}

		.icon {
			width: 24px;
			height: 24px;
			background-size: contain;
			background-repeat: no-repeat;

			&.tg-icon {
				background-image: url('/tg.png');
			}

			&.email-icon {
				background-image: url('/email.png');
			}
		}
	}
}

.layout-body {
	width: 100%;
	margin: 0 auto;
	display: flex;
	flex-direction: column;
}

.layout-wrapper {
	margin-bottom: 10px;
}

.without-filters {
	.filters-block {
		display: none;
	}
}

.link-no-decoration {
	text-decoration: none;
	color: initial;

	&:hover {
		text-decoration: underline;
	}
}

.nowrap {
	white-space: nowrap;
}

.one-line {
	display: flex;
	justify-content: space-between;
	min-width: 0;
}
</style>
