<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import { SITE_URL, SITE_NAME, OG_IMAGE } from '~/common/constants';

const { t, locale } = useI18n();

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

const pageTitle = computed(() => t('MainPageTitle'));
const pageDescription = computed(() => t('MainPageDescription'));

useSeoMeta({
	title: pageTitle,
	description: pageDescription,
	ogTitle: pageTitle,
	ogDescription: pageDescription,
	ogImage: OG_IMAGE,
	ogUrl: SITE_URL,
	twitterCard: 'summary',
	twitterTitle: pageTitle,
	twitterDescription: pageDescription,
	twitterImage: OG_IMAGE,
});

// Schema.org for website home page
const schemaOrgStore = useSchemaOrgStore();

schemaOrgStore.setSchemas([
	{
		'@type': 'WebSite',
		'@id': `${SITE_URL}#website`,
		'name': SITE_NAME,
		'inLanguage': locale.value,
		'url': SITE_URL,
		'potentialAction': {
			'@type': 'SearchAction',
			'target': {
				'@type': 'EntryPoint',
				'urlTemplate': `${SITE_URL}/doctors?name={search_term_string}`,
			},
			'query-input': 'required name=search_term_string',
		},
	},
	{
		'@type': 'MedicalBusiness',
		'@id': `${SITE_URL}#organization`,
		'name': SITE_NAME,
		'url': SITE_URL,
		'description': t('MainPageDescription'),
		'address': {
			'@type': 'PostalAddress',
			'addressCountry': 'ME',
		},
	},
]);
</script>

<template>
	<main class="main-page" role="main" :aria-label="t('AriaMainContent')">
		<section class="hero" :aria-label="t('AriaHeroSection')">
			<div class="hero__content">
				<h1 class="hero__title">{{ t('MainPageTitle') }}</h1>
				<p class="hero__subtitle">{{ t('MainPageDescription') }}</p>
				<div class="hero__search">
					<GlobalSearch />
				</div>
			</div>
		</section>

		<nav class="bento" :aria-label="t('AriaNavigationCards')">
			<NuxtLink
				:to="doctorsPageLink"
				class="bento__card bento__card--primary"
				:aria-label="t('AriaLinkToDoctors')"
			>
				<div class="bento__icon" aria-hidden="true">
					<IconDoctor />
				</div>
				<div class="bento__text">
					<h2 class="bento__title">{{ t('Doctors') }}</h2>
					<p class="bento__desc">{{ t('DoctorsDescription') }}</p>
				</div>
				<span class="bento__arrow" aria-hidden="true">→</span>
			</NuxtLink>

			<NuxtLink
				:to="clinicsPageLink"
				class="bento__card bento__card--secondary"
				:aria-label="t('AriaLinkToClinics')"
			>
				<div class="bento__icon" aria-hidden="true">
					<IconClinic />
				</div>
				<div class="bento__text">
					<h2 class="bento__title">{{ t('Clinics') }}</h2>
					<p class="bento__desc">{{ t('ClinicsDescription') }}</p>
				</div>
				<span class="bento__arrow" aria-hidden="true">→</span>
			</NuxtLink>

			<NuxtLink
				:to="labTestsPageLink"
				class="bento__card"
				:aria-label="t('AriaLinkToLabTests')"
			>
				<div class="bento__icon" aria-hidden="true">
					<IconLabTest />
				</div>
				<div class="bento__text">
					<h2 class="bento__title">{{ t('LabTests') }}</h2>
					<p class="bento__desc">{{ t('LabTestsDescription') }}</p>
				</div>
				<span class="bento__arrow" aria-hidden="true">→</span>
			</NuxtLink>

			<NuxtLink
				:to="medicalServicesPageLink"
				class="bento__card"
				:aria-label="t('AriaLinkToServices')"
			>
				<div class="bento__icon" aria-hidden="true">
					<IconMedicalService />
				</div>
				<div class="bento__text">
					<h2 class="bento__title">{{ t('MedicalServices') }}</h2>
					<p class="bento__desc">{{ t('MedicalServicesDescription') }}</p>
				</div>
				<span class="bento__arrow" aria-hidden="true">→</span>
			</NuxtLink>

			<NuxtLink
				:to="medicationsPageLink"
				class="bento__card"
				:aria-label="t('AriaLinkToMedications')"
			>
				<div class="bento__icon" aria-hidden="true">
					<IconMedication />
				</div>
				<div class="bento__text">
					<h2 class="bento__title">{{ t('Medications') }}</h2>
					<p class="bento__desc">{{ t('MedicationsDescription') }}</p>
				</div>
				<span class="bento__arrow" aria-hidden="true">→</span>
			</NuxtLink>
		</nav>
	</main>
</template>

<i18n lang="json">
{
	"en": {
		"MainPageTitle": "Healthcare Services in Montenegro",
		"MainPageDescription": "Find doctors, clinics, laboratory services, medical services, and medications in Montenegro",
		"Doctors": "Doctors",
		"DoctorsDescription": "Find qualified doctors by specialty, city, and language",
		"Clinics": "Clinics",
		"ClinicsDescription": "Medical clinics and healthcare facilities across Montenegro",
		"LabTests": "Lab Tests",
		"LabTestsDescription": "Information about laboratory tests and services",
		"MedicalServices": "Medical Services",
		"MedicalServicesDescription": "Healthcare services and procedures available in Montenegro",
		"Medications": "Medications",
		"MedicationsDescription": "Find pharmacies and where to buy medications",
		"AriaMainContent": "Main content",
		"AriaHeroSection": "Welcome section",
		"AriaNavigationCards": "Navigation to site sections",
		"AriaLinkToDoctors": "Go to doctors directory",
		"AriaLinkToClinics": "Go to clinics directory",
		"AriaLinkToLabTests": "Go to laboratory tests",
		"AriaLinkToServices": "Go to medical services",
		"AriaLinkToMedications": "Go to medications catalog"
	},
	"ru": {
		"MainPageTitle": "Медицинские услуги в Черногории",
		"MainPageDescription": "Найдите врачей, клиники, лабораторные услуги, медицинские процедуры и лекарства в Черногории",
		"Doctors": "Врачи",
		"DoctorsDescription": "Найдите квалифицированных врачей по специальности, городу и языку",
		"Clinics": "Клиники",
		"ClinicsDescription": "Медицинские клиники и учреждения здравоохранения по всей Черногории",
		"LabTests": "Лабораторные анализы",
		"LabTestsDescription": "Информация о лабораторных тестах и услугах",
		"MedicalServices": "Медицинские услуги",
		"MedicalServicesDescription": "Медицинские услуги и процедуры, доступные в Черногории",
		"Medications": "Лекарства",
		"MedicationsDescription": "Найдите аптеки и где купить лекарства",
		"AriaMainContent": "Основное содержимое",
		"AriaHeroSection": "Приветственный раздел",
		"AriaNavigationCards": "Навигация по разделам сайта",
		"AriaLinkToDoctors": "Перейти к каталогу врачей",
		"AriaLinkToClinics": "Перейти к каталогу клиник",
		"AriaLinkToLabTests": "Перейти к лабораторным анализам",
		"AriaLinkToServices": "Перейти к медицинским услугам",
		"AriaLinkToMedications": "Перейти к каталогу лекарств"
	},
	"sr": {
		"MainPageTitle": "Medicinske usluge u Crnoj Gori",
		"MainPageDescription": "Pronađite lekare, klinike, laboratorijske usluge, medicinske procedure i lekove u Crnoj Gori",
		"Doctors": "Lekari",
		"DoctorsDescription": "Pronađite kvalifikovane lekare po specijalnosti, gradu i jeziku",
		"Clinics": "Klinike",
		"ClinicsDescription": "Medicinske klinike i zdravstvene ustanove širom Crne Gore",
		"LabTests": "Laboratorijske analize",
		"LabTestsDescription": "Informacije o laboratorijskim testovima i uslugama",
		"MedicalServices": "Medicinske usluge",
		"MedicalServicesDescription": "Medicinske usluge i procedure dostupne u Crnoj Gori",
		"Medications": "Lekovi",
		"MedicationsDescription": "Pronađite apoteke i gde kupiti lekove",
		"AriaMainContent": "Glavni sadržaj",
		"AriaHeroSection": "Sekcija dobrodošlice",
		"AriaNavigationCards": "Navigacija do sekcija sajta",
		"AriaLinkToDoctors": "Idi na direktorijum lekara",
		"AriaLinkToClinics": "Idi na direktorijum klinika",
		"AriaLinkToLabTests": "Idi na laboratorijske analize",
		"AriaLinkToServices": "Idi na medicinske usluge",
		"AriaLinkToMedications": "Idi na katalog lekova"
	},
	"de": {
		"MainPageTitle": "Gesundheitsdienste in Montenegro",
		"MainPageDescription": "Finden Sie Ärzte, Kliniken, Labordienstleistungen, medizinische Verfahren und Medikamente in Montenegro",
		"Doctors": "Ärzte",
		"DoctorsDescription": "Finden Sie qualifizierte Ärzte nach Fachgebiet, Stadt und Sprache",
		"Clinics": "Kliniken",
		"ClinicsDescription": "Medizinische Kliniken und Gesundheitseinrichtungen in Montenegro",
		"LabTests": "Labortests",
		"LabTestsDescription": "Informationen über Labortests und Dienstleistungen",
		"MedicalServices": "Medizinische Dienstleistungen",
		"MedicalServicesDescription": "Medizinische Dienstleistungen und Verfahren in Montenegro",
		"Medications": "Medikamente",
		"MedicationsDescription": "Finden Sie Apotheken und wo Sie Medikamente kaufen können",
		"AriaMainContent": "Hauptinhalt",
		"AriaHeroSection": "Willkommensbereich",
		"AriaNavigationCards": "Navigation zu Websitebereichen",
		"AriaLinkToDoctors": "Zum Ärzteverzeichnis",
		"AriaLinkToClinics": "Zum Klinikverzeichnis",
		"AriaLinkToLabTests": "Zu Labortests",
		"AriaLinkToServices": "Zu medizinischen Dienstleistungen",
		"AriaLinkToMedications": "Zum Medikamentenkatalog"
	},
	"tr": {
		"MainPageTitle": "Karadağ'da Sağlık Hizmetleri",
		"MainPageDescription": "Karadağ'da doktor, klinik, laboratuvar hizmetleri, tıbbi prosedürler ve ilaçlar bulun",
		"Doctors": "Doktorlar",
		"DoctorsDescription": "Uzmanlık, şehir ve dile göre nitelikli doktorlar bulun",
		"Clinics": "Klinikler",
		"ClinicsDescription": "Karadağ genelinde tıbbi klinikler ve sağlık tesisleri",
		"LabTests": "Laboratuvar Testleri",
		"LabTestsDescription": "Laboratuvar testleri ve hizmetleri hakkında bilgi",
		"MedicalServices": "Tıbbi Hizmetler",
		"MedicalServicesDescription": "Karadağ'da mevcut tıbbi hizmetler ve prosedürler",
		"Medications": "İlaçlar",
		"MedicationsDescription": "Eczaneleri ve ilaçları nereden alacağınızı bulun",
		"AriaMainContent": "Ana içerik",
		"AriaHeroSection": "Karşılama bölümü",
		"AriaNavigationCards": "Site bölümlerine navigasyon",
		"AriaLinkToDoctors": "Doktor rehberine git",
		"AriaLinkToClinics": "Klinik rehberine git",
		"AriaLinkToLabTests": "Laboratuvar testlerine git",
		"AriaLinkToServices": "Tıbbi hizmetlere git",
		"AriaLinkToMedications": "İlaç kataloğuna git"
	},
	"sr-cyrl": {
		"MainPageTitle": "Медицинске услуге у Црној Гори",
		"MainPageDescription": "Пронађите лекаре, клинике, лабораторијске услуге, медицинске процедуре и лекове у Црној Гори",
		"Doctors": "Лекари",
		"DoctorsDescription": "Пронађите квалификоване лекаре по специјалности, граду и језику",
		"Clinics": "Клинике",
		"ClinicsDescription": "Медицинске клинике и здравствене установе широм Црне Горе",
		"LabTests": "Лабораторијске анализе",
		"LabTestsDescription": "Информације о лабораторијским тестовима и услугама",
		"MedicalServices": "Медицинске услуге",
		"MedicalServicesDescription": "Медицинске услуге и процедуре доступне у Црној Гори",
		"Medications": "Лекови",
		"MedicationsDescription": "Пронађите аптеке и где купити лекове",
		"AriaMainContent": "Главни садржај",
		"AriaHeroSection": "Секција добродошлице",
		"AriaNavigationCards": "Навигација до секција сајта",
		"AriaLinkToDoctors": "Иди на директоријум лекара",
		"AriaLinkToClinics": "Иди на директоријум клиника",
		"AriaLinkToLabTests": "Иди на лабораторијске анализе",
		"AriaLinkToServices": "Иди на медицинске услуге",
		"AriaLinkToMedications": "Иди на каталог лекова"
	}
}
</i18n>

<style lang="less" scoped>
@import url('~/assets/css/vars.less');

.main-page {
	min-height: calc(100vh - 320px);
	background: linear-gradient(180deg, #fafbff 0%, #f0f4ff 100%);
}

// Hero Section
.hero {
	padding: 60px @base-padding 40px;
	text-align: center;

	&__content {
		max-width: 680px;
		margin: 0 auto;
	}

	&__title {
		font-size: clamp(1.75rem, 5vw, 2.75rem);
		font-weight: 700;
		color: #0f172a;
		margin: 0 0 16px;
		letter-spacing: -0.02em;
		line-height: 1.2;
	}

	&__subtitle {
		font-size: clamp(1rem, 2.5vw, 1.125rem);
		color: #64748b;
		margin: 0;
		line-height: 1.6;
	}

	&__search {
		margin-top: 32px;
	}
}

// Bento Grid
.bento {
	display: grid;
	grid-template-columns: repeat(2, 1fr);
	grid-template-rows: auto;
	gap: 16px;
	max-width: 900px;
	margin: 0 auto;
	padding: 0 @base-padding 60px;

	&__card {
		position: relative;
		display: flex;
		flex-direction: column;
		padding: 24px;
		background: #fff;
		border-radius: 20px;
		text-decoration: none;
		color: inherit;
		border: 1px solid rgba(0, 0, 0, 0.04);
		box-shadow: 0 1px 2px rgba(0, 0, 0, 0.04), 0 4px 16px rgba(0, 0, 0, 0.04);
		transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
		overflow: hidden;

		&::before {
			content: '';
			position: absolute;
			inset: 0;
			background: linear-gradient(
				135deg,
				transparent 60%,
				rgba(79, 70, 229, 0.03)
			);
			opacity: 0;
			transition: opacity 0.3s ease;
		}

		&:hover {
			transform: translateY(-4px);
			box-shadow: 0 4px 8px rgba(0, 0, 0, 0.04),
				0 12px 32px rgba(79, 70, 229, 0.12);
			border-color: rgba(79, 70, 229, 0.2);

			&::before {
				opacity: 1;
			}

			.bento__arrow {
				transform: translateX(4px);
				opacity: 1;
			}

			.bento__icon {
				transform: scale(1.05);
			}
		}

		// Primary card - spans full width
		&--primary {
			grid-column: 1 / -1;
			flex-direction: row;
			align-items: center;
			gap: 24px;
			background: linear-gradient(135deg, #4f46e5 0%, #6366f1 100%);
			border: none;

			.bento__icon {
				background: rgba(255, 255, 255, 0.2);
				color: #fff;
				width: 64px;
				height: 64px;
				flex-shrink: 0;

				:deep(svg) {
					width: 32px;
					height: 32px;
				}
			}

			.bento__title {
				color: #fff;
				font-size: 1.5rem;
			}

			.bento__desc {
				color: rgba(255, 255, 255, 0.85);
			}

			.bento__arrow {
				color: #fff;
				font-size: 1.5rem;
			}

			&:hover {
				box-shadow: 0 8px 16px rgba(79, 70, 229, 0.3),
					0 16px 48px rgba(79, 70, 229, 0.2);
			}
		}

		// Secondary card - accent style
		&--secondary {
			background: linear-gradient(135deg, #f0fdf4 0%, #dcfce7 100%);
			border-color: rgba(34, 197, 94, 0.2);

			.bento__icon {
				background: rgba(34, 197, 94, 0.15);
				color: #16a34a;
			}

			&:hover {
				border-color: rgba(34, 197, 94, 0.4);
				box-shadow: 0 4px 8px rgba(0, 0, 0, 0.04),
					0 12px 32px rgba(34, 197, 94, 0.15);
			}
		}
	}

	&__icon {
		width: 48px;
		height: 48px;
		display: flex;
		align-items: center;
		justify-content: center;
		background: #eef2ff;
		border-radius: 14px;
		color: #4f46e5;
		margin-bottom: 16px;
		transition: transform 0.3s ease;

		:deep(svg) {
			width: 24px;
			height: 24px;
		}
	}

	&__text {
		flex: 1;
	}

	&__title {
		font-size: 1.125rem;
		font-weight: 600;
		color: #0f172a;
		margin: 0 0 6px;
		letter-spacing: -0.01em;
	}

	&__desc {
		font-size: 0.875rem;
		color: #64748b;
		margin: 0;
		line-height: 1.5;
	}

	&__arrow {
		position: absolute;
		right: 24px;
		top: 50%;
		transform: translateY(-50%);
		font-size: 1.25rem;
		color: #94a3b8;
		opacity: 0;
		transition: all 0.3s ease;
	}
}

// Responsive
@media (max-width: 640px) {
	.hero {
		padding: 40px @base-padding 24px;

		&__search {
			margin-top: 24px;
		}
	}

	.bento {
		grid-template-columns: 1fr;
		padding: 0 @base-offset 40px;

		&__card {
			padding: 20px;

			&--primary {
				flex-direction: column;
				align-items: flex-start;
				gap: 16px;

				.bento__icon {
					width: 52px;
					height: 52px;

					:deep(svg) {
						width: 26px;
						height: 26px;
					}
				}

				.bento__title {
					font-size: 1.25rem;
				}
			}
		}

		&__arrow {
			display: none;
		}
	}
}
</style>
