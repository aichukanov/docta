<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import { PROJECT_CONTACTS, SITE_NAME } from '~/common/constants';

const { isConsentGiven } = useCookieControl();
const { t } = useI18n();
const { locale } = useI18n({ useScope: 'global' });

const years = computed(() => `2025`); //  - ${new Date().getFullYear()}

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

		<div class="footer" :class="{ 'footer-tall': !isConsentGiven }">
			<div class="footer-content">
				<div class="footer-top">
					<div class="footer-brand">
						<div class="footer-brand__text">
							<div class="footer-brand__name">{{ SITE_NAME }}</div>
							<div class="footer-brand__tagline">{{ t('Tagline') }}</div>
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
			</div>
		</div>

		<ClientOnly>
			<CookieBanner v-if="!isConsentGiven" />
			<CookieModal />
		</ClientOnly>
	</div>
</template>

<i18n lang="json">
{
	"en": {
		"FooterNavLabel": "Footer navigation",
		"Tagline": "Healthcare in Montenegro — in one place",
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
		"AboutProject": "About"
	},
	"ru": {
		"FooterNavLabel": "Навигация в футере",
		"Tagline": "Медицина в Черногории — в одном месте",
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
		"AboutProject": "О проекте"
	},
	"sr": {
		"FooterNavLabel": "Navigacija u podnožju",
		"Tagline": "Zdravstvo u Crnoj Gori — na jednom mjestu",
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
		"AboutProject": "O projektu"
	},
	"de": {
		"FooterNavLabel": "Footer-Navigation",
		"Tagline": "Gesundheit in Montenegro — an einem Ort",
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
		"AboutProject": "Über"
	},
	"tr": {
		"FooterNavLabel": "Altbilgi gezinme",
		"Tagline": "Karadağ'da sağlık — tek yerde",
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
		"AboutProject": "Hakkında"
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

	--color-text-heading: #0f172a;
	--color-text-primary: #333333;
	--color-text-secondary: #475569;
	--color-text-muted: #64748b;
	--color-text-light: #94a3b8;

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
		border-top: 1px solid var(--color-border-secondary);
		background: linear-gradient(
			180deg,
			var(--color-bg-primary) 0%,
			var(--color-bg-secondary) 100%
		);
		padding: var(--spacing-2xl);
		min-width: 300px;
		max-width: 1600px;
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
