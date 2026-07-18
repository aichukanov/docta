<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import { combineI18nMessages } from '~/i18n/utils';

import articlesI18n from '~/i18n/articles';
import articleResidenceInsuranceI18n from '~/i18n/article-residence-insurance';
import breadcrumbI18n from '~/i18n/breadcrumb';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		articlesI18n,
		articleResidenceInsuranceI18n,
		breadcrumbI18n,
	]),
});

const ARTICLE_SLUG = 'health-insurance-for-residence-permit';

const clinicsLink = computed(() => ({
	name: 'clinics',
	query: getRegionalQuery(locale.value),
}));

const healthcareArticleLink = computed(() => ({
	path: '/articles/healthcare-system-in-montenegro',
	query: getRegionalQuery(locale.value),
}));

// Секции статьи: id → ключи заголовков для TOC и разметки
const SECTION_IDS = [
	'why-required',
	'duration',
	'buying',
	'coverage',
	'knjizica',
	'sources',
] as const;

const articleToc = computed(() =>
	SECTION_IDS.map((id) => ({
		id: `section-${id}`,
		label: t(`RipToc_${id}`),
	})),
);

// CTA: каталог клиник
const articleCta = computed(() => ({
	title: t('CtaClinicsTitle'),
	text: t('CtaClinicsText'),
	button: t('CtaClinicsButton'),
	link: clinicsLink.value,
}));

const { breadcrumbItems } = useArticlePageSeo({
	slug: ARTICLE_SLUG,
	title: computed(() => t('ResidenceInsuranceTitle')),
	description: computed(() => t('ResidenceInsuranceDescription')),
	image: `/img/articles/${ARTICLE_SLUG}.webp`,
	datePublished: '2026-07-16',
	t,
	locale,
});
</script>

<template>
	<ArticlePage
		:breadcrumbs="breadcrumbItems"
		:title="t('ResidenceInsuranceTitle')"
		:description="t('ResidenceInsuranceDescription')"
		image="/img/articles/health-insurance-for-residence-permit.webp"
		:toc="articleToc"
		:cta="articleCta"
	>
		<ArticleSection id="section-why-required" :title="t('RipToc_why-required')">
			<p>{{ t('RipWhy1') }}</p>
			<p>{{ t('RipWhy2') }}</p>
			<p>{{ t('RipWhy3') }}</p>
			<p>{{ t('RipWhy4') }}</p>
		</ArticleSection>

		<ArticleSection id="section-duration" :title="t('RipToc_duration')">
			<p>{{ t('RipDuration1') }}</p>
			<ul>
				<li>{{ t('RipDurationBudva') }}</li>
				<li>{{ t('RipDurationCoast') }}</li>
				<li>{{ t('RipDurationCetinje') }}</li>
				<li>{{ t('RipDurationPodgorica') }}</li>
				<li>{{ t('RipDurationHercegNovi') }}</li>
				<li>{{ t('RipDurationFamily') }}</li>
			</ul>
			<p>{{ t('RipDuration2') }}</p>
			<p>{{ t('RipDuration3') }}</p>
		</ArticleSection>

		<ArticleSection id="section-buying" :title="t('RipToc_buying')">
			<p>{{ t('RipBuying1') }}</p>
			<p>{{ t('RipBuying2') }}</p>
			<p>{{ t('RipBuying3') }}</p>
			<p>{{ t('RipBuying4') }}</p>
			<p>{{ t('RipPrices0') }}</p>
			<ul>
				<li>{{ t('RipPricesShort') }}</li>
				<li>{{ t('RipPrices3m') }}</li>
				<li>{{ t('RipPricesYear') }}</li>
				<li>{{ t('RipPrices2y') }}</li>
			</ul>
		</ArticleSection>

		<ArticleSection id="section-coverage" :title="t('RipToc_coverage')">
			<p>{{ t('RipCoverage1') }}</p>
			<p>{{ t('RipCoverage2') }}</p>
			<p>{{ t('RipCoverage3') }}</p>
			<p>{{ t('RipCoverage4') }}</p>
			<p>
				{{ t('RipCoverage5') }}
				<NuxtLink :to="clinicsLink">{{ t('RipCoverage5Link') }}</NuxtLink
				>{{ t('RipCoverage5End') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-knjizica" :title="t('RipToc_knjizica')">
			<p>{{ t('RipKnjizica1') }}</p>
			<p>{{ t('RipKnjizica2') }}</p>
			<p>
				{{ t('RipKnjizica3') }}
				<NuxtLink :to="healthcareArticleLink">{{
					t('RipKnjizica3Link')
				}}</NuxtLink
				>{{ t('RipKnjizica3End') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-sources" :title="t('RipToc_sources')">
			<p>{{ t('RipSources0') }}</p>
			<ul>
				<li>{{ t('RipSourcesLaw') }}</li>
				<li>{{ t('RipSourcesInsurers') }}</li>
				<li>{{ t('RipSourcesMup') }}</li>
				<li>{{ t('RipSourcesChat') }}</li>
			</ul>
		</ArticleSection>
	</ArticlePage>
</template>
