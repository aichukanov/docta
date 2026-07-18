<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import { combineI18nMessages } from '~/i18n/utils';

import articlesI18n from '~/i18n/articles';
import articleWeekendI18n from '~/i18n/article-weekend-medical-help';
import breadcrumbI18n from '~/i18n/breadcrumb';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		articlesI18n,
		articleWeekendI18n,
		breadcrumbI18n,
	]),
});

const ARTICLE_SLUG = 'weekend-medical-help-in-montenegro';

const clinicsLink = computed(() => ({
	name: 'clinics',
	query: getRegionalQuery(locale.value),
}));

const codraHospitalLink = computed(() => ({
	name: 'clinics-clinicSlug',
	params: { clinicSlug: 'codra-hospital-podgorica' },
	query: getRegionalQuery(locale.value),
}));

const pharmaciesArticleLink = computed(() => ({
	path: '/articles/pharmacies-and-medications',
	query: getRegionalQuery(locale.value),
}));

// Секции статьи: id → ключи заголовков для TOC и разметки
const SECTION_IDS = ['overview', 'pharmacies', 'hospitals', 'clinics', 'sources'] as const;

const articleToc = computed(() =>
	SECTION_IDS.map((id) => ({
		id: `section-${id}`,
		label: t(`WmhToc_${id}`),
	})),
);

// CTA: каталог клиник
const articleCta = computed(() => ({
	title: t('WmhCtaTitle'),
	text: t('WmhCtaText'),
	button: t('WmhCtaButton'),
	link: clinicsLink.value,
}));

const { breadcrumbItems } = useArticlePageSeo({
	slug: ARTICLE_SLUG,
	title: computed(() => t('WeekendMedicalHelpTitle')),
	description: computed(() => t('WeekendMedicalHelpDescription')),
	image: `/img/articles/${ARTICLE_SLUG}.webp`,
	datePublished: '2026-07-17',
	t,
	locale,
});
</script>

<template>
	<ArticlePage
		:breadcrumbs="breadcrumbItems"
		:title="t('WeekendMedicalHelpTitle')"
		:description="t('WeekendMedicalHelpDescription')"
		:image="`/img/articles/${ARTICLE_SLUG}.webp`"
		:toc="articleToc"
		:cta="articleCta"
	>
		<ArticleSection id="section-overview" :title="t('WmhToc_overview')">
			<p>{{ t('WmhOverview1') }}</p>
			<p>{{ t('WmhOverview2') }}</p>
		</ArticleSection>

		<ArticleSection id="section-pharmacies" :title="t('WmhToc_pharmacies')">
			<p>{{ t('WmhPharmacies1') }}</p>
			<p>{{ t('WmhPharmacies2') }}</p>
			<p>
				{{ t('WmhPharmacies3') }}
				<NuxtLink :to="pharmaciesArticleLink">{{
					t('WmhPharmaciesLink')
				}}</NuxtLink
				>{{ t('WmhPharmaciesEnd') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-hospitals" :title="t('WmhToc_hospitals')">
			<p>{{ t('WmhHospitals1') }}</p>
			<p>
				{{ t('WmhHospitals2') }}
				<NuxtLink :to="codraHospitalLink">{{
					t('WmhHospitalsLink')
				}}</NuxtLink>
				{{ t('WmhHospitalsMid') }}
				{{ t('WmhHospitalsEnd') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-clinics" :title="t('WmhToc_clinics')">
			<p>{{ t('WmhClinics1') }}</p>
			<p>{{ t('WmhClinics2') }}</p>
			<p>
				{{ t('WmhClinicsCatalog') }}
				<NuxtLink :to="clinicsLink">{{ t('WmhClinicsLink') }}</NuxtLink
				>{{ t('WmhClinicsEnd') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-sources" :title="t('WmhToc_sources')">
			<p>{{ t('WmhSources0') }}</p>
			<ul>
				<li>{{ t('WmhSourcesMontefarm') }}</li>
				<li>{{ t('WmhSourcesApoteke') }}</li>
			</ul>
			<p>{{ t('WmhSourcesCatalog') }}</p>
		</ArticleSection>
	</ArticlePage>
</template>
