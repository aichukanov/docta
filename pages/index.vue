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
		</div>
	</div>
</template>

<i18n lang="json">
{
	"en": {
		"MainPageTitle": "Healthcare Services in Montenegro",
		"MainPageDescription": "Find doctors, clinics, and laboratory services in Montenegro",
		"Doctors": "Doctors",
		"DoctorsDescription": "Find qualified doctors by specialty, city, and language",
		"Clinics": "Clinics",
		"ClinicsDescription": "Medical clinics and healthcare facilities across Montenegro",
		"LabTests": "Lab Tests",
		"LabTestsDescription": "Information about laboratory tests and services"
	},
	"ru": {
		"MainPageTitle": "Медицинские услуги в Черногории",
		"MainPageDescription": "Найдите врачей, клиники и лабораторные услуги в Черногории",
		"Doctors": "Врачи",
		"DoctorsDescription": "Найдите квалифицированных врачей по специальности, городу и языку",
		"Clinics": "Клиники",
		"ClinicsDescription": "Медицинские клиники и учреждения здравоохранения по всей Черногории",
		"LabTests": "Лабораторные анализы",
		"LabTestsDescription": "Информация о лабораторных тестах и услугах"
	},
	"sr": {
		"MainPageTitle": "Medicinske usluge u Crnoj Gori",
		"MainPageDescription": "Pronađite lekare, klinike i laboratorijske usluge u Crnoj Gori",
		"Doctors": "Lekari",
		"DoctorsDescription": "Pronađite kvalifikovane lekare po specijalnosti, gradu i jeziku",
		"Clinics": "Klinike",
		"ClinicsDescription": "Medicinske klinike i zdravstvene ustanove širom Crne Gore",
		"LabTests": "Laboratorijske analize",
		"LabTestsDescription": "Informacije o laboratorijskim testovima i uslugama"
	},
	"de": {
		"MainPageTitle": "Gesundheitsdienste in Montenegro",
		"MainPageDescription": "Finden Sie Ärzte, Kliniken und Labordienstleistungen in Montenegro",
		"Doctors": "Ärzte",
		"DoctorsDescription": "Finden Sie qualifizierte Ärzte nach Fachgebiet, Stadt und Sprache",
		"Clinics": "Kliniken",
		"ClinicsDescription": "Medizinische Kliniken und Gesundheitseinrichtungen in Montenegro",
		"LabTests": "Labortests",
		"LabTestsDescription": "Informationen über Labortests und Dienstleistungen"
	},
	"tr": {
		"MainPageTitle": "Karadağ'da Sağlık Hizmetleri",
		"MainPageDescription": "Karadağ'da doktor, klinik ve laboratuvar hizmetleri bulun",
		"Doctors": "Doktorlar",
		"DoctorsDescription": "Uzmanlık, şehir ve dile göre nitelikli doktorlar bulun",
		"Clinics": "Klinikler",
		"ClinicsDescription": "Karadağ genelinde tıbbi klinikler ve sağlık tesisleri",
		"LabTests": "Laboratuvar Testleri",
		"LabTestsDescription": "Laboratuvar testleri ve hizmetleri hakkında bilgi"
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
	border: 1px solid rgba(0, 0, 0, 0.06);
	border-radius: var(--border-radius-lg);
	text-decoration: none;
	color: inherit;
	transition: all 0.2s ease;

	&:hover {
		border-color: #4f46e5;
		box-shadow: 0 4px 12px rgba(79, 70, 229, 0.1);
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
