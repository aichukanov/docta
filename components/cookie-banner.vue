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
	bottom: var(--kit-spacing-lg);
	left: var(--kit-spacing-lg);
	z-index: var(--kit-z-cookie-consent);
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-md);
	max-width: 360px;
	padding: var(--kit-spacing-md) var(--kit-spacing-lg);
	background: var(--kit-color-bg-primary);
	border: 1px solid var(--kit-color-border-secondary);
	border-radius: var(--kit-border-radius-xl);
	box-shadow: var(--kit-shadow-xl);
}

.cookie-banner__text {
	margin: 0;
	font-size: var(--kit-font-size-base);
	line-height: 1.4;
	color: var(--kit-color-text-secondary);
}

.cookie-banner__link {
	color: var(--kit-color-primary);
	text-decoration: none;
	white-space: nowrap;

	&:hover {
		text-decoration: underline;
	}
}

.cookie-banner__actions {
	display: flex;
	gap: var(--kit-spacing-sm);
	justify-content: flex-end;
	align-items: center;
	flex-shrink: 0;
}

.cookie-banner__btn {
	border: none;
	padding: var(--kit-spacing-sm) var(--kit-spacing-lg);
	border-radius: var(--kit-border-radius-md);
	cursor: pointer;
	font-size: var(--kit-font-size-sm);
	font-weight: var(--kit-font-weight-medium);
	white-space: nowrap;
	transition: all var(--kit-transition-base);

	&--accept {
		background: var(--kit-color-text-heading);
		color: white;

		&:hover {
			background: var(--kit-color-primary-dark);
		}
	}

	&--decline {
		background: transparent;
		color: var(--kit-color-text-muted);

		&:hover {
			color: var(--kit-color-text-primary);
			background: var(--kit-color-bg-tertiary);
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
		left: var(--kit-spacing-sm);
		right: var(--kit-spacing-sm);
		bottom: var(--kit-spacing-sm);
		max-width: none;
		flex-direction: column;
		align-items: stretch;
		gap: var(--kit-spacing-sm);
	}

	.cookie-banner__actions {
		justify-content: flex-end;
	}
}
</style>

<i18n lang="json">
{
	"en": {
		"CookieText": "We use optional cookies for analytics. Necessary cookies are always active.",
		"PrivacyLink": "Privacy Policy",
		"Accept": "Accept analytics",
		"Decline": "Decline"
	},
	"ru": {
		"CookieText": "Мы используем необязательные cookies для аналитики. Необходимые cookies всегда активны.",
		"PrivacyLink": "Политика конфиденциальности",
		"Accept": "Разрешить аналитику",
		"Decline": "Отклонить"
	},
	"de": {
		"CookieText": "Wir verwenden optionale Cookies für Analysen. Notwendige Cookies sind immer aktiv.",
		"PrivacyLink": "Datenschutzerklarung",
		"Accept": "Analyse erlauben",
		"Decline": "Ablehnen"
	},
	"tr": {
		"CookieText": "Analiz için isteğe bağlı çerezler kullanıyoruz. Gerekli çerezler her zaman etkindir.",
		"PrivacyLink": "Gizlilik Politikasi",
		"Accept": "Analize izin ver",
		"Decline": "Reddet"
	},
	"sr": {
		"CookieText": "Koristimo opcione kolačiće za analitiku. Neophodni kolačići su uvijek aktivni.",
		"PrivacyLink": "Politika privatnosti",
		"Accept": "Dozvoli analitiku",
		"Decline": "Odbij"
	},
	"sr-cyrl": {
		"CookieText": "Користимо опционе колачиће за аналитику. Неопходни колачићи су увијек активни.",
		"PrivacyLink": "Политика приватности",
		"Accept": "Дозволи аналитику",
		"Decline": "Одбиј"
	}
}
</i18n>
