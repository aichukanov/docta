<script setup lang="ts">
import { SITE_URL } from '~/common/constants';
import { getRegionalQuery, getRegionalUrl } from '~/common/url-utils';
import {
	buildBreadcrumbsSchema,
	buildMedicalWebPageSchema,
} from '~/common/schema-org-builders';
import { combineI18nMessages } from '~/i18n/utils';
import { DoctorSpecialty } from '~/enums/specialty';

import articlesI18n from '~/i18n/articles';
import articleBirthI18n from '~/i18n/article-birth-in-montenegro';
import breadcrumbI18n from '~/i18n/breadcrumb';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([articlesI18n, articleBirthI18n, breadcrumbI18n]),
});

const ARTICLE_SLUG = 'birth-in-montenegro';

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
	{ label: t('BirthInMontenegroTitle') },
]);

const clinicsLink = computed(() => ({
	name: 'clinics',
	query: getRegionalQuery(locale.value),
}));

const servicesLink = computed(() => ({
	name: 'services',
	query: getRegionalQuery(locale.value),
}));

// Каталог врачей с предустановленным фильтром «гинекология и акушерство»
const gynecologistsLink = computed(() => ({
	name: 'doctors',
	query: {
		specialtyIds: [String(DoctorSpecialty.GYNECOLOGY_OBSTETRICS)],
		...getRegionalQuery(locale.value),
	},
}));

// Секции статьи: id → ключи заголовков для TOC и разметки
const SECTION_IDS = [
	'prenatal',
	'where',
	'costs',
	'practical',
	'after',
	'sources',
] as const;

const articleToc = computed(() =>
	SECTION_IDS.map((id) => ({
		id: `section-${id}`,
		label: t(`BimToc_${id}`),
	})),
);

// CTA: каталог врачей-гинекологов
const articleCta = computed(() => ({
	title: t('BimCtaTitle'),
	text: t('BimCtaText'),
	button: t('BimCtaButton'),
	link: gynecologistsLink.value,
}));

const schemaOrgStore = useSchemaOrgStore();
const pageUrl = computed(() =>
	getRegionalUrl(`${SITE_URL}/articles/${ARTICLE_SLUG}`, {}, locale.value),
);

// 2. SEO and Schema.org
const pageTitle = computed(() => t('BirthInMontenegroTitle'));
const pageDescription = computed(() => t('BirthInMontenegroDescription'));
const articleImage = `${SITE_URL}/img/articles/birth-in-montenegro.webp`;

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
			title: t('BirthInMontenegroTitle'),
			description: t('BirthInMontenegroDescription'),
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
			{ name: t('BirthInMontenegroTitle') },
		]),
	]);
});
</script>

<template>
	<ArticlePage
		:breadcrumbs="breadcrumbItems"
		:title="t('BirthInMontenegroTitle')"
		:description="t('BirthInMontenegroDescription')"
		image="/img/articles/birth-in-montenegro.webp"
		:toc="articleToc"
		:cta="articleCta"
	>
		<ArticleSection id="section-prenatal" :title="t('BimToc_prenatal')">
			<p>{{ t('BimPrenatal1') }}</p>
			<p>{{ t('BimPrenatal2') }}</p>
			<p>{{ t('BimPrenatal3') }}</p>
			<p>
				{{ t('BimPrenatal4') }}
				<NuxtLink :to="gynecologistsLink">{{ t('BimPrenatal4Link') }}</NuxtLink
				>{{ t('BimPrenatal4End') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-where" :title="t('BimToc_where')">
			<p>{{ t('BimWhere1') }}</p>
			<ul>
				<li>{{ t('BimWhereList1') }}</li>
				<li>{{ t('BimWhereList2') }}</li>
				<li>{{ t('BimWhereList3') }}</li>
			</ul>
			<p>{{ t('BimWhere2') }}</p>
			<p>{{ t('BimWhere3') }}</p>
			<p>
				{{ t('BimWhere4') }}
				<NuxtLink :to="clinicsLink">{{ t('BimWhere4Link') }}</NuxtLink
				>{{ t('BimWhere4End') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-costs" :title="t('BimToc_costs')">
			<p>{{ t('BimCosts1') }}</p>
			<p>{{ t('BimCosts2') }}</p>
			<p>
				{{ t('BimCosts3') }}
				<NuxtLink :to="servicesLink">{{ t('BimCosts3Link') }}</NuxtLink
				>{{ t('BimCosts3End') }}
			</p>
			<p>{{ t('BimCosts4') }}</p>
		</ArticleSection>

		<ArticleSection id="section-practical" :title="t('BimToc_practical')">
			<p>{{ t('BimPractical1') }}</p>
			<p>{{ t('BimPractical2') }}</p>
			<p>{{ t('BimPractical3') }}</p>
			<p>{{ t('BimPractical4') }}</p>
		</ArticleSection>

		<ArticleSection id="section-after" :title="t('BimToc_after')">
			<p>{{ t('BimAfter1') }}</p>
			<p>{{ t('BimAfter2') }}</p>
			<p>{{ t('BimAfter3') }}</p>
			<p>{{ t('BimAfter4') }}</p>
		</ArticleSection>

		<ArticleSection id="section-sources" :title="t('BimToc_sources')">
			<p>{{ t('BimSources0') }}</p>
			<ul>
				<li>{{ t('BimSourcesKccg') }}</li>
				<li>{{ t('BimSourcesFzo') }}</li>
				<li>{{ t('BimSourcesMup') }}</li>
				<li>{{ t('BimSourcesDz') }}</li>
			</ul>
			<p>
				{{ t('BimSourcesCatalog') }}
				<NuxtLink :to="gynecologistsLink">{{
					t('BimSourcesCatalogLink')
				}}</NuxtLink
				>{{ t('BimSourcesCatalogEnd') }}
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
