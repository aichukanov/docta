<script setup lang="ts">
import { SITE_URL } from '~/common/constants';
import { getRegionalQuery, getRegionalUrl } from '~/common/url-utils';
import {
	buildBreadcrumbsSchema,
	buildMedicalWebPageSchema,
} from '~/common/schema-org-builders';
import { combineI18nMessages } from '~/i18n/utils';

import articlesI18n from '~/i18n/articles';
import articleTouristHealthcareI18n from '~/i18n/article-tourist-healthcare';
import breadcrumbI18n from '~/i18n/breadcrumb';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		articlesI18n,
		articleTouristHealthcareI18n,
		breadcrumbI18n,
	]),
});

const ARTICLE_SLUG = 'tourist-healthcare-in-montenegro';

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

// 1. Links and basic data
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
	{ label: t('TouristHealthcareTitle') },
]);

const clinicsLink = computed(() => ({
	name: 'clinics',
	query: getRegionalQuery(locale.value),
}));

const labtestsLink = computed(() => ({
	name: 'labtests',
	query: getRegionalQuery(locale.value),
}));

const healthcareArticleLink = computed(() => ({
	path: '/articles/healthcare-system-in-montenegro',
	query: getRegionalQuery(locale.value),
}));

// Секции статьи: id → ключи заголовков для TOC и разметки
const SECTION_IDS = [
	'emergency',
	'where-to-go',
	'costs',
	'agreements',
	'insurance',
	'pharmacies',
	'sources',
] as const;

const articleToc = computed(() =>
	SECTION_IDS.map((id) => ({
		id: `section-${id}`,
		label: t(`ThcToc_${id}`),
	})),
);

// CTA: каталог клиник
const articleCta = computed(() => ({
	title: t('CtaClinicsTitle'),
	text: t('CtaClinicsText'),
	button: t('CtaClinicsButton'),
	link: clinicsLink.value,
}));

const schemaOrgStore = useSchemaOrgStore();
const pageUrl = computed(() =>
	getRegionalUrl(`${SITE_URL}/articles/${ARTICLE_SLUG}`, {}, locale.value),
);

// 2. SEO and Schema.org
const pageTitle = computed(() => t('TouristHealthcareTitle'));
const pageDescription = computed(() => t('TouristHealthcareDescription'));
const articleImage = `${SITE_URL}/img/articles/tourist-healthcare-in-montenegro.webp`;

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
			title: t('TouristHealthcareTitle'),
			description: t('TouristHealthcareDescription'),
			image: articleImage,
			datePublished: '2026-07-16',
			dateModified: '2026-07-16',
			lastReviewed: '2026-07-16',
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
			{ name: t('TouristHealthcareTitle') },
		]),
	]);
});
</script>

<template>
	<ArticlePage
		:breadcrumbs="breadcrumbItems"
		:title="t('TouristHealthcareTitle')"
		:description="t('TouristHealthcareDescription')"
		image="/img/articles/tourist-healthcare-in-montenegro.webp"
		:toc="articleToc"
		:cta="articleCta"
	>
		<ArticleSection id="section-emergency" :title="t('ThcToc_emergency')">
			<p>{{ t('ThcEmergency1') }}</p>
			<p>{{ t('ThcEmergency2') }}</p>
			<p>{{ t('ThcEmergency3') }}</p>
		</ArticleSection>

		<ArticleSection id="section-where-to-go" :title="t('ThcToc_where-to-go')">
			<p>{{ t('ThcWhere1') }}</p>
			<p>
				{{ t('ThcWhere2') }}
				<NuxtLink :to="clinicsLink">{{ t('ThcWhere2Link') }}</NuxtLink
				>{{ t('ThcWhere2End') }}
			</p>
			<p>{{ t('ThcWhere3') }}</p>
			<p>{{ t('ThcWhere4') }}</p>
		</ArticleSection>

		<ArticleSection id="section-costs" :title="t('ThcToc_costs')">
			<p>{{ t('ThcCosts1') }}</p>
			<p>{{ t('ThcCosts2') }}</p>
			<p>{{ t('ThcCosts3') }}</p>
		</ArticleSection>

		<ArticleSection id="section-agreements" :title="t('ThcToc_agreements')">
			<p>{{ t('ThcAgreements1') }}</p>
			<p>{{ t('ThcAgreements2') }}</p>
			<p>{{ t('ThcAgreements3') }}</p>
			<p>{{ t('ThcAgreements4') }}</p>
		</ArticleSection>

		<ArticleSection id="section-insurance" :title="t('ThcToc_insurance')">
			<p>{{ t('ThcInsurance1') }}</p>
			<p>{{ t('ThcInsurance2') }}</p>
			<p>{{ t('ThcInsurance3') }}</p>
		</ArticleSection>

		<ArticleSection id="section-pharmacies" :title="t('ThcToc_pharmacies')">
			<p>{{ t('ThcPharmacies1') }}</p>
			<p>{{ t('ThcPharmacies2') }}</p>
			<p>
				{{ t('ThcPharmacies3') }}
				<NuxtLink :to="labtestsLink">{{ t('ThcPharmacies3Link') }}</NuxtLink
				>{{ t('ThcPharmacies3End') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-sources" :title="t('ThcToc_sources')">
			<p>{{ t('ThcSources0') }}</p>
			<ul>
				<li>{{ t('ThcSourcesPhones') }}</li>
				<li>
					<a
						href="https://fzocg.me"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('ThcSourcesFzo') }}</a
					>
				</li>
				<li>
					<a
						href="https://www.gov.uk/guidance/uk-reciprocal-healthcare-agreements-with-non-eu-countries"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('ThcSourcesGovUk') }}</a
					>
				</li>
				<li>
					<a
						href="https://www.dvka.de/media/dokumente/merkblaetter/urlaub-im-ausland/urlaub_montenegro.pdf"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('ThcSourcesDvka') }}</a
					>
				</li>
			</ul>
			<p>
				{{ t('ThcSourcesGuide') }}
				<NuxtLink :to="healthcareArticleLink">{{
					t('ThcSourcesGuideLink')
				}}</NuxtLink
				>{{ t('ThcSourcesGuideEnd') }}
			</p>
		</ArticleSection>
	</ArticlePage>
</template>

<style scoped lang="less">
p {
	margin: 0 0 var(--spacing-lg);
	font-size: var(--font-size-base);
	line-height: 1.7;
	color: var(--color-text-secondary);

	&:last-child {
		margin-bottom: 0;
	}

	a {
		color: var(--color-primary);

		&:hover {
			text-decoration: none;
		}
	}
}

ul {
	margin: 0 0 var(--spacing-lg);
	padding-left: var(--spacing-xl);
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);

	li {
		font-size: var(--font-size-base);
		line-height: 1.7;
		color: var(--color-text-secondary);
	}
}
</style>
