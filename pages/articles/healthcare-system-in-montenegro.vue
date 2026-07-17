<script setup lang="ts">
import { SITE_URL } from '~/common/constants';
import { getRegionalQuery, getRegionalUrl } from '~/common/url-utils';
import {
	buildBreadcrumbsSchema,
	buildMedicalWebPageSchema,
} from '~/common/schema-org-builders';
import { combineI18nMessages } from '~/i18n/utils';

import articlesI18n from '~/i18n/articles';
import articleHealthcareI18n from '~/i18n/article-healthcare-system';
import breadcrumbI18n from '~/i18n/breadcrumb';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		articlesI18n,
		articleHealthcareI18n,
		breadcrumbI18n,
	]),
});

const ARTICLE_SLUG = 'healthcare-system-in-montenegro';

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
	{ label: t('HealthcareSystemTitle') },
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

const medicationsLink = computed(() => ({
	name: 'medications',
	query: getRegionalQuery(locale.value),
}));

// Секции статьи: id → ключи заголовков для TOC и разметки
const SECTION_IDS = [
	'emergency',
	'state-system',
	'knjizica',
	'without-knjizica',
	'foreigners',
	'insurance',
	'medications',
	'sources',
] as const;

const articleToc = computed(() =>
	SECTION_IDS.map((id) => ({
		id: `section-${id}`,
		label: t(`HcsToc_${id}`),
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
const pageTitle = computed(() => t('HealthcareSystemTitle'));
const pageDescription = computed(() => t('HealthcareSystemDescription'));
const articleImage = `${SITE_URL}/img/articles/healthcare-system-in-montenegro.webp`;

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
			title: t('HealthcareSystemTitle'),
			description: t('HealthcareSystemDescription'),
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
			{ name: t('HealthcareSystemTitle') },
		]),
	]);
});
</script>

<template>
	<ArticlePage
		:breadcrumbs="breadcrumbItems"
		:title="t('HealthcareSystemTitle')"
		:description="t('HealthcareSystemDescription')"
		image="/img/articles/healthcare-system-in-montenegro.webp"
		:toc="articleToc"
		:cta="articleCta"
	>
		<ArticleSection id="section-emergency" :title="t('HcsToc_emergency')">
			<p>{{ t('HcsEmergency1') }}</p>
			<p>{{ t('HcsEmergency2') }}</p>
			<p>{{ t('HcsEmergency3') }}</p>
			<p>{{ t('HcsEmergency4') }}</p>
		</ArticleSection>

		<ArticleSection id="section-state-system" :title="t('HcsToc_state-system')">
			<p>{{ t('HcsState1') }}</p>
			<ul>
				<li>{{ t('HcsStateLevel1') }}</li>
				<li>{{ t('HcsStateLevel2') }}</li>
				<li>{{ t('HcsStateLevel3') }}</li>
			</ul>
			<p>{{ t('HcsState2') }}</p>
			<p>{{ t('HcsState3') }}</p>
		</ArticleSection>

		<ArticleSection id="section-knjizica" :title="t('HcsToc_knjizica')">
			<p>{{ t('HcsKnjizica1') }}</p>
			<p>{{ t('HcsKnjizica2') }}</p>
			<p>{{ t('HcsKnjizica3') }}</p>
			<p>{{ t('HcsKnjizica4') }}</p>
		</ArticleSection>

		<ArticleSection
			id="section-without-knjizica"
			:title="t('HcsToc_without-knjizica')"
		>
			<p>{{ t('HcsWithout1') }}</p>
			<p>{{ t('HcsWithout2') }}</p>
			<p>
				{{ t('HcsWithout3') }}
				<NuxtLink :to="servicesLink">{{ t('HcsWithout3Link') }}</NuxtLink
				>{{ t('HcsWithout3End') }}
			</p>
			<p>
				{{ t('HcsWithout4') }}
				<NuxtLink :to="labtestsLink">{{ t('HcsWithout4Link') }}</NuxtLink
				>{{ t('HcsWithout4End') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-foreigners" :title="t('HcsToc_foreigners')">
			<p>{{ t('HcsForeigners1') }}</p>
			<p>{{ t('HcsForeigners2') }}</p>
			<p>{{ t('HcsForeigners3') }}</p>
			<p>{{ t('HcsForeigners4') }}</p>
		</ArticleSection>

		<ArticleSection id="section-insurance" :title="t('HcsToc_insurance')">
			<p>{{ t('HcsInsurance1') }}</p>
			<p>{{ t('HcsInsurance2') }}</p>
		</ArticleSection>

		<ArticleSection id="section-medications" :title="t('HcsToc_medications')">
			<p>{{ t('HcsMedications1') }}</p>
			<p>
				{{ t('HcsMedications2') }}
				<NuxtLink :to="medicationsLink">{{ t('HcsMedications2Link') }}</NuxtLink
				>{{ t('HcsMedications2End') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-sources" :title="t('HcsToc_sources')">
			<p>{{ t('HcsSources0') }}</p>
			<ul>
				<li>{{ t('HcsSourcesPhones') }}</li>
				<li>
					<a
						href="https://fzocg.me"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('HcsSourcesFzo') }}</a
					>
				</li>
				<li>
					<a
						href="https://www.ezdravlje.me"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('HcsSourcesEzdravlje') }}</a
					>
				</li>
				<li>
					<a
						href="https://www.kccg.me/lista-cekanja/"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('HcsSourcesWaiting') }}</a
					>
				</li>
				<li>
					<a
						href="https://www.gov.uk/guidance/uk-reciprocal-healthcare-agreements-with-non-eu-countries"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('HcsSourcesGovUk') }}</a
					>
				</li>
			</ul>
			<p>
				{{ t('HcsSourcesCatalog') }}
				<NuxtLink :to="doctorsLink">{{
					t('HcsSourcesCatalogLink')
				}}</NuxtLink
				>{{ t('HcsSourcesCatalogEnd') }}
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
