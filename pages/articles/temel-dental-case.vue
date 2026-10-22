<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import { combineI18nMessages } from '~/i18n/utils';

import articlesI18n from '~/i18n/articles';
import articleTemelDentalI18n from '~/i18n/article-temel-dental';
import breadcrumbI18n from '~/i18n/breadcrumb';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		articlesI18n,
		articleTemelDentalI18n,
		breadcrumbI18n,
	]),
});

const ARTICLE_SLUG = 'temel-dental-case';

/**
 * Статья-расследование по задокументированному случаю. Редакционные решения
 * (конфликт интересов, атрибуция цитат, цифры из каталога) — в шапке
 * i18n/article-temel-dental.ts, там же срез цен. Раздел «Позиция клиники»
 * дополнить, если клиника пришлёт комментарий (почты для запроса у неё
 * не нашлось, см. docs/drafts/letter-temel-dental.sr.md).
 */

// Та самая «расширительная пластинка» из кейса: карточка услуги с ценами
// клиник (180–300 €) — главный пруф против цитаты «не стоит 200 евро».
const plateServiceLink = computed(() => ({
	name: 'services-serviceSlug',
	params: { serviceSlug: 'orthodontic-removable-plate-appliance' },
	query: getRegionalQuery(locale.value),
}));

// Упоминания клиник в тексте — внутренние ссылки на их карточки в каталоге.
const temelClinicLink = computed(() => ({
	name: 'clinics-clinicSlug',
	params: { clinicSlug: 'temel-dental-podgorica' },
	query: getRegionalQuery(locale.value),
}));
const kccgClinicLink = computed(() => ({
	name: 'clinics-clinicSlug',
	params: { clinicSlug: 'klinicki-centar-crne-gore-podgorica' },
	query: getRegionalQuery(locale.value),
}));

// Внешние источники секции section-sources. Научные обзоры — те, на которых
// держится секция про «расширяется самостоятельно»; не менять без сверки
// текста TmdSci3.
const SRC_SCI_2017_URL =
	'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5525446/';
const SRC_SCI_2024_URL =
	'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11049362/';
const SRC_ZZP_URL = 'https://www.sluzbenilist.me/registri/390438/download';
const SRC_FISK_URL =
	'https://www.paragraf.me/dnevne-vijesti/01082019/01082019-vijest1.html';
const SRC_PRAVA_URL =
	'https://www.paragraf.me/dnevne-vijesti/17012020/17012020-vijest2.html';
const SRC_CEZAP_URL = 'https://cezap.me/';

const SECTION_IDS = [
	'case',
	'science',
	'flags',
	'reviews',
	'position',
	'law',
	'checklist',
	'paid',
	'docta',
	'sources',
] as const;

const articleToc = computed(() =>
	SECTION_IDS.map((id) => ({
		id: `section-${id}`,
		label: t(`TmdToc_${id}`),
	})),
);

const articleCta = computed(() => ({
	title: t('TmdCtaTitle'),
	text: t('TmdCtaText'),
	button: t('TmdCtaButton'),
	link: plateServiceLink.value,
}));

const { breadcrumbItems } = useArticlePageSeo({
	slug: ARTICLE_SLUG,
	title: computed(() => t('TmdTitle')),
	description: computed(() => t('TmdDescription')),
	image: `/img/articles/${ARTICLE_SLUG}.webp`,
	datePublished: '2026-10-20',
	t,
	locale,
});
</script>

<template>
	<ArticlePage
		:breadcrumbs="breadcrumbItems"
		:title="t('TmdTitle')"
		:description="t('TmdDescription')"
		:image="`/img/articles/${ARTICLE_SLUG}.webp`"
		:toc="articleToc"
		:cta="articleCta"
	>
		<ArticleSection id="section-case" :title="t('TmdToc_case')">
			<p
				>{{ t('TmdLead1a')
				}}<NuxtLink :to="temelClinicLink">{{ t('TmdLead1Link') }}</NuxtLink
				>{{ t('TmdLead1End') }}</p
			>
			<p>{{ t('TmdLead2') }}</p>
			<p>{{ t('TmdCase1') }}</p>
			<p>{{ t('TmdCase2') }}</p>
			<p
				>{{ t('TmdCase3a')
				}}<NuxtLink :to="plateServiceLink">{{ t('TmdCase3Link') }}</NuxtLink
				>{{ t('TmdCase3End')
				}}<NuxtLink :to="kccgClinicLink">{{ t('TmdCase3KccgLink') }}</NuxtLink
				>{{ t('TmdCase3Tail') }}</p
			>
			<p>{{ t('TmdCase4') }}</p>
			<p>{{ t('TmdCase5') }}</p>
			<p>{{ t('TmdCase6') }}</p>
			<ul>
				<li>{{ t('TmdQuote1') }}</li>
				<li>{{ t('TmdQuote2') }}</li>
				<li>{{ t('TmdQuote3') }}</li>
				<li>{{ t('TmdQuote4') }}</li>
			</ul>
			<p>{{ t('TmdCase7') }}</p>
		</ArticleSection>

		<ArticleSection id="section-science" :title="t('TmdToc_science')">
			<p>{{ t('TmdSci1') }}</p>
			<p>{{ t('TmdSci2') }}</p>
			<p>{{ t('TmdSci3') }}</p>
			<p>{{ t('TmdSci4') }}</p>
		</ArticleSection>

		<ArticleSection id="section-flags" :title="t('TmdToc_flags')">
			<p
				><strong>{{ t('TmdFlag1T') }}</strong> {{ t('TmdFlag1X') }}</p
			>
			<p
				><strong>{{ t('TmdFlag2T') }}</strong> {{ t('TmdFlag2X') }}</p
			>
			<p
				><strong>{{ t('TmdFlag3T') }}</strong> {{ t('TmdFlag3X') }}</p
			>
			<p
				><strong>{{ t('TmdFlag4T') }}</strong> {{ t('TmdFlag4X') }}</p
			>
			<p
				><strong>{{ t('TmdFlag5T') }}</strong> {{ t('TmdFlag5X') }}</p
			>
		</ArticleSection>

		<ArticleSection id="section-reviews" :title="t('TmdToc_reviews')">
			<p>{{ t('TmdRev1') }}</p>
			<p
				><strong>{{ t('TmdRevPriceT') }}</strong> {{ t('TmdRevPriceX') }}</p
			>
			<p
				><strong>{{ t('TmdRevUpsellT') }}</strong> {{ t('TmdRevUpsellX') }}</p
			>
			<p
				><strong>{{ t('TmdRevQualityT') }}</strong> {{ t('TmdRevQualityX') }}</p
			>
			<p
				><strong>{{ t('TmdRevOrgT') }}</strong> {{ t('TmdRevOrgX') }}</p
			>
			<p>{{ t('TmdRevTg') }}</p>
		</ArticleSection>

		<ArticleSection id="section-position" :title="t('TmdToc_position')">
			<p>{{ t('TmdPos1') }}</p>
			<p
				>{{ t('TmdPos2a')
				}}<NuxtLink :to="plateServiceLink">{{ t('TmdPos2Link') }}</NuxtLink
				>{{ t('TmdPos2End') }}</p
			>
			<p>{{ t('TmdPos3') }}</p>
		</ArticleSection>

		<ArticleSection id="section-law" :title="t('TmdToc_law')">
			<p
				><strong>{{ t('TmdLawPriceT') }}</strong> {{ t('TmdLawPriceX') }}</p
			>
			<p
				><strong>{{ t('TmdLawFiscalT') }}</strong> {{ t('TmdLawFiscalX') }}</p
			>
			<p
				><strong>{{ t('TmdLawConsentT') }}</strong> {{ t('TmdLawConsentX') }}</p
			>
			<p
				><strong>{{ t('TmdLawWhereT') }}</strong> {{ t('TmdLawWhereX') }}</p
			>
		</ArticleSection>

		<ArticleSection id="section-checklist" :title="t('TmdToc_checklist')">
			<p>{{ t('TmdCheck0') }}</p>
			<ul>
				<li>{{ t('TmdCheck1') }}</li>
				<li>{{ t('TmdCheck2') }}</li>
				<li>{{ t('TmdCheck3') }}</li>
				<li>{{ t('TmdCheck4') }}</li>
				<li>{{ t('TmdCheck5') }}</li>
				<li>{{ t('TmdCheck6') }}</li>
			</ul>
		</ArticleSection>

		<ArticleSection id="section-paid" :title="t('TmdToc_paid')">
			<p>{{ t('TmdPaid0') }}</p>
			<ul>
				<li>{{ t('TmdPaid1') }}</li>
				<li>{{ t('TmdPaid2') }}</li>
				<li>{{ t('TmdPaid3') }}</li>
				<li>{{ t('TmdPaid4') }}</li>
				<li>{{ t('TmdPaid5') }}</li>
				<li>{{ t('TmdPaid6') }}</li>
			</ul>
		</ArticleSection>

		<ArticleSection id="section-docta" :title="t('TmdToc_docta')">
			<p>{{ t('TmdDocta1') }}</p>
			<p>{{ t('TmdDocta2') }}</p>
		</ArticleSection>

		<ArticleSection id="section-sources" :title="t('TmdToc_sources')">
			<p>{{ t('TmdSrcIntro') }}</p>
			<ul>
				<li>
					<a :href="SRC_SCI_2017_URL" target="_blank" rel="noopener nofollow">{{
						t('TmdSrcSci2017')
					}}</a>
				</li>
				<li>
					<a :href="SRC_SCI_2024_URL" target="_blank" rel="noopener nofollow">{{
						t('TmdSrcSci2024')
					}}</a>
				</li>
				<li>
					<a :href="SRC_ZZP_URL" target="_blank" rel="noopener nofollow">{{
						t('TmdSrcZzp')
					}}</a>
				</li>
				<li>
					<a :href="SRC_FISK_URL" target="_blank" rel="noopener nofollow">{{
						t('TmdSrcFisk')
					}}</a>
				</li>
				<li>
					<a :href="SRC_PRAVA_URL" target="_blank" rel="noopener nofollow">{{
						t('TmdSrcPrava')
					}}</a>
				</li>
				<li>
					<a :href="SRC_CEZAP_URL" target="_blank" rel="noopener nofollow">{{
						t('TmdSrcCezap')
					}}</a>
				</li>
			</ul>
		</ArticleSection>
	</ArticlePage>
</template>
