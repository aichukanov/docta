<script setup lang="ts">
import { SITE_URL } from '~/common/constants';
import { getRegionalQuery, getRegionalUrl } from '~/common/url-utils';
import { getLocalizedName } from '~/common/utils';
import {
	buildBreadcrumbsSchema,
	buildCollectionPageSchemas,
	buildTopListItemElements,
} from '~/common/schema-org-builders';
import { combineI18nMessages } from '~/i18n/utils';
import { CLINIC_SUPPORT_LANGUAGE_IDS } from '~/common/articles';
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

const ARTICLE_SLUG = 'clinics-with-language-support';

const { trackEvent } = useAnalytics();

provideAnalyticsEntity(
	computed(() => ({
		entity_type: 'article' as const,
		entity_id: ARTICLE_SLUG,
		entity_slug: ARTICLE_SLUG,
	})),
);

onMounted(() => {
	trackEvent('entity_viewed', {
		entity_type: 'article',
		entity_id: ARTICLE_SLUG,
		entity_slug: ARTICLE_SLUG,
	});
});

const trackClinicLinkClick = (clinic: ClinicData) => {
	trackEvent('entity_link_clicked', {
		entity_type: 'clinic',
		entity_id: clinic.id,
		entity_slug: clinic.slug,
		entity_name: clinic.name,
	});
};

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

const getClinicUrl = (slug: string) => ({
	name: 'clinics-clinicSlug',
	params: { clinicSlug: slug },
	query: getRegionalQuery(locale.value),
});

const schemaOrgStore = useSchemaOrgStore();
const pageUrl = computed(() =>
	getRegionalUrl(
		`${SITE_URL}/articles/clinics-with-language-support`,
		{},
		locale.value,
	),
);

// 2. Fetch clinic data
const clinicsStore = useClinicsStore();
await clinicsStore.fetchClinics();

const displayLanguages = CLINIC_SUPPORT_LANGUAGE_IDS;

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

const articleMeta = computed(() =>
	totalClinicsCount.value
		? t('ArticleMetaClinics', {
				languages: groupedClinics.value.length,
				clinics: totalClinicsCount.value,
			})
		: '',
);

const articleToc = computed(() =>
	groupedClinics.value.map((group) => ({
		id: `language-${group.languageId}`,
		label: group.name,
		count: group.clinics.length,
	})),
);

// CTA: каталог клиник с фильтрами по городу и языку
const articleCta = computed(() => ({
	title: t('CtaClinicsTitle'),
	text: t('CtaClinicsText'),
	button: t('CtaClinicsButton'),
	link: {
		name: 'clinics',
		query: getRegionalQuery(locale.value),
	},
}));

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
			pageUrl: pageUrl.value,
			locale: locale.value,
			title: t('ClinicsWithLanguageSupportTitle'),
			description: t('ClinicsWithLanguageSupportDescription'),
			numberOfItems: totalClinicsCount.value,
			itemListElement: buildTopListItemElements(
				allClinics
					.slice(0, 20)
					.map((c) => ({ id: c.id, slug: c.slug, name: c.name })),
				{
					baseUrl: SITE_URL,
					buildPath: (c) => `/clinics/${c.slug}`,
				},
			),
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
			{ name: t('ClinicsWithLanguageSupportTitle') },
		]),
	]);
});
</script>

<template>
	<ArticlePage
		:breadcrumbs="breadcrumbItems"
		:title="t('ClinicsWithLanguageSupportTitle')"
		:meta="articleMeta"
		:description="t('ClinicsWithLanguageSupportDescription')"
		image="/img/articles/clinics-with-language-support.webp"
		:toc="articleToc"
		:cta="articleCta"
	>
		<div>
			<p>{{ t('ClinicsWithLanguageSupportIntro1') }}</p>
			<p>{{ t('ClinicsWithLanguageSupportIntro2') }}</p>
		</div>

		<ArticleSection
			v-for="group in groupedClinics"
			:id="`language-${group.languageId}`"
			:key="group.languageId"
			:title="group.name"
			:count="group.clinics.length"
		>
			<div class="clinics-grid">
				<NuxtLink
					v-for="clinic in group.clinics"
					:key="clinic.id"
					:to="getClinicUrl(clinic.slug)"
					class="clinic-card"
					@click="trackClinicLinkClick(clinic)"
				>
					<span class="clinic-name">{{
						getLocalizedName(clinic, locale)
					}}</span>
					<span class="clinic-city">{{ t(`city_${clinic.cityId}`) }}</span>
				</NuxtLink>
			</div>
		</ArticleSection>
	</ArticlePage>
</template>

<style scoped lang="less">
.clinics-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
	gap: var(--spacing-md);
}

.clinic-card {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xs);
	padding: var(--spacing-md) var(--spacing-lg);
	background: var(--color-bg-tertiary);
	border-radius: var(--border-radius-xl);
	text-decoration: none;
	transition: background var(--transition-base);

	&:hover {
		background: var(--color-primary-bg);
	}
}

.clinic-name {
	font-size: var(--font-size-base);
	font-weight: var(--font-weight-semibold);
	color: var(--color-primary);
	line-height: 1.3;
}

.clinic-city {
	font-size: var(--font-size-sm);
	color: var(--color-text-muted);
}

@media (max-width: 600px) {
	.clinics-grid {
		grid-template-columns: 1fr;
	}
}
</style>
