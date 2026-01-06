<script setup lang="ts">
import { SITE_URL, OG_IMAGE } from '~/common/constants';
import { getRegionalQuery } from '~/common/url-utils';
import { getLocalizedName } from '~/common/utils';
import {
	buildBreadcrumbsSchema,
	buildCollectionPageSchemas,
	buildTopListItemElements,
} from '~/common/schema-org-builders';
import { combineI18nMessages } from '~/i18n/utils';
import { LanguageId } from '~/enums/language';
import type { ClinicData } from '~/interfaces/clinic';

import articlesI18n from '~/i18n/articles';
import breadcrumbI18n from '~/i18n/breadcrumb';
import languageI18n from '~/i18n/language';
import cityI18n from '~/i18n/city';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		articlesI18n,
		breadcrumbI18n,
		languageI18n,
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
	{ label: t('ClinicsWithLanguageSupportTitle') },
]);

const getClinicUrl = (id: number) => ({
	name: 'clinics-clinicId',
	params: { clinicId: id },
	query: getRegionalQuery(locale.value),
});

const schemaOrgStore = useSchemaOrgStore();
const pageUrl = `${SITE_URL}/articles/clinics-with-language-support`;

// 2. Fetch clinic data
const clinicsStore = useClinicsStore();
await clinicsStore.fetchClinics();

// Languages to display (excluding Serbian as it's the default)
const displayLanguages = [
	LanguageId.EN,
	LanguageId.RU,
	LanguageId.DE,
	LanguageId.TR,
	LanguageId.IT,
	LanguageId.FR,
];

// Group clinics by language
const groupedClinics = computed(() => {
	const groups: Array<{
		languageId: number;
		name: string;
		clinics: ClinicData[];
	}> = [];

	displayLanguages.forEach((langId) => {
		const clinicsWithLang = clinicsStore.clinics.filter((clinic) => {
			if (!clinic.languageIds) return false;
			const langIds = clinic.languageIds.split(',').map(Number);
			return langIds.includes(langId);
		});

		if (clinicsWithLang.length > 0) {
			groups.push({
				languageId: langId,
				name: t(`language_${langId}`),
				clinics: clinicsWithLang.sort((a, b) => a.name.localeCompare(b.name)),
			});
		}
	});

	return groups;
});

const totalClinicsCount = computed(() => {
	const uniqueClinicIds = new Set<number>();
	groupedClinics.value.forEach((group) => {
		group.clinics.forEach((clinic) => uniqueClinicIds.add(clinic.id));
	});
	return uniqueClinicIds.size;
});

// 3. Set SEO and Schema.org
const pageTitle = computed(() => t('ClinicsWithLanguageSupportTitle'));
const pageDescription = computed(() =>
	t('ClinicsWithLanguageSupportDescription'),
);
const articleImage = `${SITE_URL}/img/articles/clinics-with-language-support.webp`;

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
	// Flatten all clinics for schema
	const allClinics = clinicsStore.clinics.filter((clinic) => {
		if (!clinic.languageIds) return false;
		const langIds = clinic.languageIds.split(',').map(Number);
		return displayLanguages.some((lang) => langIds.includes(lang));
	});

	schemaOrgStore.setSchemas([
		...buildCollectionPageSchemas({
			pageUrl,
			locale: locale.value,
			title: t('ClinicsWithLanguageSupportTitle'),
			description: t('ClinicsWithLanguageSupportDescription'),
			numberOfItems: totalClinicsCount.value,
			itemListElement: buildTopListItemElements(
				allClinics.slice(0, 20).map((c) => ({ id: c.id, name: c.name })),
				{
					baseUrl: SITE_URL,
					buildPath: (c) => `/clinics/${c.id}`,
				},
			),
		}),
		buildBreadcrumbsSchema(pageUrl, [
			{ name: t('BreadcrumbHome'), url: `${SITE_URL}/` },
			{ name: t('BreadcrumbArticles'), url: `${SITE_URL}/articles` },
			{ name: t('ClinicsWithLanguageSupportTitle') },
		]),
	]);
});
</script>

<template>
	<div class="article-detail-page">
		<div class="container">
			<AppBreadcrumbs :items="breadcrumbItems" />

			<h1>{{ t('ClinicsWithLanguageSupportTitle') }}</h1>

			<p class="description">
				{{ t('ClinicsWithLanguageSupportDescription') }}
			</p>

			<div class="languages-list">
				<section
					v-for="group in groupedClinics"
					:key="group.languageId"
					class="language-block"
				>
					<h2 class="language-title">
						{{ group.name }} ({{ group.clinics.length }})
					</h2>
					<div class="clinics-grid">
						<NuxtLink
							v-for="clinic in group.clinics"
							:key="clinic.id"
							:to="getClinicUrl(clinic.id)"
							class="clinic-card"
						>
							<span class="clinic-name">{{
								getLocalizedName(clinic, locale)
							}}</span>
							<span class="clinic-city">{{ t(`city_${clinic.cityId}`) }}</span>
						</NuxtLink>
					</div>
				</section>
			</div>
		</div>
	</div>
</template>

<style scoped lang="less">
@import '~/assets/css/vars.less';

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
		margin-bottom: 32px;
		font-size: 16px;
		line-height: 1.6;
		color: #4b5563;
		max-width: 600px;
	}
}

.container {
	max-width: 900px;
	margin: 0 auto;
	padding: 0 16px;
}

.languages-list {
	display: flex;
	flex-direction: column;
	gap: 40px;
}

.language-title {
	margin: 0 0 20px;
	padding-bottom: 8px;
	font-size: 20px;
	font-weight: 700;
	color: #111827;
	border-bottom: 2px solid #f3f4f6;
	text-transform: capitalize;
}

.clinics-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
	gap: 12px;
}

.clinic-card {
	display: flex;
	flex-direction: column;
	gap: 4px;
	padding: 16px;
	background: #fff;
	border-radius: 10px;
	text-decoration: none;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
	border: 1px solid #f3f4f6;
	transition: all 0.15s ease;

	&:hover {
		border-color: #e0e7ff;
		box-shadow: 0 4px 12px rgba(79, 70, 229, 0.08);
		transform: translateY(-1px);
	}
}

.clinic-name {
	font-size: 15px;
	font-weight: 600;
	color: #4f46e5;
	line-height: 1.3;
}

.clinic-city {
	font-size: 13px;
	color: #6b7280;
}

@media (max-width: 600px) {
	.clinics-grid {
		grid-template-columns: 1fr;
	}
}
</style>
