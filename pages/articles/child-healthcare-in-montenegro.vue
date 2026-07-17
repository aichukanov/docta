<script setup lang="ts">
import { SITE_URL } from '~/common/constants';
import { getRegionalQuery, getRegionalUrl } from '~/common/url-utils';
import {
	buildBreadcrumbsSchema,
	buildMedicalWebPageSchema,
} from '~/common/schema-org-builders';
import { combineI18nMessages } from '~/i18n/utils';
import { DoctorSpecialty } from '~/enums/specialty';

import articleChildHealthcareI18n from '~/i18n/article-child-healthcare';
import breadcrumbI18n from '~/i18n/breadcrumb';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([articleChildHealthcareI18n, breadcrumbI18n]),
});

const ARTICLE_SLUG = 'child-healthcare-in-montenegro';

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
	{ label: t('ChildHealthcareTitle') },
]);

// Каталог врачей с предустановленным фильтром «педиатрия»
const pediatriciansLink = computed(() => ({
	name: 'doctors',
	query: {
		specialtyIds: [String(DoctorSpecialty.PEDIATRICS)],
		...getRegionalQuery(locale.value),
	},
}));

const clinicsLink = computed(() => ({
	name: 'clinics',
	query: getRegionalQuery(locale.value),
}));

// Секции статьи: id → ключи заголовков для TOC и разметки
const SECTION_IDS = [
	'system',
	'vaccines',
	'certificates',
	'without-knjizica',
	'emergency',
] as const;

const articleToc = computed(() =>
	SECTION_IDS.map((id) => ({
		id: `section-${id}`,
		label: t(`ChmToc_${id}`),
	})),
);

// CTA: каталог педиатров
const articleCta = computed(() => ({
	title: t('ChmCtaTitle'),
	text: t('ChmCtaText'),
	button: t('ChmCtaButton'),
	link: pediatriciansLink.value,
}));

const schemaOrgStore = useSchemaOrgStore();
const pageUrl = computed(() =>
	getRegionalUrl(`${SITE_URL}/articles/${ARTICLE_SLUG}`, {}, locale.value),
);

// 2. SEO and Schema.org
const pageTitle = computed(() => t('ChildHealthcareTitle'));
const pageDescription = computed(() => t('ChildHealthcareDescription'));
const articleImage = `${SITE_URL}/img/articles/child-healthcare-in-montenegro.webp`;

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
			title: t('ChildHealthcareTitle'),
			description: t('ChildHealthcareDescription'),
			image: articleImage,
			datePublished: '2026-07-16',
			dateModified: '2026-07-17',
			lastReviewed: '2026-07-17',
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
			{ name: t('ChildHealthcareTitle') },
		]),
	]);
});
</script>

<template>
	<ArticlePage
		:breadcrumbs="breadcrumbItems"
		:title="t('ChildHealthcareTitle')"
		:description="t('ChildHealthcareDescription')"
		image="/img/articles/child-healthcare-in-montenegro.webp"
		:toc="articleToc"
		:cta="articleCta"
	>
		<ArticleSection id="section-system" :title="t('ChmToc_system')">
			<p>{{ t('ChmSystem1') }}</p>
			<p>{{ t('ChmSystem2') }}</p>
			<p>{{ t('ChmSystem3') }}</p>
			<p>
				{{ t('ChmSystem4') }}
				<NuxtLink :to="pediatriciansLink">{{
					t('ChmSystem4DoctorsLink')
				}}</NuxtLink
				>{{ t('ChmSystem4Mid') }}
				<NuxtLink :to="clinicsLink">{{ t('ChmSystem4ClinicsLink') }}</NuxtLink
				>{{ t('ChmSystem4End') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-vaccines" :title="t('ChmToc_vaccines')">
			<p>{{ t('ChmVac1') }}</p>
			<p>{{ t('ChmVac2') }}</p>
			<p>{{ t('ChmVac3') }}</p>
			<p>{{ t('ChmVac4') }}</p>
		</ArticleSection>

		<ArticleSection id="section-certificates" :title="t('ChmToc_certificates')">
			<p>{{ t('ChmCert1') }}</p>
			<p>{{ t('ChmCert2') }}</p>
			<p>{{ t('ChmCert3') }}</p>
		</ArticleSection>

		<ArticleSection
			id="section-without-knjizica"
			:title="t('ChmToc_without-knjizica')"
		>
			<p>{{ t('ChmWithout1') }}</p>
			<p>{{ t('ChmWithout2') }}</p>
			<p>{{ t('ChmWithout3') }}</p>
		</ArticleSection>

		<ArticleSection id="section-emergency" :title="t('ChmToc_emergency')">
			<p>{{ t('ChmEmergency1') }}</p>
			<p>{{ t('ChmEmergency2') }}</p>
			<p>{{ t('ChmEmergency3') }}</p>
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
</style>
