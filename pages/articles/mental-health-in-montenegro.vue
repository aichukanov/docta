<script setup lang="ts">
import { SITE_URL } from '~/common/constants';
import { getRegionalQuery, getRegionalUrl } from '~/common/url-utils';
import {
	buildBreadcrumbsSchema,
	buildMedicalWebPageSchema,
} from '~/common/schema-org-builders';
import { combineI18nMessages } from '~/i18n/utils';
import { DoctorSpecialty } from '~/enums/specialty';

import articleMentalHealthI18n from '~/i18n/article-mental-health';
import breadcrumbI18n from '~/i18n/breadcrumb';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([articleMentalHealthI18n, breadcrumbI18n]),
});

const ARTICLE_SLUG = 'mental-health-in-montenegro';

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
	{ label: t('MentalHealthTitle') },
]);

// Каталог врачей с предустановленным фильтром «психиатрия»
const psychiatristsLink = computed(() => ({
	name: 'doctors',
	query: {
		specialtyIds: [String(DoctorSpecialty.PSYCHIATRY)],
		...getRegionalQuery(locale.value),
	},
}));

const doctorsLink = computed(() => ({
	name: 'doctors',
	query: getRegionalQuery(locale.value),
}));

const clinicsLink = computed(() => ({
	name: 'clinics',
	query: getRegionalQuery(locale.value),
}));

const medicationsLink = computed(() => ({
	name: 'medications',
	query: getRegionalQuery(locale.value),
}));

const healthcareArticleLink = computed(() => ({
	path: '/articles/healthcare-system-in-montenegro',
	query: getRegionalQuery(locale.value),
}));

// Секции статьи: id → ключи заголовков для TOC и разметки
const SECTION_IDS = [
	'system',
	'therapy',
	'prescriptions',
	'costs',
	'crisis',
	'sources',
] as const;

const articleToc = computed(() =>
	SECTION_IDS.map((id) => ({
		id: `section-${id}`,
		label: t(`MhmToc_${id}`),
	})),
);

// CTA: каталог психиатров
const articleCta = computed(() => ({
	title: t('MhmCtaTitle'),
	text: t('MhmCtaText'),
	button: t('MhmCtaButton'),
	link: psychiatristsLink.value,
}));

const schemaOrgStore = useSchemaOrgStore();
const pageUrl = computed(() =>
	getRegionalUrl(`${SITE_URL}/articles/${ARTICLE_SLUG}`, {}, locale.value),
);

// 2. SEO and Schema.org
const pageTitle = computed(() => t('MentalHealthTitle'));
const pageDescription = computed(() => t('MentalHealthDescription'));
const articleImage = `${SITE_URL}/img/articles/mental-health-in-montenegro.webp`;

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
			title: t('MentalHealthTitle'),
			description: t('MentalHealthDescription'),
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
			{ name: t('MentalHealthTitle') },
		]),
	]);
});
</script>

<template>
	<ArticlePage
		:breadcrumbs="breadcrumbItems"
		:title="t('MentalHealthTitle')"
		:description="t('MentalHealthDescription')"
		image="/img/articles/mental-health-in-montenegro.webp"
		:toc="articleToc"
		:cta="articleCta"
	>
		<ArticleSection id="section-system" :title="t('MhmToc_system')">
			<p>{{ t('MhmSystem1') }}</p>
			<ul>
				<li>{{ t('MhmSystemLevel1') }}</li>
				<li>{{ t('MhmSystemLevel2') }}</li>
				<li>{{ t('MhmSystemLevel3') }}</li>
			</ul>
			<p>{{ t('MhmSystem2') }}</p>
			<p>
				{{ t('MhmSystem3') }}
				<NuxtLink :to="healthcareArticleLink">{{
					t('MhmSystem3Link')
				}}</NuxtLink
				>{{ t('MhmSystem3End') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-therapy" :title="t('MhmToc_therapy')">
			<p>{{ t('MhmTherapy1') }}</p>
			<p>{{ t('MhmTherapy2') }}</p>
			<p>{{ t('MhmTherapy3') }}</p>
			<p>
				{{ t('MhmTherapy4') }}
				<NuxtLink :to="doctorsLink">{{ t('MhmTherapy4Link') }}</NuxtLink
				>{{ t('MhmTherapy4Mid') }}
				<NuxtLink :to="clinicsLink">{{ t('MhmTherapy4ClinicsLink') }}</NuxtLink
				>{{ t('MhmTherapy4End') }}
			</p>
		</ArticleSection>

		<ArticleSection
			id="section-prescriptions"
			:title="t('MhmToc_prescriptions')"
		>
			<p>{{ t('MhmRx1') }}</p>
			<p>{{ t('MhmRx2') }}</p>
			<p>{{ t('MhmRx3') }}</p>
			<p>{{ t('MhmRx4') }}</p>
			<p>
				{{ t('MhmRx5') }}
				<NuxtLink :to="medicationsLink">{{ t('MhmRx5Link') }}</NuxtLink
				>{{ t('MhmRx5End') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-costs" :title="t('MhmToc_costs')">
			<p>{{ t('MhmCosts1') }}</p>
			<p>{{ t('MhmCosts2') }}</p>
			<p>{{ t('MhmCosts3') }}</p>
		</ArticleSection>

		<ArticleSection id="section-crisis" :title="t('MhmToc_crisis')">
			<p>{{ t('MhmCrisis1') }}</p>
			<p>{{ t('MhmCrisis2') }}</p>
			<p>{{ t('MhmCrisis3') }}</p>
		</ArticleSection>

		<ArticleSection id="section-sources" :title="t('MhmToc_sources')">
			<p>{{ t('MhmSources0') }}</p>
			<ul>
				<li>{{ t('MhmSourcesPhones') }}</li>
				<li>
					<a
						href="https://psihijatrijakotor.com/"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('MhmSourcesDobrota') }}</a
					>
				</li>
				<li>
					<a
						href="https://www.kccg.me/klinike-i-centri/klinika-za-psihijatriju/"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('MhmSourcesKccg') }}</a
					>
				</li>
				<li>
					<a
						href="https://fzocg.me"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('MhmSourcesFzo') }}</a
					>
				</li>
				<li>
					<a
						href="https://www.ezdravlje.me"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('MhmSourcesEzdravlje') }}</a
					>
				</li>
			</ul>
			<p>
				{{ t('MhmSourcesCatalog') }}
				<NuxtLink :to="psychiatristsLink">{{
					t('MhmSourcesCatalogLink')
				}}</NuxtLink
				>{{ t('MhmSourcesCatalogEnd') }}
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
