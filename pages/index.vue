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
		<div class="hero-section">
			<h1 class="hero-title">{{ t('MainPageTitle') }}</h1>
			<p class="hero-description">{{ t('MainPageDescription') }}</p>
		</div>

		<div class="cards-container">
			<NuxtLink :to="doctorsPageLink" class="category-card">
				<div class="card-icon">
					<IconDoctor />
				</div>
				<h2 class="card-title">{{ t('Doctors') }}</h2>
				<p class="card-description">{{ t('DoctorsDescription') }}</p>
			</NuxtLink>

			<NuxtLink :to="clinicsPageLink" class="category-card">
				<div class="card-icon">
					<IconMapPin />
				</div>
				<h2 class="card-title">{{ t('Clinics') }}</h2>
				<p class="card-description">{{ t('ClinicsDescription') }}</p>
			</NuxtLink>

			<NuxtLink :to="labTestsPageLink" class="category-card">
				<div class="card-icon">
					<IconSearch />
				</div>
				<h2 class="card-title">{{ t('LabTests') }}</h2>
				<p class="card-description">{{ t('LabTestsDescription') }}</p>
			</NuxtLink>

			<NuxtLink :to="medicalServicesPageLink" class="category-card">
				<div class="card-icon">
					<IconCheck />
				</div>
				<h2 class="card-title">{{ t('MedicalServices') }}</h2>
				<p class="card-description">{{ t('MedicalServicesDescription') }}</p>
			</NuxtLink>

			<NuxtLink :to="medicationsPageLink" class="category-card">
				<div class="card-icon">
					<svg
						xmlns="http://www.w3.org/2000/svg"
						viewBox="0 0 24 24"
						fill="none"
						stroke="currentColor"
						stroke-width="2"
						stroke-linecap="round"
						stroke-linejoin="round"
					>
						<rect x="4" y="4" width="16" height="16" rx="2" />
						<path d="M12 8v8" />
						<path d="M8 12h8" />
					</svg>
				</div>
				<h2 class="card-title">{{ t('Medications') }}</h2>
				<p class="card-description">{{ t('MedicationsDescription') }}</p>
			</NuxtLink>
		</div>
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
		"MedicationsDescription": "Information about medications and pharmaceuticals"
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
		"MedicationsDescription": "Информация о лекарственных препаратах"
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
		"MedicationsDescription": "Informacije o lekovima i farmaceutskim proizvodima"
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
		"MedicationsDescription": "Informationen über Medikamente und Arzneimittel"
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
		"MedicationsDescription": "İlaçlar ve farmasötik ürünler hakkında bilgi"
	}
}
</i18n>

<style lang="less" scoped>
@import url('~/assets/css/vars.less');

.main-page {
	display: flex;
	flex-direction: column;
	align-items: center;
	padding: var(--spacing-2xl) var(--spacing-lg);
	max-width: 1200px;
	margin: 0 auto;
	gap: var(--spacing-2xl);
	min-height: calc(100vh - 120px);
	background: #f9fafb;
}

.hero-section {
	text-align: center;
	max-width: 800px;
}

.hero-title {
	font-size: 2.5rem;
	font-weight: 700;
	color: #1f2937;
	margin: 0 0 var(--spacing-lg) 0;
	font-family: system-ui, -apple-system, sans-serif;
}

.hero-description {
	font-size: var(--font-size-lg);
	color: #6b7280;
	margin: 0;
	line-height: 1.6;
}

.cards-container {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
	gap: var(--spacing-2xl);
	width: 100%;
}

.category-card {
	display: flex;
	flex-direction: column;
	align-items: center;
	text-align: center;
	padding: var(--spacing-2xl);
	background: #ffffff;
	border: 1px solid rgba(0, 0, 0, 0.08);
	border-radius: 8px;
	text-decoration: none;
	color: inherit;
	transition: all 0.2s ease;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);

	&:hover {
		border-color: #4f46e5;
		box-shadow: 0 4px 12px rgba(79, 70, 229, 0.12);
		transform: translateY(-2px);
	}
}

.card-icon {
	width: 64px;
	height: 64px;
	display: flex;
	align-items: center;
	justify-content: center;
	background: #eef2ff;
	border-radius: var(--border-radius-lg);
	margin-bottom: var(--spacing-lg);
	color: #4f46e5;

	:deep(svg) {
		width: 32px;
		height: 32px;
	}
}

.card-title {
	font-size: var(--font-size-xl);
	font-weight: 600;
	color: #1f2937;
	margin: 0 0 var(--spacing-sm) 0;
	font-family: system-ui, -apple-system, sans-serif;
}

.card-description {
	font-size: var(--font-size-md);
	color: #6b7280;
	margin: 0;
	line-height: 1.5;
}

@media (max-width: 768px) {
	.hero-title {
		font-size: 2rem;
	}

	.hero-description {
		font-size: var(--font-size-md);
	}

	.cards-container {
		grid-template-columns: 1fr;
		gap: var(--spacing-lg);
	}

	.main-page {
		padding: var(--spacing-lg) var(--spacing-md);
	}
}
</style>
