<script setup lang="ts">
const { t } = useI18n();
const { giveConsent } = useCookieControl();

function acceptCookies() {
	giveConsent();
}
</script>

<template>
	<div class="cookie-banner">
		<div class="cookie-banner__container">
			<div class="cookie-banner__content">
				<h2 class="cookie-banner__title">{{ t('CookieTitle') }}</h2>
				<p class="cookie-banner__description">{{ t('CookieDescription') }}</p>
				<p class="cookie-banner__description-2">{{
					t('CookieDescription2')
				}}</p>
			</div>
			<div class="cookie-banner__actions">
				<button class="cookie-banner__button" @click="acceptCookies">
					{{ t('Accept') }}
				</button>
			</div>
		</div>
	</div>
</template>

<style lang="less" scoped>
@import url('~/assets/css/vars.less');

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

.cookie-banner__button {
	background: white;
	color: black;
	border: none;
	padding: 12px 24px;
	border-radius: 4px;
	cursor: pointer;
	font-size: 14px;
	font-weight: 500;
	min-width: 120px;
	margin-bottom: 30px;
	transition: all 0.3s ease;

	&:hover {
		background: @primary-hover-color;
		color: white;
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

		.cookie-banner__button {
			width: 100%;
			min-width: auto;
			padding: 14px 20px;
		}
	}
}
</style>

<i18n lang="json">
{
	"en": {
		"CookieTitle": "Cookies",
		"CookieDescription": "Cookies are needed for proper site functionality and analytics, you should allow their use.",
		"CookieDescription2": "You can revoke your consent at any time.",
		"Accept": "Accept"
	},
	"ru": {
		"CookieTitle": "Cookies",
		"CookieDescription": "Файлы cookie нужны для корректной работы сайта и аналитики, вам стоит разрешить их использование.",
		"CookieDescription2": "Разрешение можно будет отозвать в любой момент.",
		"Accept": "Принять"
	},
	"de": {
		"CookieTitle": "Cookies",
		"CookieDescription": "Cookies werden für die ordnungsgemäße Funktionalität der Website und Analysen benötigt, Sie sollten ihre Verwendung zulassen.",
		"CookieDescription2": "Sie können Ihre Zustimmung jederzeit widerrufen.",
		"Accept": "Akzeptieren"
	},
	"tr": {
		"CookieTitle": "Çerezler",
		"CookieDescription": "Çerezler, sitenin düzgün çalışması ve analitik için gereklidir, kullanımlarına izin vermelisiniz.",
		"CookieDescription2": "İzninizi istediğiniz zaman geri alabilirsiniz.",
		"Accept": "Kabul Et"
	},
	"sr": {
		"CookieTitle": "Kolačići",
		"CookieDescription": "Kolačići su potrebni za ispravno funkcionisanje sajta i analitiku, trebalo bi da dozvolite njihovu upotrebu.",
		"CookieDescription2": "Možete povući svoju saglasnost u bilo kom trenutku.",
		"Accept": "Prihvati"
	}
}
</i18n>
