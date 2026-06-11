<script setup lang="ts">
import { SITE_URL } from '~/common/constants';
import { getRegionalQuery, getRegionalUrl } from '~/common/url-utils';
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

const getDoctorUrl = (slug: string) => ({
	name: 'doctors-doctorSlug',
	params: { doctorSlug: slug },
	query: getRegionalQuery(locale.value),
});

const getClinicUrl = (slug: string) => ({
	name: 'clinics-clinicSlug',
	params: { clinicSlug: slug },
	query: getRegionalQuery(locale.value),
});

// CTA: каталог врачей с предустановленным фильтром «русский язык»
const articleCta = computed(() => ({
	title: t('CtaDoctorsTitle'),
	text: t('CtaDoctorsText'),
	button: t('CtaDoctorsButton'),
	link: {
		name: 'doctors',
		query: {
			languageIds: [String(LanguageId.RU)],
			...getRegionalQuery(locale.value),
		},
	},
}));

const schemaOrgStore = useSchemaOrgStore();
const pageUrl = computed(() =>
	getRegionalUrl(
		`${SITE_URL}/articles/russian-speaking-doctors-in-montenegro`,
		{},
		locale.value,
	),
);

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

const articleMeta = computed(() =>
	doctors.value.length
		? t('ArticleMetaDoctors', {
				doctors: doctors.value.length,
				specialties: groupedDoctors.value.length,
			})
		: '',
);

const articleToc = computed(() =>
	groupedDoctors.value.map((group) => ({
		id: `specialty-${group.id}`,
		label: group.name,
		count: group.doctors.length,
	})),
);

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
			pageUrl: pageUrl.value,
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
		buildBreadcrumbsSchema(pageUrl.value, [
			{
				name: t('BreadcrumbHome'),
				url: getRegionalUrl(`${SITE_URL}/`, {}, locale.value),
			},
			{
				name: t('BreadcrumbArticles'),
				url: getRegionalUrl(`${SITE_URL}/articles`, {}, locale.value),
			},
			{ name: t('RussianSpeakingDoctorsTitle') },
		]),
	]);
});
</script>

<template>
	<ArticlePage
		:breadcrumbs="breadcrumbItems"
		:title="t('RussianSpeakingDoctorsTitle')"
		:meta="articleMeta"
		:description="t('RussianSpeakingDoctorsDescription')"
		image="/img/articles/russian-speaking-doctors.webp"
		:toc="articleToc"
		:cta="articleCta"
	>
		<ArticleSection
			v-for="group in groupedDoctors"
			:id="`specialty-${group.id}`"
			:key="group.id"
			:title="group.name"
			:count="group.doctors.length"
		>
			<div class="doctors-list">
				<div
					v-for="doctor in group.doctors"
					:key="doctor.id"
					class="doctor-item"
				>
					<DoctorAvatar
						:name="getLocalizedName(doctor, locale)"
						:photoUrl="doctor.photoUrl"
						:size="44"
					/>
					<div class="doctor-info">
						<NuxtLink :to="getDoctorUrl(doctor.slug)" class="doctor-name">
							{{ getLocalizedName(doctor, locale) }}
						</NuxtLink>
						<ul class="clinics-list">
							<li
								v-for="clinic in getDoctorClinics(doctor)"
								:key="clinic.id"
								class="clinic-item"
							>
								<NuxtLink :to="getClinicUrl(clinic.slug)" class="clinic-link">
									{{ getLocalizedName(clinic, locale) }},
									{{ t(`city_${clinic.cityId}`) }}
								</NuxtLink>
							</li>
						</ul>
					</div>
				</div>
			</div>
		</ArticleSection>
	</ArticlePage>
</template>

<style scoped lang="less">
.doctors-list {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: var(--spacing-xl) var(--spacing-2xl);
}

.doctor-item {
	display: flex;
	align-items: flex-start;
	gap: var(--spacing-md);
}

.doctor-info {
	min-width: 0;
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xs);
}

.doctor-name {
	font-size: var(--font-size-base);
	font-weight: var(--font-weight-semibold);
	color: var(--color-primary);
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
	gap: var(--spacing-xs);
}

.clinic-item {
	font-size: var(--font-size-sm);
	color: var(--color-text-muted);
	line-height: 1.6;
}

.clinic-link {
	color: inherit;
	text-decoration: none;

	&:hover {
		color: var(--color-text-heading);
		text-decoration: underline;
	}
}

@media (max-width: 700px) {
	.doctors-list {
		grid-template-columns: 1fr;
	}
}
</style>
