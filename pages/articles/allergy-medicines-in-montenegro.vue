<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import { combineI18nMessages } from '~/i18n/utils';
import { MedicineCategory } from '~/enums/medicine-category';
import { DoctorSpecialty } from '~/enums/specialty';

import articlesI18n from '~/i18n/articles';
import articleAllergyI18n from '~/i18n/article-allergy-medicines';
import breadcrumbI18n from '~/i18n/breadcrumb';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		articlesI18n,
		articleAllergyI18n,
		breadcrumbI18n,
	]),
});

const ARTICLE_SLUG = 'allergy-medicines-in-montenegro';

// Действующие вещества аллергийного контура, которые ЕСТЬ в реестре ЧГ —
// ведут в каталог с фильтром по substanceIds. Id сверены по med_substances
// (только вещества с активными препаратами) и по фасетам на проде.
const SUBSTANCE_ID = {
	loratadine: 498,
	fexofenadine: 259,
	azelastine: 70,
	dimetindene: 190,
	chloropyramine: 357,
	desloratadine: 178,
	bilastine: 94,
	ketotifen: 431,
	mometasone: 558,
	olopatadine: 617,
	montelukast: 559,
} as const;

const getSubstanceLink = (substanceId: number) => ({
	name: 'medicines',
	query: {
		substanceIds: substanceId,
		...getRegionalQuery(locale.value),
	},
});

// Конкретные препараты реестра. Слаги проверены на проде (200 у всех),
// цетиризина/левоцетиризина среди них нет — их в реестре не существует.
const getMedicineLink = (medicineSlug: string) => ({
	name: 'medicines-medicineSlug',
	params: { medicineSlug },
	query: getRegionalQuery(locale.value),
});

// Каталог с фильтром «Для чего» → «Аллергия»: тот же фасет, что в sitemap.
const allergyCatalogLink = computed(() => ({
	name: 'medicines',
	query: {
		medicineCategoryIds: MedicineCategory.ALLERGY,
		...getRegionalQuery(locale.value),
	},
}));

const getDoctorsLink = (specialtyId?: number) => ({
	name: 'doctors',
	query: {
		...(specialtyId ? { specialtyIds: specialtyId } : {}),
		...getRegionalQuery(locale.value),
	},
});

const pharmaciesArticleLink = computed(() => ({
	path: '/articles/pharmacies-and-medications',
	query: getRegionalQuery(locale.value),
}));

const unavailableArticleLink = computed(() => ({
	path: '/articles/medications-not-available-in-montenegro',
	query: getRegionalQuery(locale.value),
}));

// Секции статьи: id → ключи заголовков для TOC и разметки
const SECTION_IDS = [
	'zyrtec',
	'otc',
	'rx',
	'brands',
	'kids',
	'bring',
	'recipe',
	'sources',
] as const;

const articleToc = computed(() =>
	SECTION_IDS.map((id) => ({
		id: `section-${id}`,
		label: t(`AlgToc_${id}`),
	})),
);

const articleCta = computed(() => ({
	title: t('AlgCtaTitle'),
	text: t('AlgCtaText'),
	button: t('AlgCtaButton'),
	link: allergyCatalogLink.value,
}));

const { breadcrumbItems } = useArticlePageSeo({
	slug: ARTICLE_SLUG,
	title: computed(() => t('AlgTitle')),
	description: computed(() => t('AlgDescription')),
	image: `/img/articles/${ARTICLE_SLUG}.webp`,
	datePublished: '2026-08-31',
	t,
	locale,
});
</script>

<template>
	<ArticlePage
		:breadcrumbs="breadcrumbItems"
		:title="t('AlgTitle')"
		:description="t('AlgDescription')"
		:image="`/img/articles/${ARTICLE_SLUG}.webp`"
		:toc="articleToc"
		:cta="articleCta"
	>
		<ArticleSection id="section-zyrtec" :title="t('AlgToc_zyrtec')">
			<p>{{ t('AlgZyrtec1') }}</p>
			<p>{{ t('AlgZyrtec2') }}</p>
			<p>{{ t('AlgZyrtec3') }}</p>
		</ArticleSection>

		<ArticleSection id="section-otc" :title="t('AlgToc_otc')">
			<p>{{ t('AlgOtc1') }}</p>
			<ul>
				<li
					><NuxtLink :to="getSubstanceLink(SUBSTANCE_ID.loratadine)">{{
						t('AlgOtcLoratadineSubstance')
					}}</NuxtLink
					>{{ t('AlgOtcLoratadineMid')
					}}<NuxtLink :to="getMedicineLink('pressing-10mg')">{{
						t('AlgOtcLoratadineTablets')
					}}</NuxtLink
					>{{ t('AlgOtcLoratadineOr')
					}}<NuxtLink :to="getMedicineLink('pressing-5mg5ml')">{{
						t('AlgOtcLoratadineSyrup')
					}}</NuxtLink
					>{{ t('AlgOtcLoratadineEnd') }}</li
				>
				<li
					><NuxtLink :to="getSubstanceLink(SUBSTANCE_ID.fexofenadine)">{{
						t('AlgOtcFexofenadineSubstance')
					}}</NuxtLink
					>{{ t('AlgOtcFexofenadineMid1')
					}}<NuxtLink :to="getMedicineLink('allegra-120mg-3051')">{{
						t('AlgOtcFexofenadineBrand1')
					}}</NuxtLink
					>{{ t('AlgOtcFexofenadineMid2')
					}}<NuxtLink :to="getMedicineLink('alerix')">{{
						t('AlgOtcFexofenadineBrand2')
					}}</NuxtLink
					>{{ t('AlgOtcFexofenadineEnd') }}</li
				>
				<li
					><NuxtLink :to="getSubstanceLink(SUBSTANCE_ID.azelastine)">{{
						t('AlgOtcAzelastineSubstance')
					}}</NuxtLink
					>{{ t('AlgOtcAzelastineMid')
					}}<NuxtLink :to="getMedicineLink('allergodil')">{{
						t('AlgOtcAzelastineBrand')
					}}</NuxtLink
					>{{ t('AlgOtcAzelastineEnd') }}</li
				>
				<li
					><NuxtLink :to="getSubstanceLink(SUBSTANCE_ID.dimetindene)">{{
						t('AlgOtcDimetindeneSubstance')
					}}</NuxtLink
					>{{ t('AlgOtcDimetindeneMid')
					}}<NuxtLink :to="getMedicineLink('flenty')">{{
						t('AlgOtcDimetindeneBrand')
					}}</NuxtLink
					>{{ t('AlgOtcDimetindeneEnd') }}</li
				>
				<li
					><NuxtLink :to="getSubstanceLink(SUBSTANCE_ID.chloropyramine)">{{
						t('AlgOtcChloropyramineSubstance')
					}}</NuxtLink
					>{{ t('AlgOtcChloropyramineMid')
					}}<NuxtLink :to="getMedicineLink('synopen-10mgg')">{{
						t('AlgOtcChloropyramineBrand')
					}}</NuxtLink
					>{{ t('AlgOtcChloropyramineEnd') }}</li
				>
			</ul>
			<p>{{ t('AlgOtc2') }}</p>
			<p>{{ t('AlgOtc3') }}</p>
		</ArticleSection>

		<ArticleSection id="section-rx" :title="t('AlgToc_rx')">
			<p>{{ t('AlgRx1') }}</p>
			<ul>
				<li
					><NuxtLink :to="getSubstanceLink(SUBSTANCE_ID.desloratadine)">{{
						t('AlgRxDesloratadineSubstance')
					}}</NuxtLink
					>{{ t('AlgRxDesloratadineMid')
					}}<NuxtLink :to="getMedicineLink('aerius-5mg')">{{
						t('AlgRxDesloratadineTablets')
					}}</NuxtLink
					>{{ t('AlgRxDesloratadineAnd')
					}}<NuxtLink :to="getMedicineLink('aerius-05mgml')">{{
						t('AlgRxDesloratadineSolution')
					}}</NuxtLink
					>{{ t('AlgRxDesloratadineEnd') }}</li
				>
				<li
					><NuxtLink :to="getSubstanceLink(SUBSTANCE_ID.bilastine)">{{
						t('AlgRxBilastineSubstance')
					}}</NuxtLink
					>{{ t('AlgRxBilastineMid')
					}}<NuxtLink :to="getMedicineLink('alergofen')">{{
						t('AlgRxBilastineBrand')
					}}</NuxtLink
					>{{ t('AlgRxBilastineEnd') }}</li
				>
				<li
					><NuxtLink :to="getSubstanceLink(SUBSTANCE_ID.ketotifen)">{{
						t('AlgRxKetotifenSubstance')
					}}</NuxtLink
					>{{ t('AlgRxKetotifenMid')
					}}<NuxtLink :to="getMedicineLink('galitifen')">{{
						t('AlgRxKetotifenBrand')
					}}</NuxtLink
					>{{ t('AlgRxKetotifenEnd') }}</li
				>
				<li
					><NuxtLink :to="getSubstanceLink(SUBSTANCE_ID.mometasone)">{{
						t('AlgRxMometasoneSubstance')
					}}</NuxtLink
					>{{ t('AlgRxMometasoneMid')
					}}<NuxtLink :to="getMedicineLink('nasonex')">{{
						t('AlgRxMometasoneBrand')
					}}</NuxtLink
					>{{ t('AlgRxMometasoneMid2')
					}}<NuxtLink :to="getMedicineLink('dymista')">{{
						t('AlgRxMometasoneBrand2')
					}}</NuxtLink
					>{{ t('AlgRxMometasoneMid3')
					}}<NuxtLink :to="getMedicineLink('flufetan')">{{
						t('AlgRxMometasoneBrand3')
					}}</NuxtLink
					>{{ t('AlgRxMometasoneEnd') }}</li
				>
				<li
					><NuxtLink :to="getSubstanceLink(SUBSTANCE_ID.olopatadine)">{{
						t('AlgRxOlopatadineSubstance')
					}}</NuxtLink
					>{{ t('AlgRxOlopatadineMid')
					}}<NuxtLink :to="getMedicineLink('kyara')">{{
						t('AlgRxOlopatadineBrand')
					}}</NuxtLink
					>{{ t('AlgRxOlopatadineEnd') }}</li
				>
				<!-- У монтелукаста в реестре четыре карточки (SINGULAIR 4/5/10 мг,
				     ALVOKAST), поэтому ссылка только на фасет вещества: ссылка на
				     одну карточку молча спрятала бы три остальные. -->
				<li
					><NuxtLink :to="getSubstanceLink(SUBSTANCE_ID.montelukast)">{{
						t('AlgRxMontelukastSubstance')
					}}</NuxtLink
					>{{ t('AlgRxMontelukastEnd') }}</li
				>
				<li
					>{{ t('AlgRxChloropyramineA')
					}}<NuxtLink :to="getMedicineLink('synopen-20mg2ml')">{{
						t('AlgRxChloropyramineBrand')
					}}</NuxtLink
					>{{ t('AlgRxChloropyramineEnd') }}</li
				>
			</ul>
			<p>{{ t('AlgRx2') }}</p>
		</ArticleSection>

		<ArticleSection id="section-brands" :title="t('AlgToc_brands')">
			<p>{{ t('AlgBrands1') }}</p>
			<ul>
				<li>{{ t('AlgBrandsCetirizine') }}</li>
				<li>{{ t('AlgBrandsLevocetirizine') }}</li>
				<li>{{ t('AlgBrandsLoratadine') }}</li>
				<li>{{ t('AlgBrandsDesloratadine') }}</li>
				<li>{{ t('AlgBrandsFexofenadine') }}</li>
				<li>{{ t('AlgBrandsBilastine') }}</li>
				<li>{{ t('AlgBrandsChloropyramine') }}</li>
				<li>{{ t('AlgBrandsDimetindene') }}</li>
				<li>{{ t('AlgBrandsKetotifen') }}</li>
				<li>{{ t('AlgBrandsOld') }}</li>
				<li>{{ t('AlgBrandsAzelastine') }}</li>
				<li>{{ t('AlgBrandsNasal') }}</li>
				<li>{{ t('AlgBrandsEye') }}</li>
			</ul>
			<p>
				{{ t('AlgBrands2a') }}
				<NuxtLink :to="allergyCatalogLink">{{ t('AlgBrands2Link') }}</NuxtLink
				>{{ t('AlgBrands2End') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-kids" :title="t('AlgToc_kids')">
			<p>{{ t('AlgKids1') }}</p>
			<p>{{ t('AlgKids2') }}</p>
			<p
				>{{ t('AlgKids3a')
				}}<NuxtLink
					:to="getDoctorsLink(DoctorSpecialty.PEDIATRIC_ALLERGOLOGY)"
					>{{ t('AlgKids3Link') }}</NuxtLink
				>{{ t('AlgKids3End') }}</p
			>
		</ArticleSection>

		<ArticleSection id="section-bring" :title="t('AlgToc_bring')">
			<p>{{ t('AlgBring1') }}</p>
			<p>{{ t('AlgBring2') }}</p>
			<p>{{ t('AlgBring3') }}</p>
		</ArticleSection>

		<ArticleSection id="section-recipe" :title="t('AlgToc_recipe')">
			<p>{{ t('AlgRecipe1') }}</p>
			<p
				>{{ t('AlgRecipe2a')
				}}<NuxtLink :to="getDoctorsLink(DoctorSpecialty.ALLERGOLOGY)">{{
					t('AlgRecipe2Link')
				}}</NuxtLink
				>{{ t('AlgRecipe2Mid')
				}}<NuxtLink :to="getDoctorsLink()">{{ t('AlgRecipe2Link2') }}</NuxtLink
				>{{ t('AlgRecipe2End') }}</p
			>
			<p
				>{{ t('AlgRecipe3a')
				}}<NuxtLink :to="pharmaciesArticleLink">{{
					t('AlgRecipe3Link')
				}}</NuxtLink
				>{{ t('AlgRecipe3End') }}</p
			>
		</ArticleSection>

		<ArticleSection id="section-sources" :title="t('AlgToc_sources')">
			<p>{{ t('AlgSources0') }}</p>
			<ul>
				<li>
					<a href="https://cinmed.me" target="_blank" rel="noopener nofollow">{{
						t('AlgSourcesCinmed')
					}}</a>
				</li>
				<li>
					<a href="https://fzocg.me" target="_blank" rel="noopener nofollow">{{
						t('AlgSourcesFzo')
					}}</a>
				</li>
			</ul>
			<p>{{ t('AlgSourcesCommunity') }}</p>
			<p
				>{{ t('AlgSourcesRelatedA')
				}}<NuxtLink :to="unavailableArticleLink">{{
					t('AlgSourcesRelatedLink')
				}}</NuxtLink
				>{{ t('AlgSourcesRelatedEnd') }}</p
			>
		</ArticleSection>
	</ArticlePage>
</template>
