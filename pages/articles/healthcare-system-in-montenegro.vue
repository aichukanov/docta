<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
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

const { breadcrumbItems } = useArticlePageSeo({
	slug: ARTICLE_SLUG,
	title: computed(() => t('HealthcareSystemTitle')),
	description: computed(() => t('HealthcareSystemDescription')),
	image: `/img/articles/${ARTICLE_SLUG}.webp`,
	datePublished: '2026-07-16',
	t,
	locale,
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
