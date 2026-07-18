<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
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

const { breadcrumbItems } = useArticlePageSeo({
	slug: ARTICLE_SLUG,
	title: computed(() => t('TouristHealthcareTitle')),
	description: computed(() => t('TouristHealthcareDescription')),
	image: `/img/articles/${ARTICLE_SLUG}.webp`,
	datePublished: '2026-07-16',
	t,
	locale,
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
