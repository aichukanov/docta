<script setup lang="ts">
const { t } = useI18n();
const { giveConsent, declineConsent } = useCookieControl();
</script>

<template>
	<div class="cookie-banner">
		<div class="cookie-banner__container">
			<div class="cookie-banner__content">
				<h2 class="cookie-banner__title">{{ t('CookieTitle') }}</h2>
				<p class="cookie-banner__description">{{ t('CookieDescription') }}</p>
				<p class="cookie-banner__description-2">
					{{ t('CookieDescription2') }}
					<NuxtLink to="/privacy" class="cookie-banner__privacy-link">{{ t('PrivacyLink') }}</NuxtLink>
				</p>
			</div>
			<div class="cookie-banner__actions">
				<button class="cookie-banner__button cookie-banner__button--accept" @click="giveConsent">
					{{ t('Accept') }}
				</button>
				<button class="cookie-banner__button cookie-banner__button--decline" @click="declineConsent">
					{{ t('Decline') }}
				</button>
			</div>
		</div>
	</div>
</template>

<style lang="less" scoped>
.cookie-banner {
	position: fixed;
	bottom: 0;
	left: 0;
	right: 0;
	height: max(70vh, 300px);
	display: flex;
	justify-content: center;
	align-items: flex-end;
	pointer-events: none;
	z-index: 1000;
	background: linear-gradient(
		to bottom,
		transparent,
		rgba(0, 0, 0, 0.1) 50px,
		black 300px
	);
}

.cookie-banner__container {
	display: flex;
	justify-content: center;
	align-items: flex-end;
	gap: 20px;
	background: black;
	padding: 20px;
	pointer-events: all;
	max-width: 800px;
	width: 100%;
}

.cookie-banner__content {
	display: flex;
	flex-direction: column;
	gap: 10px;
	color: white;
	max-width: 500px;
}

.cookie-banner__title {
	font-size: 24px;
	font-weight: bold;
	margin: 0;
}

.cookie-banner__description,
.cookie-banner__description-2 {
	font-size: 18px;
	line-height: 1.2;
	margin: 0;
}

.cookie-banner__actions {
	display: flex;
	flex-direction: column;
	gap: 10px;
}

.cookie-banner__privacy-link {
	color: rgba(255, 255, 255, 0.7);
	text-decoration: underline;
	text-underline-offset: 2px;
	white-space: nowrap;

	&:hover {
		color: white;
	}
}

.cookie-banner__button {
	border: none;
	padding: 12px 24px;
	border-radius: 4px;
	cursor: pointer;
	font-size: 14px;
	font-weight: 500;
	min-width: 120px;
	margin-bottom: 30px;
	transition: all 0.3s ease;

	&--accept {
		background: white;
		color: black;

		&:hover {
			background: var(--color-primary-dark);
			color: white;
		}
	}

	&--decline {
		background: transparent;
		color: rgba(255, 255, 255, 0.6);
		border: 1px solid rgba(255, 255, 255, 0.3);

		&:hover {
			color: white;
			border-color: rgba(255, 255, 255, 0.7);
		}
	}
}

@media screen and (max-width: 768px) {
	.cookie-banner__container {
		flex-direction: column;
		gap: 16px;
		padding: 20px;
	}

	.cookie-banner__content {
		max-width: 100%;
	}

	.cookie-banner__title {
		font-size: 20px;
	}

	.cookie-banner__description,
	.cookie-banner__description-2 {
		font-size: 16px;
	}

	.cookie-banner__actions {
		width: 100%;
		flex-direction: column;

		.cookie-banner__button {
			width: 100%;
			min-width: auto;
			padding: 14px 20px;
			margin-bottom: 0;
		}

		.cookie-banner__button--accept {
			margin-bottom: 0;
		}
	}
}
</style>

<i18n lang="json">
{
	"en": {
		"CookieTitle": "Cookies",
		"CookieDescription": "Cookies are needed for proper site functionality and analytics, you should allow their use.",
		"CookieDescription2": "You can revoke your consent at any time. ",
		"PrivacyLink": "Privacy Policy",
		"Accept": "Accept",
		"Decline": "Decline"
	},
	"ru": {
		"CookieTitle": "Cookies",
		"CookieDescription": "Файлы cookie нужны для корректной работы сайта и аналитики, вам стоит разрешить их использование.",
		"CookieDescription2": "Разрешение можно будет отозвать в любой момент. ",
		"PrivacyLink": "Политика конфиденциальности",
		"Accept": "Принять",
		"Decline": "Отклонить"
	},
	"de": {
		"CookieTitle": "Cookies",
		"CookieDescription": "Cookies werden für die ordnungsgemäße Funktionalität der Website und Analysen benötigt, Sie sollten ihre Verwendung zulassen.",
		"CookieDescription2": "Sie können Ihre Zustimmung jederzeit widerrufen. ",
		"PrivacyLink": "Datenschutzerklärung",
		"Accept": "Akzeptieren",
		"Decline": "Ablehnen"
	},
	"tr": {
		"CookieTitle": "Çerezler",
		"CookieDescription": "Çerezler, sitenin düzgün çalışması ve analitik için gereklidir, kullanımlarına izin vermelisiniz.",
		"CookieDescription2": "İzninizi istediğiniz zaman geri alabilirsiniz. ",
		"PrivacyLink": "Gizlilik Politikası",
		"Accept": "Kabul Et",
		"Decline": "Reddet"
	},
	"sr": {
		"CookieTitle": "Kolačići",
		"CookieDescription": "Kolačići su potrebni za ispravno funkcionisanje sajta i analitiku, trebalo bi da dozvolite njihovu upotrebu.",
		"CookieDescription2": "Možete povući svoju saglasnost u bilo kom trenutku. ",
		"PrivacyLink": "Politika privatnosti",
		"Accept": "Prihvati",
		"Decline": "Odbij"
	},
	"sr-cyrl": {
		"CookieTitle": "Колачићи",
		"CookieDescription": "Колачићи су потребни за исправно функционисање сајта и аналитику, требало би да дозволите њихову употребу.",
		"CookieDescription2": "Можете повући своју сагласност у било ком тренутку. ",
		"PrivacyLink": "Политика приватности",
		"Accept": "Прихвати",
		"Decline": "Одбиј"
	}
}
</i18n>
