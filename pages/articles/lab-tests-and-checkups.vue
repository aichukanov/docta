<script setup lang="ts">
import { SITE_URL } from '~/common/constants';
import { getRegionalQuery, getRegionalUrl } from '~/common/url-utils';
import {
	buildBreadcrumbsSchema,
	buildMedicalWebPageSchema,
} from '~/common/schema-org-builders';
import { combineI18nMessages } from '~/i18n/utils';

import articlesI18n from '~/i18n/articles';
import articleLabtestsI18n from '~/i18n/article-labtests';
import breadcrumbI18n from '~/i18n/breadcrumb';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		articlesI18n,
		articleLabtestsI18n,
		breadcrumbI18n,
	]),
});

const ARTICLE_SLUG = 'lab-tests-and-checkups';

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
	{ label: t('LabTestsArticleTitle') },
]);

const clinicsLink = computed(() => ({
	name: 'clinics',
	query: getRegionalQuery(locale.value),
}));

const doctorsLink = computed(() => ({
	name: 'doctors',
	query: getRegionalQuery(locale.value),
}));

const servicesLink = computed(() => ({
	name: 'services',
	query: getRegionalQuery(locale.value),
}));

const labtestsLink = computed(() => ({
	name: 'labtests',
	query: getRegionalQuery(locale.value),
}));

// Секции статьи: id → ключи заголовков для TOC и разметки
const SECTION_IDS = [
	'private-labs',
	'state-route',
	'imaging',
	'checkups',
	'results',
	'sources',
] as const;

const articleToc = computed(() =>
	SECTION_IDS.map((id) => ({
		id: `section-${id}`,
		label: t(`LtcToc_${id}`),
	})),
);

// CTA: каталог анализов
const articleCta = computed(() => ({
	title: t('LtcCtaTitle'),
	text: t('LtcCtaText'),
	button: t('LtcCtaButton'),
	link: labtestsLink.value,
}));

const schemaOrgStore = useSchemaOrgStore();
const pageUrl = computed(() =>
	getRegionalUrl(`${SITE_URL}/articles/${ARTICLE_SLUG}`, {}, locale.value),
);

// 2. SEO and Schema.org
const pageTitle = computed(() => t('LabTestsArticleTitle'));
const pageDescription = computed(() => t('LabTestsArticleDescription'));
const articleImage = `${SITE_URL}/img/articles/lab-tests-and-checkups.webp`;

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
			title: t('LabTestsArticleTitle'),
			description: t('LabTestsArticleDescription'),
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
			{ name: t('LabTestsArticleTitle') },
		]),
	]);
});
</script>

<template>
	<ArticlePage
		:breadcrumbs="breadcrumbItems"
		:title="t('LabTestsArticleTitle')"
		:description="t('LabTestsArticleDescription')"
		image="/img/articles/lab-tests-and-checkups.webp"
		:toc="articleToc"
		:cta="articleCta"
	>
		<ArticleSection id="section-private-labs" :title="t('LtcToc_private-labs')">
			<p>{{ t('LtcPrivate1') }}</p>
			<p>{{ t('LtcPrivate2') }}</p>
			<p>{{ t('LtcPrivate3') }}</p>
			<p>
				{{ t('LtcPrivate4') }}
				<NuxtLink :to="labtestsLink">{{ t('LtcPrivate4Link') }}</NuxtLink
				>{{ t('LtcPrivate4End') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-state-route" :title="t('LtcToc_state-route')">
			<p>{{ t('LtcState1') }}</p>
			<p>{{ t('LtcState2') }}</p>
			<p>
				{{ t('LtcState3') }}
				<NuxtLink :to="servicesLink">{{ t('LtcState3Link') }}</NuxtLink
				>{{ t('LtcState3End') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-imaging" :title="t('LtcToc_imaging')">
			<p>{{ t('LtcImaging1') }}</p>
			<p>{{ t('LtcImaging2') }}</p>
			<p>{{ t('LtcImaging3') }}</p>
			<p>
				{{ t('LtcImaging4') }}
				<NuxtLink :to="clinicsLink">{{ t('LtcImaging4Link') }}</NuxtLink
				>{{ t('LtcImaging4End') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-checkups" :title="t('LtcToc_checkups')">
			<p>{{ t('LtcCheckup1') }}</p>
			<p>{{ t('LtcCheckup2') }}</p>
			<p>{{ t('LtcCheckup3') }}</p>
		</ArticleSection>

		<ArticleSection id="section-results" :title="t('LtcToc_results')">
			<p>{{ t('LtcResults1') }}</p>
			<p>{{ t('LtcResults2') }}</p>
			<p>{{ t('LtcResults3') }}</p>
		</ArticleSection>

		<ArticleSection id="section-sources" :title="t('LtcToc_sources')">
			<p>{{ t('LtcSources0') }}</p>
			<ul>
				<li>
					<a
						href="https://fzocg.me/liste-cekanja/"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('LtcSourcesFzo') }}</a
					>
				</li>
				<li>
					<a
						href="https://www.kccg.me/lista-cekanja/"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('LtcSourcesKccg') }}</a
					>
				</li>
				<li>
					<a
						href="https://www.ezdravlje.me"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('LtcSourcesEzdravlje') }}</a
					>
				</li>
				<li>
					<a
						href="https://www.uniqa.me/fizicka-lica/zdravlje/zdravstveno-osiguranje"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('LtcSourcesUniqa') }}</a
					>
				</li>
				<li>{{ t('LtcSourcesLabs') }}</li>
			</ul>
			<p>
				{{ t('LtcSourcesCatalog') }}
				<NuxtLink :to="doctorsLink">{{
					t('LtcSourcesCatalogLink')
				}}</NuxtLink
				>{{ t('LtcSourcesCatalogEnd') }}
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
