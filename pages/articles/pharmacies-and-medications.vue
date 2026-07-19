<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import { combineI18nMessages } from '~/i18n/utils';

import articlesI18n from '~/i18n/articles';
import articlePharmaciesI18n from '~/i18n/article-pharmacies';
import breadcrumbI18n from '~/i18n/breadcrumb';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		articlesI18n,
		articlePharmaciesI18n,
		breadcrumbI18n,
	]),
});

const ARTICLE_SLUG = 'pharmacies-and-medications';

const doctorsLink = computed(() => ({
	name: 'doctors',
	query: getRegionalQuery(locale.value),
}));

const medicinesLink = computed(() => ({
	name: 'medicines',
	query: getRegionalQuery(locale.value),
}));

const adrenalineMedicineLink = computed(() => ({
	name: 'medicines-medicineSlug',
	params: { medicineSlug: 'lidokain-2---adrenalin-galenika' },
	query: getRegionalQuery(locale.value),
}));

const SERTRALINE_SUBSTANCE_ID = 738;
const sertralineLink = computed(() => ({
	name: 'medicines',
	query: {
		substanceIds: SERTRALINE_SUBSTANCE_ID,
		...getRegionalQuery(locale.value),
	},
}));

const getSubstanceLink = (substanceId: number) => ({
	name: 'medicines',
	query: {
		substanceIds: substanceId,
		...getRegionalQuery(locale.value),
	},
});

const IBUPROFEN_SUBSTANCE_ID = 364;
const LEVOTHYROXINE_SUBSTANCE_ID = 485;
const ibuprofenLink = computed(() =>
	getSubstanceLink(IBUPROFEN_SUBSTANCE_ID),
);
const levothyroxineLink = computed(() =>
	getSubstanceLink(LEVOTHYROXINE_SUBSTANCE_ID),
);

const healthcareArticleLink = computed(() => ({
	path: '/articles/healthcare-system-in-montenegro',
	query: getRegionalQuery(locale.value),
}));

// Секции статьи: id → ключи заголовков для TOC и разметки
const SECTION_IDS = [
	'pharmacies',
	'prescriptions',
	'fond-list',
	'analogs',
	'sources',
] as const;

const articleToc = computed(() =>
	SECTION_IDS.map((id) => ({
		id: `section-${id}`,
		label: t(`PhaToc_${id}`),
	})),
);

// CTA: каталог лекарств
const articleCta = computed(() => ({
	title: t('PhaCtaTitle'),
	text: t('PhaCtaText'),
	button: t('PhaCtaButton'),
	link: medicinesLink.value,
}));

const { breadcrumbItems } = useArticlePageSeo({
	slug: ARTICLE_SLUG,
	title: computed(() => t('PharmaciesTitle')),
	description: computed(() => t('PharmaciesDescription')),
	image: `/img/articles/${ARTICLE_SLUG}.webp`,
	datePublished: '2026-07-16',
	t,
	locale,
});
</script>

<template>
	<ArticlePage
		:breadcrumbs="breadcrumbItems"
		:title="t('PharmaciesTitle')"
		:description="t('PharmaciesDescription')"
		image="/img/articles/pharmacies-and-medications.webp"
		:toc="articleToc"
		:cta="articleCta"
	>
		<ArticleSection id="section-pharmacies" :title="t('PhaToc_pharmacies')">
			<p>{{ t('PhaPharmacies1') }}</p>
			<p>{{ t('PhaPharmacies2') }}</p>
			<p>{{ t('PhaPharmacies3') }}</p>
			<p>
				{{ t('PhaPharmacies4') }}
				<NuxtLink :to="adrenalineMedicineLink">{{
					t('PhaPharmacies4Link')
				}}</NuxtLink
				>{{ t('PhaPharmacies4End') }}
			</p>
		</ArticleSection>

		<ArticleSection
			id="section-prescriptions"
			:title="t('PhaToc_prescriptions')"
		>
			<p>{{ t('PhaPrescriptions1') }}</p>
			<p>{{ t('PhaPrescriptions2') }}</p>
			<p>{{ t('PhaPrescriptions3') }}</p>
			<p>{{ t('PhaPrescriptions4') }}</p>
		</ArticleSection>

		<ArticleSection id="section-fond-list" :title="t('PhaToc_fond-list')">
			<p>{{ t('PhaFond1') }}</p>
			<p
				>{{ t('PhaFond2a') }}<NuxtLink :to="sertralineLink">{{
					t('PhaFond2SertralineLink')
				}}</NuxtLink
				>{{ t('PhaFond2b') }}</p
			>
			<p>
				{{ t('PhaFond3') }}
				<NuxtLink :to="healthcareArticleLink">{{ t('PhaFond3Link') }}</NuxtLink
				>{{ t('PhaFond3End') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-analogs" :title="t('PhaToc_analogs')">
			<p
				>{{ t('PhaAnalogs1a') }}<NuxtLink :to="ibuprofenLink">{{
					t('PhaAnalogs1IbuprofenLink')
				}}</NuxtLink
				>{{ t('PhaAnalogs1b') }}<NuxtLink :to="levothyroxineLink">{{
					t('PhaAnalogs1LevothyroxineLink')
				}}</NuxtLink
				>{{ t('PhaAnalogs1c') }}</p
			>
			<p>
				{{ t('PhaAnalogs2') }}
				<NuxtLink :to="medicinesLink">{{ t('PhaAnalogs2Link') }}</NuxtLink
				>{{ t('PhaAnalogs2End') }}
			</p>
			<p>{{ t('PhaAnalogs3') }}</p>
			<p>{{ t('PhaAnalogs4') }}</p>
		</ArticleSection>

		<ArticleSection id="section-sources" :title="t('PhaToc_sources')">
			<p>{{ t('PhaSources0') }}</p>
			<ul>
				<li>
					<a
						href="https://montefarm.co.me"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('PhaSourcesMontefarm') }}</a
					>
				</li>
				<li>
					<a
						href="https://fzocg.me/lista-ljekova/"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('PhaSourcesFzo') }}</a
					>
				</li>
				<li>
					<a
						href="https://www.ezdravlje.me"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('PhaSourcesEzdravlje') }}</a
					>
				</li>
				<li>
					<a
						href="https://cinmed.me"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('PhaSourcesCinmed') }}</a
					>
				</li>
				<li
					>{{ t('PhaSourcesBenu') }}<a
						href="https://benu.me"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('PhaSourcesBenuLink') }}</a
					>{{ t('PhaSourcesBenuMid') }}<a
						href="https://www.teamedica.me"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('PhaSourcesTeaMedicaLink') }}</a
					>{{ t('PhaSourcesBenuEnd') }}</li
				>
			</ul>
			<p>
				{{ t('PhaSourcesCatalog') }}
				<NuxtLink :to="doctorsLink">{{
					t('PhaSourcesCatalogLink')
				}}</NuxtLink
				>{{ t('PhaSourcesCatalogEnd') }}
			</p>
		</ArticleSection>
	</ArticlePage>
</template>
