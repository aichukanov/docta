<script setup lang="ts">
import { SITE_URL } from '~/common/constants';
import { getRegionalQuery, getRegionalUrl } from '~/common/url-utils';
import {
	buildBreadcrumbsSchema,
	buildMedicalWebPageSchema,
} from '~/common/schema-org-builders';
import { combineI18nMessages } from '~/i18n/utils';
import { ClinicType } from '~/enums/clinic-type';
import { DoctorSpecialty } from '~/enums/specialty';
import { MedicalServiceCategory } from '~/enums/medical-service-category';

import articlesI18n from '~/i18n/articles';
import articleDentistryI18n from '~/i18n/article-dentistry';
import breadcrumbI18n from '~/i18n/breadcrumb';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		articlesI18n,
		articleDentistryI18n,
		breadcrumbI18n,
	]),
});

const ARTICLE_SLUG = 'dentistry-in-montenegro';

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
	{ label: t('DentistryTitle') },
]);

// Каталог клиник, отфильтрованный по типу «стоматология»
const dentalClinicsLink = computed(() => ({
	name: 'clinics',
	query: {
		...getRegionalQuery(locale.value),
		clinicTypeIds: ClinicType.DENTAL_CLINIC,
	},
}));

// Каталог врачей, отфильтрованный по специальности «стоматолог»
const dentistsLink = computed(() => ({
	name: 'doctors',
	query: {
		...getRegionalQuery(locale.value),
		specialtyIds: DoctorSpecialty.DENTISTRY,
	},
}));

// Каталог услуг, отфильтрованный по категории «стоматология»
const dentalServicesLink = computed(() => ({
	name: 'services',
	query: {
		...getRegionalQuery(locale.value),
		serviceCategoryIds: MedicalServiceCategory.DENTISTRY,
	},
}));

// Секции статьи: id → ключи заголовков для TOC и разметки
const SECTION_IDS = [
	'state',
	'prices',
	'choose',
	'emergency',
	'sources',
] as const;

const articleToc = computed(() =>
	SECTION_IDS.map((id) => ({
		id: `section-${id}`,
		label: t(`DstToc_${id}`),
	})),
);

// CTA: каталог стоматологических клиник
const articleCta = computed(() => ({
	title: t('CtaClinicsTitle'),
	text: t('CtaClinicsText'),
	button: t('CtaClinicsButton'),
	link: dentalClinicsLink.value,
}));

const schemaOrgStore = useSchemaOrgStore();
const pageUrl = computed(() =>
	getRegionalUrl(`${SITE_URL}/articles/${ARTICLE_SLUG}`, {}, locale.value),
);

// 2. SEO and Schema.org
const pageTitle = computed(() => t('DentistryTitle'));
const pageDescription = computed(() => t('DentistryDescription'));
const articleImage = `${SITE_URL}/img/articles/dentistry-in-montenegro.webp`;

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
			title: t('DentistryTitle'),
			description: t('DentistryDescription'),
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
			{ name: t('DentistryTitle') },
		]),
	]);
});
</script>

<template>
	<ArticlePage
		:breadcrumbs="breadcrumbItems"
		:title="t('DentistryTitle')"
		:description="t('DentistryDescription')"
		image="/img/articles/dentistry-in-montenegro.webp"
		:toc="articleToc"
		:cta="articleCta"
	>
		<ArticleSection id="section-state" :title="t('DstToc_state')">
			<p>{{ t('DstState1') }}</p>
			<p>{{ t('DstState2') }}</p>
			<p>{{ t('DstState3') }}</p>
			<p>
				{{ t('DstState4') }}
				<NuxtLink :to="dentalServicesLink">{{ t('DstState4Link') }}</NuxtLink
				>{{ t('DstState4End') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-prices" :title="t('DstToc_prices')">
			<p>{{ t('DstPrices1') }}</p>
			<ul>
				<li>{{ t('DstPriceItem1') }}</li>
				<li>{{ t('DstPriceItem2') }}</li>
				<li>{{ t('DstPriceItem3') }}</li>
				<li>{{ t('DstPriceItem4') }}</li>
				<li>{{ t('DstPriceItem5') }}</li>
				<li>{{ t('DstPriceItem6') }}</li>
				<li>{{ t('DstPriceItem7') }}</li>
			</ul>
			<p>{{ t('DstPrices2') }}</p>
			<p>{{ t('DstPrices3') }}</p>
		</ArticleSection>

		<ArticleSection id="section-choose" :title="t('DstToc_choose')">
			<p>{{ t('DstChoose1') }}</p>
			<p>{{ t('DstChoose2') }}</p>
			<p>
				{{ t('DstChoose3') }}
				<NuxtLink :to="dentalClinicsLink">{{ t('DstChoose3Link') }}</NuxtLink
				>{{ t('DstChoose3Mid') }}
				<NuxtLink :to="dentistsLink">{{ t('DstChoose3Link2') }}</NuxtLink
				>{{ t('DstChoose3End') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-emergency" :title="t('DstToc_emergency')">
			<p>{{ t('DstEmergency1') }}</p>
			<p>{{ t('DstEmergency2') }}</p>
			<p>{{ t('DstEmergency3') }}</p>
		</ArticleSection>

		<ArticleSection id="section-sources" :title="t('DstToc_sources')">
			<p>{{ t('DstSources0') }}</p>
			<ul>
				<li>
					<a
						href="https://fzocg.me"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('DstSourcesFzo') }}</a
					>
				</li>
				<li>
					<a
						href="https://www.kccg.me/poliklinika/stomatoloska-poliklinika/"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('DstSourcesKccg') }}</a
					>
				</li>
				<li>
					<a
						href="https://stomkomcg.me"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('DstSourcesKomora') }}</a
					>
				</li>
			</ul>
			<p>
				{{ t('DstSourcesCatalog') }}
				<NuxtLink :to="dentalClinicsLink">{{
					t('DstSourcesCatalogLink')
				}}</NuxtLink
				>{{ t('DstSourcesCatalogEnd') }}
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
