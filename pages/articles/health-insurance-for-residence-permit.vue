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

const LAW_URL = 'https://www.paragraf.me/propisi-crnegore/zakon_o_strancima.html';

// Ссылки на страховые ведут на внутренние страницы каталога
// (pages/insurance-companies/[companySlug]) вместо внешних сайтов страховых.
const insuranceCompanyLink = (slug: string) => ({
	name: 'insurance-companies-companySlug',
	params: { companySlug: slug },
	query: getRegionalQuery(locale.value),
});

const savaLink = computed(() => insuranceCompanyLink('sava'));
const lovcenLink = computed(() => insuranceCompanyLink('lovcen'));
const uniqaLink = computed(() => insuranceCompanyLink('uniqa'));
const generaliLink = computed(() => insuranceCompanyLink('generali'));
const graweLink = computed(() => insuranceCompanyLink('grawe'));

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
			<p
				>{{ t('RipWhy1a') }}<a :href="LAW_URL" target="_blank" rel="noopener nofollow">{{
					t('RipWhy1LawLink')
				}}</a
				>{{ t('RipWhy1b') }}</p
			>
			<p
				>{{ t('RipWhy2a') }}<NuxtLink :to="savaLink">{{
					t('RipWhy2SavaLink')
				}}</NuxtLink
				>{{ t('RipWhy2b') }}<NuxtLink :to="lovcenLink">{{
					t('RipWhy2LovcenLink')
				}}</NuxtLink
				>{{ t('RipWhy2c') }}<NuxtLink :to="uniqaLink">{{
					t('RipWhy2UniqaLink')
				}}</NuxtLink
				>{{ t('RipWhy2d') }}<NuxtLink :to="generaliLink">{{
					t('RipWhy2GeneraliLink')
				}}</NuxtLink
				>{{ t('RipWhy2e') }}<NuxtLink :to="graweLink">{{
					t('RipWhy2GraweLink')
				}}</NuxtLink
				>{{ t('RipWhy2f') }}</p
			>
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
				<li>
					<a :href="LAW_URL" target="_blank" rel="noopener nofollow">{{
						t('RipSourcesLaw')
					}}</a>
				</li>
				<li
					>{{ t('RipSourcesInsurersA') }}<NuxtLink :to="savaLink">{{
						t('RipSourcesInsurersSavaLink')
					}}</NuxtLink
					>{{ t('RipSourcesInsurersB') }}<NuxtLink :to="lovcenLink">{{
						t('RipSourcesInsurersLovcenLink')
					}}</NuxtLink
					>{{ t('RipSourcesInsurersC') }}<NuxtLink :to="uniqaLink">{{
						t('RipSourcesInsurersUniqaLink')
					}}</NuxtLink
					>{{ t('RipSourcesInsurersD') }}</li
				>
				<li>{{ t('RipSourcesMup') }}</li>
				<li
					>{{ t('RipSourcesChatA') }}<a
						href="https://t.me/DN_Montenegro"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('RipSourcesChatLink') }}</a
					>{{ t('RipSourcesChatB') }}</li
				>
			</ul>
		</ArticleSection>
	</ArticlePage>
</template>
