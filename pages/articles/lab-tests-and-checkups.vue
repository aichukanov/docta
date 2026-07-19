<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import { combineI18nMessages } from '~/i18n/utils';
import { MedicalServiceCategory } from '~/enums/medical-service-category';

import articlesI18n from '~/i18n/articles';
import articleLabtestsI18n from '~/i18n/article-labtests';
import breadcrumbI18n from '~/i18n/breadcrumb';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		articlesI18n,
		articleLabtestsI18n,
		breadcrumbI18n,
	]),
});

const ARTICLE_SLUG = 'lab-tests-and-checkups';

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

const getClinicLink = (slug: string) => ({
	name: 'clinics-clinicSlug',
	params: { clinicSlug: slug },
	query: getRegionalQuery(locale.value),
});

const mojLabLink = computed(() => getClinicLink('moj-lab-podgorica-1'));
const inVitroLink = computed(() => getClinicLink('in-vitro-podgorica'));
const bonaLabLink = computed(() => getClinicLink('bona-lab-prima-podgorica'));
const konzilijumLink = computed(() =>
	getClinicLink('konzilijum-poliklinika-i-bolnica-podgorica'),
);
const milmedikaLink = computed(() => getClinicLink('milmedika-podgorica'));
const zejnilovicLink = computed(() =>
	getClinicLink('dr-zejnilovic-pzu-dnevna-bolnica-bar'),
);
const noviStandardLink = computed(() =>
	getClinicLink('novi-standard-poliklinika'),
);

const getLabTestLink = (slug: string) => ({
	name: 'labtests-labTestSlug',
	params: { labTestSlug: slug },
	query: getRegionalQuery(locale.value),
});
const getLabTestCategoryLink = (categoryId: number) => ({
	name: 'labtests',
	query: {
		categoryIds: categoryId,
		...getRegionalQuery(locale.value),
	},
});

const cbcLink = computed(() => getLabTestLink('complete-blood-count'));
const glucoseLink = computed(() => getLabTestLink('glucose'));
const cholesterolLink = computed(() => getLabTestLink('cholesterol'));
const biochemistryCategoryLink = computed(() => getLabTestCategoryLink(3));
const tshLink = computed(() => getLabTestLink('tsh'));
const hormonesCategoryLink = computed(() => getLabTestCategoryLink(5));
const vitaminDLink = computed(() => getLabTestLink('vitamin-d-25-oh'));
const tumorMarkersCategoryLink = computed(() => getLabTestCategoryLink(6));

const getServiceCategoryLink = (categoryId: number) => ({
	name: 'services',
	query: {
		serviceCategoryIds: categoryId,
		...getRegionalQuery(locale.value),
	},
});
const ultrasoundCategoryLink = computed(() =>
	getServiceCategoryLink(MedicalServiceCategory.ULTRASOUND),
);
const mriCategoryLink = computed(() =>
	getServiceCategoryLink(MedicalServiceCategory.MRI),
);
const ctCategoryLink = computed(() =>
	getServiceCategoryLink(MedicalServiceCategory.MSCT),
);

// Секции статьи: id → ключи заголовков для TOC и разметки
const SECTION_IDS = [
	'private-labs',
	'state-route',
	'imaging',
	'checkups',
	'results',
	'sources',
] as const;

const articleToc = computed(() =>
	SECTION_IDS.map((id) => ({
		id: `section-${id}`,
		label: t(`LtcToc_${id}`),
	})),
);

// CTA: каталог анализов
const articleCta = computed(() => ({
	title: t('LtcCtaTitle'),
	text: t('LtcCtaText'),
	button: t('LtcCtaButton'),
	link: labtestsLink.value,
}));

const { breadcrumbItems } = useArticlePageSeo({
	slug: ARTICLE_SLUG,
	title: computed(() => t('LabTestsArticleTitle')),
	description: computed(() => t('LabTestsArticleDescription')),
	image: `/img/articles/${ARTICLE_SLUG}.webp`,
	datePublished: '2026-07-16',
	t,
	locale,
});
</script>

<template>
	<ArticlePage
		:breadcrumbs="breadcrumbItems"
		:title="t('LabTestsArticleTitle')"
		:description="t('LabTestsArticleDescription')"
		image="/img/articles/lab-tests-and-checkups.webp"
		:toc="articleToc"
		:cta="articleCta"
	>
		<ArticleSection id="section-private-labs" :title="t('LtcToc_private-labs')">
			<p
				>{{ t('LtcPrivate1a') }}<NuxtLink :to="mojLabLink">{{
					t('LtcPrivate1MojLabLink')
				}}</NuxtLink
				>{{ t('LtcPrivate1b') }}<NuxtLink :to="inVitroLink">{{
					t('LtcPrivate1InVitroLink')
				}}</NuxtLink
				>{{ t('LtcPrivate1c') }}<NuxtLink :to="bonaLabLink">{{
					t('LtcPrivate1BonaLabLink')
				}}</NuxtLink
				>{{ t('LtcPrivate1d') }}<NuxtLink :to="konzilijumLink">{{
					t('LtcPrivate1KonzilijumLink')
				}}</NuxtLink
				>{{ t('LtcPrivate1e') }}<NuxtLink :to="milmedikaLink">{{
					t('LtcPrivate1MilmedikaLink')
				}}</NuxtLink
				>{{ t('LtcPrivate1f') }}<NuxtLink :to="zejnilovicLink">{{
					t('LtcPrivate1ZejnilovicLink')
				}}</NuxtLink
				>{{ t('LtcPrivate1g') }}<NuxtLink :to="noviStandardLink">{{
					t('LtcPrivate1NoviStandardLink')
				}}</NuxtLink
				>{{ t('LtcPrivate1h') }}</p
			>
			<p
				>{{ t('LtcPrivate2a') }}<NuxtLink :to="cbcLink">{{
					t('LtcPrivate2CbcLink')
				}}</NuxtLink
				>{{ t('LtcPrivate2b') }}<NuxtLink :to="glucoseLink">{{
					t('LtcPrivate2GlucoseLink')
				}}</NuxtLink
				>{{ t('LtcPrivate2c') }}<NuxtLink :to="cholesterolLink">{{
					t('LtcPrivate2CholesterolLink')
				}}</NuxtLink
				>{{ t('LtcPrivate2d') }}<NuxtLink :to="biochemistryCategoryLink">{{
					t('LtcPrivate2BiochemistryLink')
				}}</NuxtLink
				>{{ t('LtcPrivate2e') }}<NuxtLink :to="tshLink">{{
					t('LtcPrivate2TshLink')
				}}</NuxtLink
				>{{ t('LtcPrivate2f') }}<NuxtLink :to="hormonesCategoryLink">{{
					t('LtcPrivate2HormonesLink')
				}}</NuxtLink
				>{{ t('LtcPrivate2g') }}<NuxtLink :to="vitaminDLink">{{
					t('LtcPrivate2VitaminDLink')
				}}</NuxtLink
				>{{ t('LtcPrivate2h') }}<NuxtLink :to="tumorMarkersCategoryLink">{{
					t('LtcPrivate2TumorMarkersLink')
				}}</NuxtLink
				>{{ t('LtcPrivate2i') }}</p
			>
			<p>{{ t('LtcPrivate3') }}</p>
			<p>
				{{ t('LtcPrivate4') }}
				<NuxtLink :to="labtestsLink">{{ t('LtcPrivate4Link') }}</NuxtLink
				>{{ t('LtcPrivate4End') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-state-route" :title="t('LtcToc_state-route')">
			<p>{{ t('LtcState1') }}</p>
			<p>{{ t('LtcState2') }}</p>
			<p>
				{{ t('LtcState3') }}
				<NuxtLink :to="servicesLink">{{ t('LtcState3Link') }}</NuxtLink
				>{{ t('LtcState3End') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-imaging" :title="t('LtcToc_imaging')">
			<p
				><NuxtLink :to="ultrasoundCategoryLink">{{
					t('LtcImaging1UzLink')
				}}</NuxtLink
				>{{ t('LtcImaging1a') }}</p
			>
			<p
				>{{ t('LtcImaging2a') }}<NuxtLink :to="mriCategoryLink">{{
					t('LtcImaging2MriLink')
				}}</NuxtLink
				>{{ t('LtcImaging2b') }}<NuxtLink :to="ctCategoryLink">{{
					t('LtcImaging2CtLink')
				}}</NuxtLink
				>{{ t('LtcImaging2c') }}</p
			>
			<p>{{ t('LtcImaging3') }}</p>
			<p>
				{{ t('LtcImaging4') }}
				<NuxtLink :to="clinicsLink">{{ t('LtcImaging4Link') }}</NuxtLink
				>{{ t('LtcImaging4End') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-checkups" :title="t('LtcToc_checkups')">
			<p>{{ t('LtcCheckup1') }}</p>
			<p>{{ t('LtcCheckup2') }}</p>
			<p>{{ t('LtcCheckup3') }}</p>
		</ArticleSection>

		<ArticleSection id="section-results" :title="t('LtcToc_results')">
			<p>{{ t('LtcResults1') }}</p>
			<p>{{ t('LtcResults2') }}</p>
			<p>{{ t('LtcResults3') }}</p>
		</ArticleSection>

		<ArticleSection id="section-sources" :title="t('LtcToc_sources')">
			<p>{{ t('LtcSources0') }}</p>
			<ul>
				<li>
					<a
						href="https://fzocg.me/liste-cekanja/"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('LtcSourcesFzo') }}</a
					>
				</li>
				<li>
					<a
						href="https://www.kccg.me/lista-cekanja/"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('LtcSourcesKccg') }}</a
					>
				</li>
				<li>
					<a
						href="https://www.ezdravlje.me"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('LtcSourcesEzdravlje') }}</a
					>
				</li>
				<li>{{ t('LtcSourcesLabs') }}</li>
			</ul>
			<p>
				{{ t('LtcSourcesCatalog') }}
				<NuxtLink :to="doctorsLink">{{
					t('LtcSourcesCatalogLink')
				}}</NuxtLink
				>{{ t('LtcSourcesCatalogEnd') }}
			</p>
		</ArticleSection>
	</ArticlePage>
</template>
