<script setup lang="ts">
import { SITE_URL, OG_IMAGE } from '~/common/constants';
import { getRegionalQuery } from '~/common/url-utils';
import { getLocalizedName } from '~/common/utils';
import {
	buildBreadcrumbsSchema,
	buildMedicalWebPageSchema,
} from '~/common/schema-org-builders';
import { combineI18nMessages } from '~/i18n/utils';
import { LanguageId } from '~/enums/language';
import type { DoctorData } from '~/interfaces/doctor';

import articlesI18n from '~/i18n/articles';
import breadcrumbI18n from '~/i18n/breadcrumb';
import specialtyI18n from '~/i18n/specialty';
import cityI18n from '~/i18n/city';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		articlesI18n,
		breadcrumbI18n,
		specialtyI18n,
		cityI18n,
	]),
});

// 1. Define links and basic data
const homeLink = computed(() => ({
	name: 'index',
	query: getRegionalQuery(locale.value),
}));

const articlesLink = computed(() => ({
	name: 'articles',
	query: getRegionalQuery(locale.value),
}));

const breadcrumbItems = computed(() => [
	{ label: t('BreadcrumbHome'), to: homeLink.value },
	{ label: t('BreadcrumbArticles'), to: articlesLink.value },
	{ label: t('RussianSpeakingDoctorsTitle') },
]);

const getDoctorUrl = (id: number) => ({
	name: 'doctors-doctorId',
	params: { doctorId: id },
	query: getRegionalQuery(locale.value),
});

const getClinicUrl = (id: number) => ({
	name: 'clinics-clinicId',
	params: { clinicId: id },
	query: getRegionalQuery(locale.value),
});

const schemaOrgStore = useSchemaOrgStore();
const pageUrl = `${SITE_URL}/articles/russian-speaking-doctors-in-montenegro`;

// 2. Fetch and prepare doctor data
const clinicsStore = useClinicsStore();
await clinicsStore.fetchClinics();

const { data: doctorsData } = await useFetch('/api/doctors/list', {
	method: 'POST',
	body: computed(() => ({
		languageIds: [String(LanguageId.RU)],
		onlyDoctorLanguages: true,
		locale: locale.value,
	})),
});

const doctors = computed(() => doctorsData.value?.doctors || []);

const getDoctorClinics = (doctor: DoctorData) => {
	return clinicsStore.getClinicsByIds(doctor.clinicIds);
};

// Group doctors by specialties
const groupedDoctors = computed(() => {
	const groups: Record<number, DoctorData[]> = {};

	doctors.value.forEach((doctor) => {
		const specialtyIds = doctor.specialtyIds
			? doctor.specialtyIds.split(',').map(Number)
			: [];
		specialtyIds.forEach((id) => {
			if (!groups[id]) {
				groups[id] = [];
			}
			groups[id].push(doctor);
		});
	});

	// Sort specialties by name
	return Object.keys(groups)
		.map(Number)
		.sort((a, b) => t(`doctors_${a}`).localeCompare(t(`doctors_${b}`)))
		.map((id) => ({
			id,
			name: t(`doctors_${id}`),
			doctors: groups[id].sort((a, b) => a.name.localeCompare(b.name)),
		}));
});

// 3. Set SEO and Schema.org
const pageTitle = computed(() => t('RussianSpeakingDoctorsTitle'));
const pageDescription = computed(() => t('RussianSpeakingDoctorsDescription'));
const articleImage = `${SITE_URL}/img/articles/russian-speaking-doctors.webp`;

useSeoMeta({
	title: pageTitle,
	description: pageDescription,
	ogTitle: pageTitle,
	ogDescription: pageDescription,
	ogImage: articleImage,
	ogUrl: pageUrl,
	twitterCard: 'summary',
	twitterTitle: pageTitle,
	twitterDescription: pageDescription,
	twitterImage: articleImage,
});

watchEffect(() => {
	schemaOrgStore.setSchemas([
		...buildMedicalWebPageSchema({
			siteUrl: SITE_URL,
			pageUrl,
			locale: locale.value,
			title: t('RussianSpeakingDoctorsTitle'),
			description: t('RussianSpeakingDoctorsDescription'),
			image: articleImage,
			datePublished: '2025-12-31',
			dateModified: '2025-12-31',
			lastReviewed: '2025-12-31',
			totalCount: doctors.value.length,
			doctors: doctors.value,
			getSpecialtyName: (id) => t(`specialty_${id}`),
		}),
		buildBreadcrumbsSchema(pageUrl, [
			{ name: t('BreadcrumbHome'), url: `${SITE_URL}/` },
			{ name: t('BreadcrumbArticles'), url: `${SITE_URL}/articles` },
			{ name: t('RussianSpeakingDoctorsTitle') },
		]),
	]);
});
</script>

<template>
	<div class="article-detail-page">
		<div class="container">
			<AppBreadcrumbs :items="breadcrumbItems" />

			<h1>{{ t('RussianSpeakingDoctorsTitle') }}</h1>

			<p class="description">{{ t('RussianSpeakingDoctorsDescription') }}</p>

			<div class="article-image">
				<img
					src="/img/articles/russian-speaking-doctors.webp"
					:alt="t('RussianSpeakingDoctorsTitle')"
					loading="lazy"
				/>
			</div>

			<div class="specialties-list">
				<section
					v-for="group in groupedDoctors"
					:key="group.id"
					class="specialty-block"
				>
					<h2 class="specialty-title">{{ group.name }}</h2>
					<div class="doctors-list">
						<div
							v-for="doctor in group.doctors"
							:key="doctor.id"
							class="doctor-item"
						>
							<NuxtLink :to="getDoctorUrl(doctor.id)" class="doctor-name">
								{{ getLocalizedName(doctor, locale) }}
							</NuxtLink>
							<ul class="clinics-list">
								<li
									v-for="clinic in getDoctorClinics(doctor)"
									:key="clinic.id"
									class="clinic-item"
								>
									<NuxtLink :to="getClinicUrl(clinic.id)" class="clinic-link">
										{{ getLocalizedName(clinic, locale) }},
										{{ t(`city_${clinic.cityId}`) }}
									</NuxtLink>
								</li>
							</ul>
						</div>
					</div>
				</section>
			</div>
		</div>
	</div>
</template>

<style scoped lang="less">
.article-detail-page {
	padding: 24px 0 48px;

	h1 {
		margin: 16px 0 12px;
		font-size: 28px;
		font-weight: 800;
		line-height: 1.2;
		color: #111827;
	}

	.description {
		margin-bottom: 24px;
		font-size: 16px;
		line-height: 1.6;
		color: #4b5563;
		max-width: 600px;
	}
}

.article-image {
	margin-bottom: 40px;
	border-radius: 12px;
	overflow: hidden;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);

	img {
		display: block;
		width: 100%;
		height: auto;
		max-height: 400px;
		object-fit: cover;
	}
}

.container {
	max-width: 800px;
	margin: 0 auto;
	padding: 0 16px;
}

.specialties-list {
	display: flex;
	flex-direction: column;
	gap: 40px;
}

.specialty-title {
	margin: 0 0 20px;
	padding-bottom: 8px;
	font-size: 20px;
	font-weight: 700;
	color: #111827;
	border-bottom: 2px solid #f3f4f6;
}

.doctors-list {
	display: flex;
	flex-direction: column;
	gap: 24px;
}

.doctor-item {
	display: flex;
	flex-direction: column;
	gap: 4px;
}

.doctor-name {
	font-size: 16px;
	font-weight: 600;
	color: #4f46e5;
	text-decoration: none;

	&:hover {
		text-decoration: underline;
	}
}

.clinics-list {
	margin: 0;
	padding: 0;
	list-style: none;
	display: flex;
	flex-direction: column;
	gap: 2px;
}

.clinic-item {
	font-size: 14px;
	color: #6b7280;

	&::before {
		content: '— ';
		color: #d1d5db;
	}
}

.clinic-link {
	color: inherit;
	text-decoration: none;

	&:hover {
		color: #111827;
		text-decoration: underline;
	}
}
</style>
