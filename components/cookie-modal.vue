<script setup lang="ts">
const { t } = useI18n();
const { isModalActive, isConsentGiven, giveConsent, declineConsent } =
	useCookieControl();

const cookieData = [
	{
		id: 'website',
		required: true,
		name: 'Website & API',
		description: 'These cookies are necessary to make our site work',
		targetCookieIds: ['ncc_c'],
	},
	{
		id: 'analytics_mixpanel',
		required: false,
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
		required: false,
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
		required: true,
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

function revokeCookies() {
	declineConsent();
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
								<span
									class="cookie-status-badge"
									:class="{
										'cookie-status-badge--disabled':
											!category.required && !isConsentGiven,
									}"
								>
									{{
										category.required
											? t('Required')
											: isConsentGiven
												? t('Enabled')
												: t('Disabled')
									}}
								</span>
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
					v-if="isConsentGiven"
					class="cookie-modal__button cookie-modal__button--secondary"
					@click="revokeCookies"
				>
					{{ t('Revoke') }}
				</button>
				<button
					v-else
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
	border-bottom: 1px solid var(--color-border-primary);
}

.cookie-modal__title {
	font-size: 24px;
	font-weight: 600;
	margin: 0;
	color: var(--color-text-primary);
}

.cookie-modal__close {
	background: none;
	border: none;
	font-size: 32px;
	cursor: pointer;
	color: var(--color-text-muted);
	padding: 0;
	width: 32px;
	height: 32px;
	display: flex;
	align-items: center;
	justify-content: center;
	transition: color 0.2s ease;

	&:hover {
		color: var(--color-text-primary);
	}
}

.cookie-modal__content {
	padding: 24px;
}

.cookie-modal__description {
	font-size: 16px;
	line-height: 1.5;
	color: var(--color-text-secondary);
	margin: 0 0 24px 0;
}

.cookie-modal__categories {
	display: flex;
	flex-direction: column;
	gap: 20px;
}

.cookie-category {
	border: 1px solid var(--color-border-primary);
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
	color: var(--color-text-primary);
}

.cookie-category__description {
	font-size: 14px;
	line-height: 1.4;
	color: var(--color-text-secondary);
	margin: 0;
}

.cookie-category__status {
	display: flex;
	align-items: center;
}

.cookie-status-badge {
	background: var(--color-success-bg);
	border: 1px solid var(--color-success-border);
	color: var(--color-primary-green);
	font-size: 12px;
	font-weight: 500;
	padding: 4px 8px;
	border-radius: 4px;
	text-transform: uppercase;
}

.cookie-status-badge--disabled {
	background: var(--color-bg-tertiary);
	border-color: var(--color-border-primary);
	color: var(--color-text-muted);
}

.cookie-category__details {
	display: flex;
	flex-direction: column;
	gap: 12px;
}

.cookie-category__cookies {
	font-size: 14px;
	color: var(--color-text-secondary);
}

.cookie-list {
	font-family: monospace;
	background: var(--color-bg-tertiary);
	padding: 2px 6px;
	border-radius: 3px;
	margin-left: 8px;
}

.cookie-category__links {
	font-size: 14px;
	color: var(--color-text-secondary);
	display: flex;
	gap: 12px;
	align-items: center;
}

.cookie-link {
	color: var(--color-primary);
	text-decoration: none;

	&:hover {
		text-decoration: underline;
	}
}

.cookie-modal__actions {
	display: flex;
	gap: 12px;
	padding: 20px 24px;
	border-top: 1px solid var(--color-border-primary);
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
		background: var(--color-text-primary);
		color: white;

		&:hover {
			background: var(--color-text-heading);
		}
	}

	&--secondary {
		background: var(--color-bg-tertiary);
		color: var(--color-text-primary);
		border: 1px solid var(--color-border-primary);

		&:hover {
			background: var(--color-border-primary);
		}
	}

	&--tertiary {
		background: white;
		color: var(--color-text-primary);
		border: 1px solid var(--color-text-light);

		&:hover {
			background: var(--color-bg-secondary);
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
		"CookieInfoDescription": "Necessary cookies are always active. Analytics cookies are optional and are only used with your consent.",
		"CookiesUsed": "Cookies used",
		"MoreInfo": "More information",
		"Required": "Required",
		"Enabled": "Enabled",
		"Disabled": "Disabled",
		"Accept": "Accept",
		"Revoke": "Revoke consent",
		"Cancel": "Cancel"
	},
	"ru": {
		"CookieSettings": "Информация о cookies",
		"CookieInfoDescription": "Необходимые cookies всегда активны. Аналитические cookies необязательны и используются только с вашего согласия.",
		"CookiesUsed": "Используемые cookies",
		"MoreInfo": "Подробнее",
		"Required": "Обязательно",
		"Enabled": "Включено",
		"Disabled": "Выключено",
		"Accept": "Принять",
		"Revoke": "Отозвать согласие",
		"Cancel": "Отмена"
	},
	"de": {
		"CookieSettings": "Cookie-Informationen",
		"CookieInfoDescription": "Notwendige Cookies sind immer aktiv. Analyse-Cookies sind optional und werden nur mit Ihrer Einwilligung verwendet.",
		"CookiesUsed": "Verwendete Cookies",
		"MoreInfo": "Weitere Informationen",
		"Required": "Erforderlich",
		"Enabled": "Aktiviert",
		"Disabled": "Deaktiviert",
		"Accept": "Akzeptieren",
		"Revoke": "Einwilligung widerrufen",
		"Cancel": "Abbrechen"
	},
	"tr": {
		"CookieSettings": "Çerez Bilgileri",
		"CookieInfoDescription": "Gerekli çerezler her zaman etkindir. Analiz çerezleri isteğe bağlıdır ve yalnızca izninizle kullanılır.",
		"CookiesUsed": "Kullanılan çerezler",
		"MoreInfo": "Daha fazla bilgi",
		"Required": "Gerekli",
		"Enabled": "Etkin",
		"Disabled": "Devre dışı",
		"Accept": "Kabul Et",
		"Revoke": "Onayı geri çek",
		"Cancel": "İptal"
	},
	"sr": {
		"CookieSettings": "Informacije o kolačićima",
		"CookieInfoDescription": "Neophodni kolačići su uvek aktivni. Analitički kolačići su opcioni i koriste se samo uz vašu saglasnost.",
		"CookiesUsed": "Korišćeni kolačići",
		"MoreInfo": "Više informacija",
		"Required": "Obavezno",
		"Enabled": "Uključeno",
		"Disabled": "Isključeno",
		"Accept": "Prihvati",
		"Revoke": "Povuci saglasnost",
		"Cancel": "Otkaži"
	},
	"sr-cyrl": {
		"CookieSettings": "Информације о колачићима",
		"CookieInfoDescription": "Неопходни колачићи су увек активни. Аналитички колачићи су опциони и користе се само уз вашу сагласност.",
		"CookiesUsed": "Коришћени колачићи",
		"MoreInfo": "Више информација",
		"Required": "Обавезно",
		"Enabled": "Укључено",
		"Disabled": "Искључено",
		"Accept": "Прихвати",
		"Revoke": "Повуци сагласност",
		"Cancel": "Откажи"
	}
}
</i18n>
