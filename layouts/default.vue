<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import { PROJECT_CONTACTS, SITE_NAME } from '~/common/constants';

const { isConsentGiven, isConsentDecided } = useCookieControl();
const { t, locale } = useI18n();

const years = computed(() => `2025-${new Date().getFullYear()}`);

const doctorsPageLink = computed(() => ({
	name: 'doctors',
	query: getRegionalQuery(locale.value),
}));

const clinicsPageLink = computed(() => ({
	name: 'clinics',
	query: getRegionalQuery(locale.value),
}));

const labTestsPageLink = computed(() => ({
	name: 'labtests',
	query: getRegionalQuery(locale.value),
}));

const medicalServicesPageLink = computed(() => ({
	name: 'services',
	query: getRegionalQuery(locale.value),
}));

const medicationsPageLink = computed(() => ({
	name: 'medications',
	query: getRegionalQuery(locale.value),
}));

const aboutPageLink = computed(() => ({
	name: 'about',
	query: getRegionalQuery(locale.value),
}));

const svadLink = computed(() => {
	const url = new URL('https://svad.net/');
	const svadLocale = locale.value === 'sr-cyrl' ? 'sr' : locale.value;
	url.searchParams.set('country', 'me');
	url.searchParams.set('lang', svadLocale);
	url.searchParams.set('currency', 'eur');
	return url.toString();
});

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

<template>
	<div class="layout-wrapper">
		<AppHeader />

		<div class="layout-body">
			<slot />
		</div>

		<footer class="footer" :class="{ 'footer-tall': !isConsentDecided }">
			<div class="footer-content">
				<div class="footer-top">
					<div class="footer-brand">
						<div class="footer-brand__text">
							<div class="footer-brand__name">{{ SITE_NAME }}</div>
							<div class="footer-brand__tagline">{{ t('Tagline') }}</div>
							<div class="footer-brand__partner">
								<a
									class="footer-brand__partner-link"
									:href="svadLink"
									target="_blank"
									rel="noopener"
								>
									{{ t('SvadLinkLabel') }}
								</a>
								<span class="footer-brand__partner-note">
									— {{ t('SvadLinkNote') }}
								</span>
							</div>
						</div>
					</div>

					<nav class="footer-nav" :aria-label="t('FooterNavLabel')">
						<NuxtLink class="footer-link" :to="doctorsPageLink">
							{{ t('Doctors') }}
						</NuxtLink>
						<NuxtLink class="footer-link" :to="clinicsPageLink">
							{{ t('Clinics') }}
						</NuxtLink>
						<NuxtLink class="footer-link" :to="labTestsPageLink">
							{{ t('LabTests') }}
						</NuxtLink>
						<NuxtLink class="footer-link" :to="medicalServicesPageLink">
							{{ t('MedicalServices') }}
						</NuxtLink>
						<NuxtLink class="footer-link" :to="medicationsPageLink">
							{{ t('Medications') }}
						</NuxtLink>
						<NuxtLink
							class="footer-link footer-link--muted"
							:to="aboutPageLink"
						>
							{{ t('AboutProject') }}
						</NuxtLink>
					</nav>

					<div class="footer-contacts">
						<div class="footer-contacts__title">{{ t('ContactsTitle') }}</div>
						<div class="footer-contacts__actions">
							<NuxtLink
								class="footer-contact"
								:to="`mailto:${PROJECT_CONTACTS.email}`"
								target="_blank"
								:aria-label="t('ContactUs')"
							>
								<span class="icon email-icon" aria-hidden="true"></span>
								<span class="footer-contact__label">{{ t('Email') }}</span>
							</NuxtLink>
							<NuxtLink
								class="footer-contact"
								:to="PROJECT_CONTACTS.telegram"
								target="_blank"
								:aria-label="t('NewsChannel')"
							>
								<span class="icon tg-icon" aria-hidden="true"></span>
								<span class="footer-contact__label">{{ t('Telegram') }}</span>
							</NuxtLink>
						</div>
					</div>
				</div>

				<div class="footer-bottom">
					<div class="footer-bottom__left">
						<span class="footer-bottom__muted"
							>© {{ years }} {{ SITE_NAME }}</span
						>
					</div>
					<div class="footer-bottom__right">
						<span class="footer-bottom__muted">{{ t('DisclaimerShort') }}</span>
					</div>
				</div>
				<div class="footer-partner footer-partner--mobile">
					<a
						class="footer-partner__link"
						:href="svadLink"
						target="_blank"
						rel="noopener"
					>
						{{ t('SvadLinkLabel') }}
					</a>
					<span class="footer-partner__note">— {{ t('SvadLinkNote') }}</span>
				</div>
			</div>
		</footer>

		<ClientOnly>
			<CookieBanner v-if="!isConsentDecided" />
			<CookieModal />
		</ClientOnly>
	</div>
</template>

<i18n lang="json">
{
	"en": {
		"FooterNavLabel": "Footer navigation",
		"Tagline": "Healthcare navigator for Montenegro",
		"Doctors": "Doctors",
		"Clinics": "Clinics",
		"LabTests": "Lab Tests",
		"MedicalServices": "Medical Services",
		"Medications": "Medications",
		"ContactsTitle": "Contacts",
		"Email": "Email",
		"Telegram": "Telegram",
		"DisclaimerShort": "Information only. Not medical advice.",
		"ContactUs": "Contact us by email",
		"NewsChannel": "Our news channel on Telegram",
		"AboutProject": "About",
		"SvadLinkLabel": "svad.net",
		"SvadLinkNote": "Aggregator of Montenegrin online shop products"
	},
	"ru": {
		"FooterNavLabel": "Навигация в футере",
		"Tagline": "Навигатор по медицине Черногории",
		"Doctors": "Врачи",
		"Clinics": "Клиники",
		"LabTests": "Анализы",
		"MedicalServices": "Услуги",
		"Medications": "Лекарства",
		"ContactsTitle": "Контакты",
		"Email": "Email",
		"Telegram": "Telegram",
		"DisclaimerShort": "Справочная информация. Не является медрекомендациями.",
		"ContactUs": "Связаться с нами по email",
		"NewsChannel": "Наш канал новостей в Telegram",
		"AboutProject": "О проекте",
		"SvadLinkLabel": "svad.net",
		"SvadLinkNote": "Агрегатор товаров из онлайн-магазинов Черногории"
	},
	"sr": {
		"FooterNavLabel": "Navigacija u podnožju",
		"Tagline": "Navigator za zdravstvo Crne Gore",
		"Doctors": "Lekari",
		"Clinics": "Klinike",
		"LabTests": "Analize",
		"MedicalServices": "Usluge",
		"Medications": "Lekovi",
		"ContactsTitle": "Kontakti",
		"Email": "Email",
		"Telegram": "Telegram",
		"DisclaimerShort": "Samo informativno. Nije medicinski savet.",
		"ContactUs": "Kontaktirajte nas putem emaila",
		"NewsChannel": "Naš kanal za vesti na Telegramu",
		"AboutProject": "O projektu",
		"SvadLinkLabel": "svad.net",
		"SvadLinkNote": "Agregator proizvoda iz online prodavnica Crne Gore"
	},
	"sr-cyrl": {
		"FooterNavLabel": "Навигација у подножју",
		"Tagline": "Навигатор за здравство Црне Горе",
		"Doctors": "Лекари",
		"Clinics": "Клинике",
		"LabTests": "Анализе",
		"MedicalServices": "Услуге",
		"Medications": "Лекови",
		"ContactsTitle": "Контакти",
		"Email": "Email",
		"Telegram": "Telegram",
		"DisclaimerShort": "Само информативно. Није медицински савет.",
		"ContactUs": "Контактирајте нас путем emaila",
		"NewsChannel": "Наш канал за вести на Телеграму",
		"AboutProject": "О пројекту",
		"SvadLinkLabel": "svad.net",
		"SvadLinkNote": "Агрегатор производа из онлајн продавница Црне Горе"
	},
	"de": {
		"FooterNavLabel": "Footer-Navigation",
		"Tagline": "Gesundheitsnavigator für Montenegro",
		"Doctors": "Ärzte",
		"Clinics": "Kliniken",
		"LabTests": "Labortests",
		"MedicalServices": "Medizinische Dienstleistungen",
		"Medications": "Medikamente",
		"ContactsTitle": "Kontakt",
		"Email": "E-Mail",
		"Telegram": "Telegram",
		"DisclaimerShort": "Nur Information. Keine medizinische Beratung.",
		"ContactUs": "Kontaktieren Sie uns per E-Mail",
		"NewsChannel": "Unser Nachrichtenkanal auf Telegram",
		"AboutProject": "Über",
		"SvadLinkLabel": "svad.net",
		"SvadLinkNote": "Aggregator für Produkte aus Online-Shops in Montenegro"
	},
	"tr": {
		"FooterNavLabel": "Altbilgi gezinme",
		"Tagline": "Karadağ sağlık rehberi",
		"Doctors": "Doktorlar",
		"Clinics": "Klinikler",
		"LabTests": "Laboratuvar Testleri",
		"MedicalServices": "Tıbbi Hizmetler",
		"Medications": "İlaçlar",
		"ContactsTitle": "İletişim",
		"Email": "E-posta",
		"Telegram": "Telegram",
		"DisclaimerShort": "Bilgilendirme amaçlıdır. Tıbbi tavsiye değildir.",
		"ContactUs": "Bize e-posta ile ulaşın",
		"NewsChannel": "Telegram'daki haber kanalımız",
		"AboutProject": "Hakkında",
		"SvadLinkLabel": "svad.net",
		"SvadLinkNote": "Karadağ çevrimiçi mağaza ürünleri toplayıcısı"
	}
}
</i18n>

<style lang="less">
:root {
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

.layout-wrapper {
	display: flex;
	flex-direction: column;
	min-height: 100vh;
	min-height: 100dvh;
}

.footer {
	width: 100%;
	margin-top: 16px;

	&.footer-tall {
		margin-bottom: 80vh;
	}

	.footer-content {
		box-sizing: border-box;
		width: 100%;
		border-top: 1px solid var(--color-border-secondary);
		background: linear-gradient(
			180deg,
			var(--color-bg-primary) 0%,
			var(--color-bg-secondary) 100%
		);
		padding: var(--spacing-2xl);
		display: flex;
		flex-direction: column;
		gap: var(--spacing-xl);

		.footer-top {
			display: flex;
			align-items: flex-start;
			justify-content: space-between;
			gap: var(--spacing-2xl);
		}

		.footer-brand {
			display: flex;
			align-items: center;
			gap: var(--spacing-md);
			min-width: 220px;

			&__logo {
				width: 92px;
				height: 28px;
				background-image: url('/logo-site.png');
				background-size: contain;
				background-repeat: no-repeat;
				background-position: left center;
				flex-shrink: 0;
			}

			&__name {
				font-weight: var(--font-weight-semibold);
				color: var(--color-text-primary);
				line-height: 1.2;
			}

			&__tagline {
				margin-top: var(--spacing-xs);
				font-size: var(--font-size-sm);
				color: var(--color-text-muted);
				line-height: 1.4;
				max-width: 360px;
			}

			&__partner {
				margin-top: var(--spacing-md);
				padding-top: var(--spacing-sm);
				border-top: 1px solid var(--color-border-light);
				display: flex;
				flex-wrap: wrap;
				gap: var(--spacing-xs);
				font-size: var(--font-size-sm);
				color: var(--color-text-light);
				line-height: 1.4;
			}

			&__partner-link {
				color: var(--color-text-muted);
				text-decoration: none;

				&:hover {
					color: var(--color-primary);
					text-decoration: underline;
				}
			}

			&__partner-note {
				color: var(--color-text-light);
			}
		}

		.footer-partner {
			display: flex;
			flex-wrap: wrap;
			gap: var(--spacing-xs);
			font-size: var(--font-size-sm);
			color: var(--color-text-light);
			line-height: 1.4;

			&__link {
				color: var(--color-text-muted);
				text-decoration: none;

				&:hover {
					color: var(--color-primary);
					text-decoration: underline;
				}
			}

			&__note {
				color: var(--color-text-light);
			}

			&--mobile {
				display: none;
				margin-top: var(--spacing-md);
				padding-top: var(--spacing-sm);
				border-top: 1px solid var(--color-border-light);
			}
		}

		.footer-nav {
			display: grid;
			grid-template-columns: repeat(2, minmax(140px, 1fr));
			gap: var(--spacing-sm) var(--spacing-xl);
			align-content: start;
		}

		.footer-link {
			color: var(--color-text-secondary);
			text-decoration: none;
			font-size: var(--font-size-md);
			line-height: 1.4;
			padding: var(--spacing-xs) 0;

			&:hover {
				color: var(--color-primary);
				text-decoration: underline;
			}

			&--muted {
				color: var(--color-text-muted);
			}
		}

		.footer-contacts {
			min-width: 180px;

			&__title {
				font-size: var(--font-size-sm);
				color: var(--color-text-muted);
				margin-bottom: var(--spacing-sm);
				font-weight: var(--font-weight-medium);
			}

			&__actions {
				display: flex;
				flex-direction: column;
				gap: var(--spacing-sm);
			}
		}

		.footer-contact {
			display: inline-flex;
			align-items: center;
			gap: var(--spacing-sm);
			text-decoration: none;
			color: var(--color-text-secondary);
			font-size: var(--font-size-sm);

			&:hover {
				color: var(--color-primary);
			}

			&__label {
				white-space: nowrap;
			}
		}

		.icon {
			width: 20px;
			height: 20px;
			background-size: contain;
			background-repeat: no-repeat;

			&.tg-icon {
				background-image: url('/tg.png');
			}

			&.email-icon {
				background-image: url('/email.png');
			}
		}

		.footer-bottom {
			display: flex;
			align-items: center;
			justify-content: space-between;
			gap: var(--spacing-lg);
			padding-top: var(--spacing-lg);
			border-top: 1px solid var(--color-border-light);

			&__muted {
				color: var(--color-text-light);
				font-size: var(--font-size-sm);
				line-height: 1.4;
			}
		}
	}
}

@media (max-width: 900px) {
	.footer {
		.footer-content {
			padding: var(--spacing-xl);

			.footer-top {
				flex-direction: column;
				gap: var(--spacing-xl);
			}

			.footer-nav {
				grid-template-columns: repeat(3, minmax(120px, 1fr));
			}

			.footer-bottom {
				flex-direction: column;
				align-items: flex-start;
			}

			.footer-brand__partner {
				display: none;
			}

			.footer-partner--mobile {
				display: flex;
			}
		}
	}
}

@media (max-width: 520px) {
	.footer {
		.footer-content {
			padding: var(--spacing-lg);

			.footer-nav {
				grid-template-columns: repeat(2, minmax(120px, 1fr));
				gap: var(--spacing-sm) var(--spacing-lg);
			}
		}
	}
}

.layout-body {
	width: 100%;
	margin: 0 auto;
	display: flex;
	flex-direction: column;
	flex-grow: 1;
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
