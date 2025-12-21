<script setup lang="ts">
const { t } = useI18n();
const { isModalActive, giveConsent } = useCookieControl();

const cookieData = [
	{
		id: 'website',
		name: 'Website & API',
		description: 'These cookies are necessary to make our site work',
		targetCookieIds: ['ncc_c'],
	},
	{
		id: 'analytics_mixpanel',
		name: 'Mixpanel Analytics',
		description:
			'This cookie helps us understand how visitors interact with our website',
		targetCookieIds: ['mp_*'],
		links: {
			'https://mixpanel.com/legal/privacy-policy': 'Privacy Policy',
			'https://mixpanel.com/legal/terms-of-use': 'Terms of Service',
		},
	},
	{
		id: 'analytics_gtm',
		name: 'Google Tag Manager',
		description: 'This cookie tracks site usage behvaiour',
		targetCookieIds: ['_ga', '_ga_<container-id>', '_gat', '_gid'],
		links: {
			'https://policies.google.com/technologies/partner-sites':
				'Privacy Policy',
			'https://policies.google.com/terms': 'Terms of Service',
		},
	},
	{
		id: 'cloudflare',
		name: 'Cloudflare Analytics',
		description:
			'These cookies are used by Cloudflare to provide security and performance analytics',
		targetCookieIds: ['__cf_bm', '__cflb', '__cfuid', '__cfruid'],
		links: {
			'https://www.cloudflare.com/privacy-policy/': 'Privacy Policy',
			'https://www.cloudflare.com/terms/': 'Terms of Service',
		},
	},
];

function acceptCookies() {
	giveConsent();
	isModalActive.value = false;
}

function closeModal() {
	isModalActive.value = false;
}
</script>

<template>
	<div v-if="isModalActive" class="cookie-modal-overlay" @click="closeModal">
		<div class="cookie-modal" @click.stop>
			<div class="cookie-modal__header">
				<h2 class="cookie-modal__title">{{ t('CookieSettings') }}</h2>
				<button class="cookie-modal__close" @click="closeModal">×</button>
			</div>

			<div class="cookie-modal__content">
				<p class="cookie-modal__description">
					{{ t('CookieInfoDescription') }}
				</p>

				<div class="cookie-modal__categories">
					<div
						v-for="category in cookieData"
						:key="category.id"
						class="cookie-category"
					>
						<div class="cookie-category__header">
							<div class="cookie-category__info">
								<h3 class="cookie-category__name">{{ category.name }}</h3>
								<p class="cookie-category__description">{{
									category.description
								}}</p>
							</div>
							<div class="cookie-category__status">
								<span class="cookie-status-badge">{{ t('Required') }}</span>
							</div>
						</div>

						<div class="cookie-category__details">
							<div class="cookie-category__cookies">
								<strong>{{ t('CookiesUsed') }}:</strong>
								<span class="cookie-list">{{
									category.targetCookieIds.join(', ')
								}}</span>
							</div>

							<div v-if="category.links" class="cookie-category__links">
								<strong>{{ t('MoreInfo') }}:</strong>
								<a
									v-for="(linkText, linkUrl) in category.links"
									:key="linkUrl"
									:href="linkUrl"
									target="_blank"
									rel="noopener noreferrer"
									class="cookie-link"
								>
									{{ linkText }}
								</a>
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="cookie-modal__actions">
				<button
					class="cookie-modal__button cookie-modal__button--secondary"
					@click="closeModal"
				>
					{{ t('Cancel') }}
				</button>
				<button
					class="cookie-modal__button cookie-modal__button--primary"
					@click="acceptCookies"
				>
					{{ t('Accept') }}
				</button>
			</div>
		</div>
	</div>
</template>

<style lang="less" scoped>
.cookie-modal-overlay {
	position: fixed;
	box-sizing: border-box;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.8);
	display: flex;
	justify-content: center;
	align-items: center;
	z-index: 2000;
	padding: 20px;
}

.cookie-modal {
	background: white;
	border-radius: 8px;
	width: 100%;
	max-width: 600px;
	max-height: 80vh;
	overflow-y: auto;
	position: relative;
}

.cookie-modal__header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 24px;
	border-bottom: 1px solid #e0e0e0;
}

.cookie-modal__title {
	font-size: 24px;
	font-weight: 600;
	margin: 0;
	color: #333;
}

.cookie-modal__close {
	background: none;
	border: none;
	font-size: 32px;
	cursor: pointer;
	color: #999;
	padding: 0;
	width: 32px;
	height: 32px;
	display: flex;
	align-items: center;
	justify-content: center;
	transition: color 0.2s ease;

	&:hover {
		color: #333;
	}
}

.cookie-modal__content {
	padding: 24px;
}

.cookie-modal__description {
	font-size: 16px;
	line-height: 1.5;
	color: #666;
	margin: 0 0 24px 0;
}

.cookie-modal__categories {
	display: flex;
	flex-direction: column;
	gap: 20px;
}

.cookie-category {
	border: 1px solid #e0e0e0;
	border-radius: 6px;
	padding: 20px;
}

.cookie-category__header {
	display: flex;
	justify-content: space-between;
	align-items: flex-start;
	margin-bottom: 16px;
}

.cookie-category__info {
	flex: 1;
	margin-right: 16px;
}

.cookie-category__name {
	font-size: 18px;
	font-weight: 600;
	margin: 0 0 8px 0;
	color: #333;
}

.cookie-category__description {
	font-size: 14px;
	line-height: 1.4;
	color: #666;
	margin: 0;
}

.cookie-category__status {
	display: flex;
	align-items: center;
}

.cookie-status-badge {
	background: #4caf50;
	color: white;
	font-size: 12px;
	font-weight: 500;
	padding: 4px 8px;
	border-radius: 4px;
	text-transform: uppercase;
}

.cookie-category__details {
	display: flex;
	flex-direction: column;
	gap: 12px;
}

.cookie-category__cookies {
	font-size: 14px;
	color: #666;
}

.cookie-list {
	font-family: monospace;
	background: #f5f5f5;
	padding: 2px 6px;
	border-radius: 3px;
	margin-left: 8px;
}

.cookie-category__links {
	font-size: 14px;
	color: #666;
	display: flex;
	gap: 12px;
	align-items: center;
}

.cookie-link {
	color: #1976d2;
	text-decoration: none;

	&:hover {
		text-decoration: underline;
	}
}

.cookie-modal__actions {
	display: flex;
	gap: 12px;
	padding: 20px 24px;
	border-top: 1px solid #e0e0e0;
	justify-content: flex-end;
}

.cookie-modal__button {
	padding: 12px 24px;
	border: none;
	border-radius: 6px;
	font-size: 16px;
	font-weight: 500;
	cursor: pointer;
	transition: all 0.2s ease;
	min-width: 120px;

	&--primary {
		background: #333;
		color: white;

		&:hover {
			background: #222;
		}
	}

	&--secondary {
		background: #f5f5f5;
		color: #333;
		border: 1px solid #ddd;

		&:hover {
			background: #e0e0e0;
		}
	}

	&--tertiary {
		background: white;
		color: #333;
		border: 1px solid #999;

		&:hover {
			background: #f8f8f8;
		}
	}
}

@media screen and (max-width: 768px) {
	.cookie-modal {
		max-width: 100%;
		max-height: 90vh;
		margin: 0 10px;
	}

	.cookie-modal__header,
	.cookie-modal__content,
	.cookie-modal__actions {
		padding: 16px;
	}

	.cookie-modal__title {
		font-size: 20px;
	}

	.cookie-category__header {
		flex-direction: column;
		gap: 12px;
	}

	.cookie-category__info {
		margin-right: 0;
	}

	.cookie-modal__actions {
		flex-direction: column;
		gap: 8px;

		.cookie-modal__button {
			width: 100%;
		}
	}
}
</style>

<i18n lang="json">
{
	"en": {
		"CookieSettings": "Cookie Information",
		"CookieInfoDescription": "We use cookies to improve your experience and analyze website traffic. All cookies are necessary for proper site functionality.",
		"CookiesUsed": "Cookies used",
		"MoreInfo": "More information",
		"Required": "Required",
		"Accept": "Accept",
		"Cancel": "Cancel"
	},
	"ru": {
		"CookieSettings": "Информация о cookies",
		"CookieInfoDescription": "Мы используем файлы cookie для улучшения вашего опыта и анализа трафика сайта. Все файлы cookie необходимы для корректной работы сайта.",
		"CookiesUsed": "Используемые cookies",
		"MoreInfo": "Подробнее",
		"Required": "Обязательно",
		"Accept": "Принять",
		"Cancel": "Отмена"
	},
	"de": {
		"CookieSettings": "Cookie-Informationen",
		"CookieInfoDescription": "Wir verwenden Cookies, um Ihr Erlebnis zu verbessern und den Website-Traffic zu analysieren. Alle Cookies sind für die ordnungsgemäße Funktionalität der Website erforderlich.",
		"CookiesUsed": "Verwendete Cookies",
		"MoreInfo": "Weitere Informationen",
		"Required": "Erforderlich",
		"Accept": "Akzeptieren",
		"Cancel": "Abbrechen"
	},
	"tr": {
		"CookieSettings": "Çerez Bilgileri",
		"CookieInfoDescription": "Deneyiminizi geliştirmek ve website trafiğini analiz etmek için çerezler kullanıyoruz. Tüm çerezler sitenin düzgün çalışması için gereklidir.",
		"CookiesUsed": "Kullanılan çerezler",
		"MoreInfo": "Daha fazla bilgi",
		"Required": "Gerekli",
		"Accept": "Kabul Et",
		"Cancel": "İptal"
	},
	"sr": {
		"CookieSettings": "Informacije o kolačićima",
		"CookieInfoDescription": "Koristimo kolačiće da poboljšamo vaše iskustvo i analiziramo saobraćaj na sajtu. Svi kolačići su potrebni za ispravno funkcionisanje sajta.",
		"CookiesUsed": "Korišćeni kolačići",
		"MoreInfo": "Više informacija",
		"Required": "Obavezno",
		"Accept": "Prihvati",
		"Cancel": "Otkaži"
	}
}
</i18n>
