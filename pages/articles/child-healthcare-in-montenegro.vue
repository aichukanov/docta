<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import { combineI18nMessages } from '~/i18n/utils';
import { DoctorSpecialty } from '~/enums/specialty';

import articleChildHealthcareI18n from '~/i18n/article-child-healthcare';
import breadcrumbI18n from '~/i18n/breadcrumb';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([articleChildHealthcareI18n, breadcrumbI18n]),
});

const ARTICLE_SLUG = 'child-healthcare-in-montenegro';

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

const { breadcrumbItems } = useArticlePageSeo({
	slug: ARTICLE_SLUG,
	title: computed(() => t('ChildHealthcareTitle')),
	description: computed(() => t('ChildHealthcareDescription')),
	image: `/img/articles/${ARTICLE_SLUG}.webp`,
	datePublished: '2026-07-16',
	dateModified: '2026-07-17',
	lastReviewed: '2026-07-17',
	t,
	locale,
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
