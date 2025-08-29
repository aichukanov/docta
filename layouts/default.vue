<template>
	<div class="layout-wrapper">
		<AppHeader />

		<div class="layout-body">
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

/* ===========================================
   ДИЗАЙН ТОКЕНЫ - Централизованные CSS переменные
   
   Современная дизайн-система 2024:
   - Только системные шрифты для максимальной производительности
   - Минималистичные тени без многослойности
   - Плоские взаимодействия (hover через изменение фона/цвета)
   - Умеренные закругления (4-8px) вместо "bubble" дизайна
   - Тонкие цветовые акценты без 3D эффектов
   =========================================== */

:root {
	/* === ЦВЕТА === */

	/* Основная палитра - более мягкая и современная */
	--color-primary: #4f46e5; /* Индиго */
	--color-primary-dark: #3730a3; /* Темно-индиго для hover */
	--color-secondary: #06b6d4; /* Циан */
	--color-accent: #f59e0b; /* Теплый янтарный */
	--color-success: #10b981; /* Зеленый для успеха */

	/* Градиенты - более мягкие */
	--gradient-primary: linear-gradient(135deg, #4f46e5 0%, #06b6d4 100%);
	--gradient-soft: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);

	/* Текст */
	--color-text-primary: #333;
	--color-text-secondary: #666;
	--color-text-muted: #888;
	--color-text-light: #999;

	/* Фоны - более мягкие оттенки */
	--color-bg-primary: #ffffff;
	--color-bg-secondary: #f8fafc;
	--color-bg-tertiary: #f1f5f9;
	--color-bg-muted: #e2e8f0;
	--color-bg-soft: #fafbfc;

	/* Границы - более заметные */
	--color-border-primary: #d1d5db;
	--color-border-secondary: #e5e7eb;
	--color-border-light: #f3f4f6;
	--color-border-accent: rgba(79, 70, 229, 0.3);

	/* Поверхности - алиасы для лучшей семантики */
	--color-surface-primary: var(--color-bg-primary);
	--color-surface-secondary: var(--color-bg-secondary);

	/* Серые тона */
	--color-gray-100: #f8f9fa;
	--color-gray-200: #e9ecef;
	--color-gray-300: #dee2e6;
	--color-gray-400: #ced4da;
	--color-gray-500: #6c757d;
	--color-gray-600: #5a6268;
	--color-gray-700: #495057;
	--color-gray-800: #343a40;

	/* Состояния */
	--color-hover-light: rgba(102, 126, 234, 0.1);
	--color-hover-bg: #f8f9fa;

	/* === РАЗМЕРЫ === */

	/* Отступы */
	--spacing-xs: 0.25rem; /* 4px */
	--spacing-sm: 0.5rem; /* 8px */
	--spacing-md: 0.75rem; /* 12px */
	--spacing-lg: 1rem; /* 16px */
	--spacing-xl: 1.5rem; /* 24px */
	--spacing-2xl: 2rem; /* 32px */
	--spacing-3xl: 3rem; /* 48px */
	--spacing-4xl: 4rem; /* 64px */

	/* Размеры шрифтов */
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

	/* Веса шрифтов */
	--font-weight-normal: 400;
	--font-weight-medium: 500;
	--font-weight-semibold: 600;
	--font-weight-bold: 700;

	/* Высота строк */
	--line-height-tight: 1.2;
	--line-height-base: 1.4;
	--line-height-relaxed: 1.6;

	/* === ГРАНИЦЫ И РАДИУСЫ === */

	--border-width-thin: 1px;
	--border-width-thick: 3px;

	--border-radius-sm: 4px;
	--border-radius-md: 6px;
	--border-radius-lg: 8px;
	--border-radius-xl: 12px;
	--border-radius-full: 50%;

	/* === ТЕНИ - минималистичные === */

	--shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.06);
	--shadow-md: 0 2px 6px rgba(0, 0, 0, 0.08);
	--shadow-lg: 0 4px 12px rgba(0, 0, 0, 0.1);
	--shadow-xl: 0 8px 24px rgba(0, 0, 0, 0.12);
	--shadow-hover: 0 2px 8px rgba(79, 70, 229, 0.15);
	--shadow-soft: 0 0 0 1px rgba(0, 0, 0, 0.06);

	/* === ПЕРЕХОДЫ === */

	--transition-fast: 0.1s ease;
	--transition-base: 0.2s ease;
	--transition-slow: 0.3s ease;

	/* === BREAKPOINTS === */

	--breakpoint-mobile: 768px;
	--breakpoint-tablet: 1024px;
	--breakpoint-desktop: 1200px;

	/* === МАКСИМАЛЬНАЯ ШИРИНА КОНТЕЙНЕРОВ === */

	--container-max-width: 1920px;
	--container-padding: 1rem;

	/* === Z-ИНДЕКСЫ === */
	/* Импортируются из src/lib/z-index.ts для централизованного управления */

	--z-base: 0;
	--z-raised: 100;
	--z-map: 1000;
	--z-dropdown: 1100;
	--z-header: 1200;
	--z-header-dropdown: 1300;
	--z-modal: 2000;
	--z-cookie-consent: 2500;
	--z-tooltip: 3000;

	/* === СПЕЦИФИЧНЫЕ ДЛЯ ПРИЛОЖЕНИЯ === */

	/* Высоты компонентов */
	--map-height: 600px;
	--map-height-mobile: 400px;
	--sidebar-width: 400px;

	/* Размеры форм */
	--input-height: 2.75rem; /* ~44px */
	--button-height: 2.75rem;

	/* Скроллбары */
	--scrollbar-width: 6px;
	--scrollbar-track: var(--color-bg-muted);
	--scrollbar-thumb: #c1c1c1;
	--scrollbar-thumb-hover: #a8a8a8;

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
