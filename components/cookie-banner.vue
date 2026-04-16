<script setup lang="ts">
const { t } = useI18n();
const { giveConsent, declineConsent } = useCookieControl();
</script>

<template>
	<Transition name="cookie-slide">
		<div class="cookie-banner">
			<p class="cookie-banner__text">
				{{ t('CookieText') }}
				<NuxtLink to="/privacy" class="cookie-banner__link">{{
					t('PrivacyLink')
				}}</NuxtLink>
			</p>
			<div class="cookie-banner__actions">
				<button
					class="cookie-banner__btn cookie-banner__btn--accept"
					@click="giveConsent"
				>
					{{ t('Accept') }}
				</button>
				<button
					class="cookie-banner__btn cookie-banner__btn--decline"
					@click="declineConsent"
				>
					{{ t('Decline') }}
				</button>
			</div>
		</div>
	</Transition>
</template>

<style lang="less" scoped>
.cookie-banner {
	position: fixed;
	bottom: var(--spacing-lg);
	left: var(--spacing-lg);
	z-index: var(--z-cookie-consent);
	display: flex;
	align-items: center;
	gap: var(--spacing-md);
	max-width: 480px;
	padding: var(--spacing-md) var(--spacing-lg);
	background: var(--color-bg-primary);
	border: 1px solid var(--color-border-secondary);
	border-radius: var(--border-radius-xl);
	box-shadow: var(--shadow-xl);
}

.cookie-banner__text {
	margin: 0;
	font-size: var(--font-size-sm);
	line-height: 1.4;
	color: var(--color-text-secondary);
}

.cookie-banner__link {
	color: var(--color-primary);
	text-decoration: none;
	white-space: nowrap;

	&:hover {
		text-decoration: underline;
	}
}

.cookie-banner__actions {
	display: flex;
	gap: var(--spacing-sm);
	flex-shrink: 0;
}

.cookie-banner__btn {
	border: none;
	padding: 6px 14px;
	border-radius: var(--border-radius-md);
	cursor: pointer;
	font-size: var(--font-size-sm);
	font-weight: var(--font-weight-medium);
	white-space: nowrap;
	transition: all var(--transition-base);

	&--accept {
		background: var(--color-text-heading);
		color: white;

		&:hover {
			background: var(--color-primary-dark);
		}
	}

	&--decline {
		background: transparent;
		color: var(--color-text-muted);

		&:hover {
			color: var(--color-text-primary);
			background: var(--color-bg-tertiary);
		}
	}
}

.cookie-slide-enter-active {
	transition: all 0.3s ease-out;
}

.cookie-slide-leave-active {
	transition: all 0.2s ease-in;
}

.cookie-slide-enter-from,
.cookie-slide-leave-to {
	opacity: 0;
	transform: translateY(16px);
}

@media screen and (max-width: 540px) {
	.cookie-banner {
		left: var(--spacing-sm);
		right: var(--spacing-sm);
		bottom: var(--spacing-sm);
		max-width: none;
		flex-direction: column;
		align-items: stretch;
		gap: var(--spacing-sm);
	}

	.cookie-banner__actions {
		justify-content: flex-end;
	}
}
</style>

<i18n lang="json">
{
	"en": {
		"CookieText": "We use cookies for site functionality and analytics.",
		"PrivacyLink": "Privacy Policy",
		"Accept": "OK",
		"Decline": "Decline"
	},
	"ru": {
		"CookieText": "Мы используем cookies для работы сайта и аналитики.",
		"PrivacyLink": "Политика конфиденциальности",
		"Accept": "ОК",
		"Decline": "Отклонить"
	},
	"de": {
		"CookieText": "Wir verwenden Cookies fur die Website-Funktionalitat und Analysen.",
		"PrivacyLink": "Datenschutzerklarung",
		"Accept": "OK",
		"Decline": "Ablehnen"
	},
	"tr": {
		"CookieText": "Site islevseligi ve analitik icin cerezler kullaniyoruz.",
		"PrivacyLink": "Gizlilik Politikasi",
		"Accept": "Tamam",
		"Decline": "Reddet"
	},
	"sr": {
		"CookieText": "Koristimo kolacice za funkcionalnost sajta i analitiku.",
		"PrivacyLink": "Politika privatnosti",
		"Accept": "OK",
		"Decline": "Odbij"
	},
	"sr-cyrl": {
		"CookieText": "Користимо колачиће за функционалност сајта и аналитику.",
		"PrivacyLink": "Политика приватности",
		"Accept": "ОК",
		"Decline": "Одбиј"
	}
}
</i18n>
