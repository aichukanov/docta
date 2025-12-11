<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';

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
	name: 'lab-tests',
	query: getRegionalQuery(locale.value),
}));

const medicalServicesPageLink = computed(() => ({
	name: 'medical-services',
	query: getRegionalQuery(locale.value),
}));

const medicationsPageLink = computed(() => ({
	name: 'medications',
	query: getRegionalQuery(locale.value),
}));

useSeoMeta({
	title: t('MainPageTitle'),
	description: t('MainPageDescription'),
});
</script>

<template>
	<div class="main-page">
		<section class="hero">
			<div class="hero__content">
				<h1 class="hero__title">{{ t('MainPageTitle') }}</h1>
				<p class="hero__subtitle">{{ t('MainPageDescription') }}</p>
			</div>
		</section>

		<section class="bento">
			<NuxtLink :to="doctorsPageLink" class="bento__card bento__card--primary">
				<div class="bento__icon">
					<IconDoctor />
				</div>
				<div class="bento__text">
					<h2 class="bento__title">{{ t('Doctors') }}</h2>
					<p class="bento__desc">{{ t('DoctorsDescription') }}</p>
				</div>
				<span class="bento__arrow">→</span>
			</NuxtLink>

			<NuxtLink
				:to="clinicsPageLink"
				class="bento__card bento__card--secondary"
			>
				<div class="bento__icon">
					<IconClinic />
				</div>
				<div class="bento__text">
					<h2 class="bento__title">{{ t('Clinics') }}</h2>
					<p class="bento__desc">{{ t('ClinicsDescription') }}</p>
				</div>
				<span class="bento__arrow">→</span>
			</NuxtLink>

			<NuxtLink :to="labTestsPageLink" class="bento__card">
				<div class="bento__icon">
					<IconLabTest />
				</div>
				<div class="bento__text">
					<h2 class="bento__title">{{ t('LabTests') }}</h2>
					<p class="bento__desc">{{ t('LabTestsDescription') }}</p>
				</div>
				<span class="bento__arrow">→</span>
			</NuxtLink>

			<NuxtLink :to="medicalServicesPageLink" class="bento__card">
				<div class="bento__icon">
					<IconMedicalService />
				</div>
				<div class="bento__text">
					<h2 class="bento__title">{{ t('MedicalServices') }}</h2>
					<p class="bento__desc">{{ t('MedicalServicesDescription') }}</p>
				</div>
				<span class="bento__arrow">→</span>
			</NuxtLink>

			<NuxtLink :to="medicationsPageLink" class="bento__card">
				<div class="bento__icon">
					<IconMedication />
				</div>
				<div class="bento__text">
					<h2 class="bento__title">{{ t('Medications') }}</h2>
					<p class="bento__desc">{{ t('MedicationsDescription') }}</p>
				</div>
				<span class="bento__arrow">→</span>
			</NuxtLink>
		</section>
	</div>
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
		"MedicationsDescription": "Find pharmacies and where to buy medications"
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
		"MedicationsDescription": "Найдите аптеки и где купить лекарства"
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
		"MedicationsDescription": "Pronađite apoteke i gde kupiti lekove"
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
		"MedicationsDescription": "Finden Sie Apotheken und wo Sie Medikamente kaufen können"
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
		"MedicationsDescription": "Eczaneleri ve ilaçları nereden alacağınızı bulun"
	}
}
</i18n>

<style lang="less" scoped>
@import url('~/assets/css/vars.less');

.main-page {
	min-height: calc(100vh - 60px);
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
