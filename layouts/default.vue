<template>
	<div class="layout-wrapper">
		<AppHeader />

		<div class="layout-body">
			<slot />
		</div>

		<div class="footer" :class="{ 'footer-tall': !isConsentGiven }">
			<div class="footer-content">
				<div>omeda.me | {{ years }}</div>

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

const years = computed(() => `2025`); //  - ${new Date().getFullYear()}

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
	--color-primary: #4f46e5;
	--color-primary-dark: #3730a3;
	--color-primary-green: #0e5d14;
	--color-primary-dark-green: #0a4210;
	--color-secondary: #06b6d4;
	--color-accent: #f59e0b;
	--color-success: #10b981;

	--color-text-primary: #333333;
	--color-text-secondary: #666666;
	--color-text-muted: #888888;
	--color-text-light: #999999;

	--color-bg-primary: #ffffff;
	--color-bg-secondary: #f8fafc;
	--color-bg-tertiary: #f1f5f9;
	--color-bg-muted: #e2e8f0;
	--color-bg-soft: #fafbfc;

	--color-border-primary: #d1d5db;
	--color-border-secondary: #e5e7eb;
	--color-border-light: #f3f4f6;
	--color-border-accent: rgba(79, 70, 229, 0.3);

	--color-surface-primary: var(--color-bg-primary);
	--color-surface-secondary: var(--color-bg-secondary);

	/* === РАЗМЕРЫ === */
	--spacing-xs: 0.25rem; /* 4px */
	--spacing-sm: 0.5rem; /* 8px */
	--spacing-md: 0.75rem; /* 12px */
	--spacing-lg: 1rem; /* 16px */
	--spacing-xl: 1.5rem; /* 24px */
	--spacing-2xl: 2rem; /* 32px */
	--spacing-3xl: 3rem; /* 48px */
	--spacing-4xl: 4rem; /* 64px */

	--font-size-xs: 0.7rem; /* 11.2px */
	--font-size-sm: 0.8rem; /* 12.8px */
	--font-size-base: 0.85rem; /* 13.6px */
	--font-size-md: 0.9rem; /* 14.4px */
	--font-size-lg: 0.95rem; /* 15.2px */
	--font-size-xl: 1rem; /* 16px */
	--font-size-2xl: 1.1rem; /* 17.6px */
	--font-size-3xl: 1.2rem; /* 19.2px */
	--font-size-4xl: 2rem; /* 32px */
	--font-size-5xl: 3rem; /* 48px */

	--font-weight-normal: 400;
	--font-weight-medium: 500;
	--font-weight-semibold: 600;
	--font-weight-bold: 700;

	--border-width-thin: 1px;
	--border-width-thick: 3px;

	--border-radius-sm: 4px;
	--border-radius-md: 6px;
	--border-radius-lg: 8px;
	--border-radius-xl: 12px;
	--border-radius-full: 50%;

	/* === ТЕНИ === */
	--shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.06);
	--shadow-md: 0 2px 6px rgba(0, 0, 0, 0.08);
	--shadow-lg: 0 4px 12px rgba(0, 0, 0, 0.1);
	--shadow-xl: 0 8px 24px rgba(0, 0, 0, 0.12);
	--shadow-hover: 0 2px 8px rgba(79, 70, 229, 0.15);
	--shadow-soft: 0 0 0 1px rgba(0, 0, 0, 0.06);

	/* === ПЕРЕХОДЫ === */
	--transition-fast: 0.1s ease;
	--transition-base: 0.2s ease;

	/* === Z-ИНДЕКСЫ === */
	--z-base: 0;
	--z-raised: 100;
	--z-map: 1000;
	--z-dropdown: 1100;
	--z-header: 1200;
	--z-header-dropdown: 1300;
	--z-modal: 2000;
	--z-cookie-consent: 2500;
	--z-tooltip: 3000;

	/* === СОВМЕСТИМОСТЬ С ELEMENT PLUS === */
	--el-color-primary: var(--color-primary);
	--el-color-primary-light-3: #6366f1;
	--el-color-primary-light-5: #818cf8;
	--el-color-primary-light-7: #a5b4fc;
	--el-color-primary-light-8: #c7d2fe;
	--el-color-primary-light-9: #e0e7ff;
	--el-color-primary-dark-2: var(--color-primary-dark);
}

html,
body {
	margin: 0;
}

body {
	width: 100%;
	background-color: #ffffff;
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
		max-width: 1600px;
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
