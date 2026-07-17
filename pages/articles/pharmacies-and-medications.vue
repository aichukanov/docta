<script setup lang="ts">
import { SITE_URL } from '~/common/constants';
import { getRegionalQuery, getRegionalUrl } from '~/common/url-utils';
import {
	buildBreadcrumbsSchema,
	buildMedicalWebPageSchema,
} from '~/common/schema-org-builders';
import { combineI18nMessages } from '~/i18n/utils';

import articlesI18n from '~/i18n/articles';
import articlePharmaciesI18n from '~/i18n/article-pharmacies';
import breadcrumbI18n from '~/i18n/breadcrumb';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		articlesI18n,
		articlePharmaciesI18n,
		breadcrumbI18n,
	]),
});

const ARTICLE_SLUG = 'pharmacies-and-medications';

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
	{ label: t('PharmaciesTitle') },
]);

const doctorsLink = computed(() => ({
	name: 'doctors',
	query: getRegionalQuery(locale.value),
}));

const medicationsLink = computed(() => ({
	name: 'medications',
	query: getRegionalQuery(locale.value),
}));

const medicinesLink = computed(() => ({
	name: 'medicines',
	query: getRegionalQuery(locale.value),
}));

const adrenalineMedicineLink = computed(() => ({
	name: 'medicines',
	query: {
		...getRegionalQuery(locale.value),
		name: 'LIDOKAIN 2% - ADRENALIN GALENIKA',
	},
}));

const healthcareArticleLink = computed(() => ({
	path: '/articles/healthcare-system-in-montenegro',
	query: getRegionalQuery(locale.value),
}));

// Секции статьи: id → ключи заголовков для TOC и разметки
const SECTION_IDS = [
	'pharmacies',
	'prescriptions',
	'fond-list',
	'analogs',
	'sources',
] as const;

const articleToc = computed(() =>
	SECTION_IDS.map((id) => ({
		id: `section-${id}`,
		label: t(`PhaToc_${id}`),
	})),
);

// CTA: каталог лекарств
const articleCta = computed(() => ({
	title: t('PhaCtaTitle'),
	text: t('PhaCtaText'),
	button: t('PhaCtaButton'),
	link: medicationsLink.value,
}));

const schemaOrgStore = useSchemaOrgStore();
const pageUrl = computed(() =>
	getRegionalUrl(`${SITE_URL}/articles/${ARTICLE_SLUG}`, {}, locale.value),
);

// 2. SEO and Schema.org
const pageTitle = computed(() => t('PharmaciesTitle'));
const pageDescription = computed(() => t('PharmaciesDescription'));
const articleImage = `${SITE_URL}/img/articles/pharmacies-and-medications.webp`;

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
			title: t('PharmaciesTitle'),
			description: t('PharmaciesDescription'),
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
			{ name: t('PharmaciesTitle') },
		]),
	]);
});
</script>

<template>
	<ArticlePage
		:breadcrumbs="breadcrumbItems"
		:title="t('PharmaciesTitle')"
		:description="t('PharmaciesDescription')"
		image="/img/articles/pharmacies-and-medications.webp"
		:toc="articleToc"
		:cta="articleCta"
	>
		<ArticleSection id="section-pharmacies" :title="t('PhaToc_pharmacies')">
			<p>{{ t('PhaPharmacies1') }}</p>
			<p>{{ t('PhaPharmacies2') }}</p>
			<p>{{ t('PhaPharmacies3') }}</p>
			<p>
				{{ t('PhaPharmacies4') }}
				<NuxtLink :to="adrenalineMedicineLink">{{
					t('PhaPharmacies4Link')
				}}</NuxtLink
				>{{ t('PhaPharmacies4End') }}
			</p>
		</ArticleSection>

		<ArticleSection
			id="section-prescriptions"
			:title="t('PhaToc_prescriptions')"
		>
			<p>{{ t('PhaPrescriptions1') }}</p>
			<p>{{ t('PhaPrescriptions2') }}</p>
			<p>{{ t('PhaPrescriptions3') }}</p>
			<p>{{ t('PhaPrescriptions4') }}</p>
		</ArticleSection>

		<ArticleSection id="section-fond-list" :title="t('PhaToc_fond-list')">
			<p>{{ t('PhaFond1') }}</p>
			<p>{{ t('PhaFond2') }}</p>
			<p>
				{{ t('PhaFond3') }}
				<NuxtLink :to="healthcareArticleLink">{{ t('PhaFond3Link') }}</NuxtLink
				>{{ t('PhaFond3End') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-analogs" :title="t('PhaToc_analogs')">
			<p>{{ t('PhaAnalogs1') }}</p>
			<p>
				{{ t('PhaAnalogs2') }}
				<NuxtLink :to="medicinesLink">{{ t('PhaAnalogs2Link') }}</NuxtLink
				>{{ t('PhaAnalogs2Mid') }}
				<NuxtLink :to="medicationsLink">{{ t('PhaAnalogs2Link2') }}</NuxtLink
				>{{ t('PhaAnalogs2End') }}
			</p>
			<p>{{ t('PhaAnalogs3') }}</p>
			<p>{{ t('PhaAnalogs4') }}</p>
		</ArticleSection>

		<ArticleSection id="section-sources" :title="t('PhaToc_sources')">
			<p>{{ t('PhaSources0') }}</p>
			<ul>
				<li>
					<a
						href="https://montefarm.co.me"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('PhaSourcesMontefarm') }}</a
					>
				</li>
				<li>
					<a
						href="https://fzocg.me/lista-ljekova/"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('PhaSourcesFzo') }}</a
					>
				</li>
				<li>
					<a
						href="https://www.ezdravlje.me"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('PhaSourcesEzdravlje') }}</a
					>
				</li>
				<li>
					<a
						href="https://cinmed.me"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('PhaSourcesCinmed') }}</a
					>
				</li>
				<li>
					<a
						href="https://benu.me"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('PhaSourcesBenu') }}</a
					>
				</li>
			</ul>
			<p>
				{{ t('PhaSourcesCatalog') }}
				<NuxtLink :to="doctorsLink">{{
					t('PhaSourcesCatalogLink')
				}}</NuxtLink
				>{{ t('PhaSourcesCatalogEnd') }}
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
