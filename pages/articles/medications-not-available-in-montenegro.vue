<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import { combineI18nMessages } from '~/i18n/utils';

import articlesI18n from '~/i18n/articles';
import articleUnavailableI18n from '~/i18n/article-medications-unavailable';
import breadcrumbI18n from '~/i18n/breadcrumb';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		articlesI18n,
		articleUnavailableI18n,
		breadcrumbI18n,
	]),
});

const ARTICLE_SLUG = 'medications-not-available-in-montenegro';

const medicinesLink = computed(() => ({
	name: 'medicines',
	query: getRegionalQuery(locale.value),
}));

// Действующие вещества, которые ЕСТЬ в ЧГ, ведут в каталог с фильтром по substanceIds.
// Id сверены по таблице med_substances (только вещества с активными препаратами).
const SUBSTANCE_ID = {
	charcoal: 523,
	povidoneIodine: 670,
	octenidine: 611,
	chloropyramine: 357,
	dimetindene: 190,
	loratadine: 498,
	desloratadine: 178,
	fexofenadine: 259,
	paracetamol: 635,
	ibuprofen: 364,
	mebeverine: 522,
	metformin: 535,
	dapagliflozin: 161,
	vinpocetine: 895,
	cinnarizine: 146,
} as const;

const getSubstanceLink = (substanceId: number) => ({
	name: 'medicines',
	query: {
		substanceIds: substanceId,
		...getRegionalQuery(locale.value),
	},
});

// Synopen — конкретный препарат с chloropyramine (действующее вещество супрастина),
// зарегистрирован и активен в реестре ЧГ.
const synopenLink = computed(() => ({
	name: 'medicines-medicineSlug',
	params: { medicineSlug: 'synopen-20mg2ml' },
	query: getRegionalQuery(locale.value),
}));

// Flenty — dimetinden (действующее вещество фенистила), в реестре ЧГ только как гель.
const flentyLink = computed(() => ({
	name: 'medicines-medicineSlug',
	params: { medicineSlug: 'flenty' },
	query: getRegionalQuery(locale.value),
}));

// Многокомпонентное в ЧГ — в основном простудные средства (аналоги колдрекса):
// Caffetin Cold и Tylol Hot; привычных безрецептурных комбо-таблеток типа пенталгина нет.
const caffetinLink = computed(() => ({
	name: 'medicines-medicineSlug',
	params: { medicineSlug: 'caffetin-cold' },
	query: getRegionalQuery(locale.value),
}));

const tylolHotLink = computed(() => ({
	name: 'medicines-medicineSlug',
	params: { medicineSlug: 'tylol-hot-500mg-60mg-4mg-2684' },
	query: getRegionalQuery(locale.value),
}));

// Агонисты ГПП-1: семаглутид в ЧГ есть — Ozempic (диабет) и Wegovy (снижение веса);
// тирзепатид (Mounjaro) в реестре не найден.
const ozempicLink = computed(() => ({
	name: 'medicines-medicineSlug',
	params: { medicineSlug: 'ozempic-05mg-2mg15ml' },
	query: getRegionalQuery(locale.value),
}));

const wegovyLink = computed(() => ({
	name: 'medicines-medicineSlug',
	params: { medicineSlug: 'wegovy-1mg' },
	query: getRegionalQuery(locale.value),
}));

const doctorsLink = computed(() => ({
	name: 'doctors',
	query: getRegionalQuery(locale.value),
}));

const pharmaciesArticleLink = computed(() => ({
	path: '/articles/pharmacies-and-medications',
	query: getRegionalQuery(locale.value),
}));

// Секции статьи: id → ключи заголовков для TOC и разметки
const SECTION_IDS = [
	'why',
	'gaps',
	'antivirals',
	'glp1',
	'import',
	'access',
	'sources',
] as const;

const articleToc = computed(() =>
	SECTION_IDS.map((id) => ({
		id: `section-${id}`,
		label: t(`UnaToc_${id}`),
	})),
);

// CTA: каталог лекарств
const articleCta = computed(() => ({
	title: t('UnaCtaTitle'),
	text: t('UnaCtaText'),
	button: t('UnaCtaButton'),
	link: medicinesLink.value,
}));

const { breadcrumbItems } = useArticlePageSeo({
	slug: ARTICLE_SLUG,
	title: computed(() => t('UnaTitle')),
	description: computed(() => t('UnaDescription')),
	image: `/img/articles/${ARTICLE_SLUG}.webp`,
	datePublished: '2026-07-23',
	t,
	locale,
});
</script>

<template>
	<ArticlePage
		:breadcrumbs="breadcrumbItems"
		:title="t('UnaTitle')"
		:description="t('UnaDescription')"
		:image="`/img/articles/${ARTICLE_SLUG}.webp`"
		:toc="articleToc"
		:cta="articleCta"
	>
		<ArticleSection id="section-why" :title="t('UnaToc_why')">
			<p>{{ t('UnaWhy1') }}</p>
			<p>{{ t('UnaWhy2') }}</p>
		</ArticleSection>

		<ArticleSection id="section-gaps" :title="t('UnaToc_gaps')">
			<p>{{ t('UnaGaps1') }}</p>
			<ul>
				<li
					>{{ t('UnaGapsSorbents')
					}}<NuxtLink :to="getSubstanceLink(SUBSTANCE_ID.charcoal)">{{
						t('UnaGapsSorbentsLink')
					}}</NuxtLink
					>{{ t('UnaGapsSorbentsEnd') }}</li
				>
				<li
					>{{ t('UnaGapsAntisepticsA')
					}}<NuxtLink :to="getSubstanceLink(SUBSTANCE_ID.povidoneIodine)">{{
						t('UnaGapsAntisepticsPovidone')
					}}</NuxtLink
					>{{ t('UnaGapsAntisepticsMid')
					}}<NuxtLink :to="getSubstanceLink(SUBSTANCE_ID.octenidine)">{{
						t('UnaGapsAntisepticsOctenidine')
					}}</NuxtLink
					>{{ t('UnaGapsAntisepticsEnd') }}</li
				>
				<li
					>{{ t('UnaGapsAntihistaminesA')
					}}<NuxtLink :to="getSubstanceLink(SUBSTANCE_ID.chloropyramine)">{{
						t('UnaGapsAntihistaminesChloropyramine')
					}}</NuxtLink
					>{{ t('UnaGapsAntihistaminesMid')
					}}<NuxtLink :to="synopenLink">{{
						t('UnaGapsAntihistaminesSynopen')
					}}</NuxtLink
					>{{ t('UnaGapsAntihistaminesMid2')
					}}<NuxtLink :to="getSubstanceLink(SUBSTANCE_ID.loratadine)">{{
						t('UnaGapsAntihistaminesLink1')
					}}</NuxtLink>, <NuxtLink
						:to="getSubstanceLink(SUBSTANCE_ID.desloratadine)"
						>{{ t('UnaGapsAntihistaminesLink2') }}</NuxtLink
					>, <NuxtLink :to="getSubstanceLink(SUBSTANCE_ID.fexofenadine)">{{
						t('UnaGapsAntihistaminesLink3')
					}}</NuxtLink
					>{{ t('UnaGapsAntihistaminesEnd')
					}}<NuxtLink :to="getSubstanceLink(SUBSTANCE_ID.dimetindene)">{{
						t('UnaGapsAntihistaminesDimetindene')
					}}</NuxtLink
					>{{ t('UnaGapsAntihistaminesDimMid')
					}}<NuxtLink :to="flentyLink">{{
						t('UnaGapsAntihistaminesFlenty')
					}}</NuxtLink
					>{{ t('UnaGapsAntihistaminesTail') }}</li
				>
				<li>{{ t('UnaGapsRehydration') }}</li>
				<li
					>{{ t('UnaGapsAnalgesicsA')
					}}<NuxtLink :to="caffetinLink">{{
						t('UnaGapsAnalgesicsCaffetin')
					}}</NuxtLink
					>{{ t('UnaGapsAnalgesicsMid')
					}}<NuxtLink :to="tylolHotLink">{{
						t('UnaGapsAnalgesicsTylolHot')
					}}</NuxtLink
					>{{ t('UnaGapsAnalgesicsMid2')
					}}<NuxtLink :to="getSubstanceLink(SUBSTANCE_ID.paracetamol)">{{
						t('UnaGapsAnalgesicsLink1')
					}}</NuxtLink>, <NuxtLink :to="getSubstanceLink(SUBSTANCE_ID.ibuprofen)">{{
						t('UnaGapsAnalgesicsLink2')
					}}</NuxtLink
					>{{ t('UnaGapsAnalgesicsEnd') }}</li
				>
				<li
					>{{ t('UnaGapsSpasmoA')
					}}<NuxtLink :to="getSubstanceLink(SUBSTANCE_ID.mebeverine)">{{
						t('UnaGapsSpasmoMebeverine')
					}}</NuxtLink
					>{{ t('UnaGapsSpasmoEnd') }}</li
				>
				<li>{{ t('UnaGapsMisc') }}</li>
			</ul>
			<p>
				{{ t('UnaGaps2') }}
				<NuxtLink :to="medicinesLink">{{ t('UnaGaps2Link') }}</NuxtLink
				>{{ t('UnaGaps2End') }}
			</p>
		</ArticleSection>

		<ArticleSection
			id="section-antivirals"
			:title="t('UnaToc_antivirals')"
		>
			<p>{{ t('UnaAntivirals1') }}</p>
			<p>{{ t('UnaAntivirals2') }}</p>
			<p
				>{{ t('UnaAntivirals3a')
				}}<NuxtLink :to="getSubstanceLink(SUBSTANCE_ID.vinpocetine)">{{
					t('UnaAntivirals3Vinpocetine')
				}}</NuxtLink
				>{{ t('UnaAntivirals3Mid')
				}}<NuxtLink :to="getSubstanceLink(SUBSTANCE_ID.cinnarizine)">{{
					t('UnaAntivirals3Cinnarizine')
				}}</NuxtLink
				>{{ t('UnaAntivirals3End') }}</p
			>
		</ArticleSection>

		<ArticleSection id="section-glp1" :title="t('UnaToc_glp1')">
			<p
				>{{ t('UnaGlp1a')
				}}<NuxtLink :to="ozempicLink">{{ t('UnaGlp1Ozempic') }}</NuxtLink
				>{{ t('UnaGlp1Mid')
				}}<NuxtLink :to="wegovyLink">{{ t('UnaGlp1Wegovy') }}</NuxtLink
				>{{ t('UnaGlp1End') }}</p
			>
			<p>{{ t('UnaGlp12') }}</p>
			<p
				>{{ t('UnaGlp13a')
				}}<NuxtLink :to="getSubstanceLink(SUBSTANCE_ID.metformin)">{{
					t('UnaGlp13Metformin')
				}}</NuxtLink
				>{{ t('UnaGlp13Mid')
				}}<NuxtLink :to="getSubstanceLink(SUBSTANCE_ID.dapagliflozin)">{{
					t('UnaGlp13Dapagliflozin')
				}}</NuxtLink
				>{{ t('UnaGlp13End') }}</p
			>
		</ArticleSection>

		<ArticleSection id="section-import" :title="t('UnaToc_import')">
			<p>{{ t('UnaImport1') }}</p>
			<p>{{ t('UnaImport2') }}</p>
		</ArticleSection>

		<ArticleSection id="section-access" :title="t('UnaToc_access')">
			<p>{{ t('UnaAccess1') }}</p>
			<p>
				{{ t('UnaAccess2') }}
				<NuxtLink :to="pharmaciesArticleLink">{{
					t('UnaAccess2Link')
				}}</NuxtLink
				>{{ t('UnaAccess2End') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-sources" :title="t('UnaToc_sources')">
			<p>{{ t('UnaSources0') }}</p>
			<ul>
				<li>
					<a
						href="https://cinmed.me"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('UnaSourcesCinmed') }}</a
					>
				</li>
				<li>
					<a
						href="https://fzocg.me"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('UnaSourcesFzo') }}</a
					>
				</li>
			</ul>
			<p>
				{{ t('UnaSourcesDoctors') }}
				<NuxtLink :to="doctorsLink">{{ t('UnaSourcesDoctorsLink') }}</NuxtLink
				>{{ t('UnaSourcesDoctorsEnd') }}
			</p>
		</ArticleSection>
	</ArticlePage>
</template>
