<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import { combineI18nMessages } from '~/i18n/utils';
import { ClinicType } from '~/enums/clinic-type';
import { DoctorSpecialty } from '~/enums/specialty';
import { MedicalServiceCategory } from '~/enums/medical-service-category';

import articlesI18n from '~/i18n/articles';
import articleDentistryI18n from '~/i18n/article-dentistry';
import breadcrumbI18n from '~/i18n/breadcrumb';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		articlesI18n,
		articleDentistryI18n,
		breadcrumbI18n,
	]),
});

const ARTICLE_SLUG = 'dentistry-in-montenegro';

// Каталог клиник, отфильтрованный по типу «стоматология»
const dentalClinicsLink = computed(() => ({
	name: 'clinics',
	query: {
		...getRegionalQuery(locale.value),
		clinicTypeIds: ClinicType.DENTAL_CLINIC,
	},
}));

// Каталог врачей, отфильтрованный по специальности «стоматолог»
const dentistsLink = computed(() => ({
	name: 'doctors',
	query: {
		...getRegionalQuery(locale.value),
		specialtyIds: DoctorSpecialty.DENTISTRY,
	},
}));

// Каталог услуг, отфильтрованный по категории «стоматология»
const dentalServicesLink = computed(() => ({
	name: 'services',
	query: {
		...getRegionalQuery(locale.value),
		serviceCategoryIds: MedicalServiceCategory.DENTISTRY,
	},
}));

const getServiceLink = (slug: string) => ({
	name: 'services-serviceSlug',
	params: { serviceSlug: slug },
	query: getRegionalQuery(locale.value),
});

const getClinicLink = (slug: string) => ({
	name: 'clinics-clinicSlug',
	params: { clinicSlug: slug },
	query: getRegionalQuery(locale.value),
});

const kccgLink = computed(() =>
	getClinicLink('klinicki-centar-crne-gore-podgorica'),
);

const consultLink = computed(() => getServiceLink('dental-consultation'));
const xrayLink = computed(() =>
	getServiceLink('standard-intraoral-dental-radiograph'),
);
const fillingLink = computed(() => getServiceLink('composite-filling'));
const canalLink = computed(() =>
	getServiceLink('root-canal-treatment-first-root'),
);
const extractLink = computed(() => getServiceLink('tooth-extraction'));
const complexExtractLink = computed(() =>
	getServiceLink('complex-tooth-extraction'),
);
const wisdomExtractLink = computed(() =>
	getServiceLink('impacted-tooth-extraction'),
);
const cleaningLink = computed(() => getServiceLink('complete-dental-cleaning'));
const whiteningLink = computed(() => getServiceLink('teeth-whitening'));
const metalCeramicCrownLink = computed(() =>
	getServiceLink('metal-ceramic-crown'),
);
const zirconiaCrownLink = computed(() =>
	getServiceLink('metal-free-zirconia-ceramic-crown'),
);
const removableDentureLink = computed(() => getServiceLink('complete-denture'));
const implantLink = computed(() => getServiceLink('dental-implant-placement'));
const metalBracesLink = computed(() =>
	getServiceLink('fixed-braces-metal-per-jaw'),
);
const ceramicBracesLink = computed(() =>
	getServiceLink('fixed-braces-ceramic-or-composite-per-jaw'),
);

// Секции статьи: id → ключи заголовков для TOC и разметки
const SECTION_IDS = [
	'state',
	'prices',
	'choose',
	'emergency',
	'sources',
] as const;

const articleToc = computed(() =>
	SECTION_IDS.map((id) => ({
		id: `section-${id}`,
		label: t(`DstToc_${id}`),
	})),
);

// CTA: каталог стоматологических клиник
const articleCta = computed(() => ({
	title: t('CtaClinicsTitle'),
	text: t('CtaClinicsText'),
	button: t('CtaClinicsButton'),
	link: dentalClinicsLink.value,
}));

const { breadcrumbItems } = useArticlePageSeo({
	slug: ARTICLE_SLUG,
	title: computed(() => t('DentistryTitle')),
	description: computed(() => t('DentistryDescription')),
	image: `/img/articles/${ARTICLE_SLUG}.webp`,
	datePublished: '2026-07-16',
	t,
	locale,
});
</script>

<template>
	<ArticlePage
		:breadcrumbs="breadcrumbItems"
		:title="t('DentistryTitle')"
		:description="t('DentistryDescription')"
		image="/img/articles/dentistry-in-montenegro.webp"
		:toc="articleToc"
		:cta="articleCta"
	>
		<ArticleSection id="section-state" :title="t('DstToc_state')">
			<p>{{ t('DstState1') }}</p>
			<p>{{ t('DstState2') }}</p>
			<p
				>{{ t('DstState3a') }}<NuxtLink :to="kccgLink">{{
					t('DstState3KccgLink')
				}}</NuxtLink
				>{{ t('DstState3b') }}</p
			>
			<p>
				{{ t('DstState4') }}
				<NuxtLink :to="dentalServicesLink">{{ t('DstState4Link') }}</NuxtLink
				>{{ t('DstState4End') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-prices" :title="t('DstToc_prices')">
			<p>{{ t('DstPrices1') }}</p>
			<ul>
				<li
					><NuxtLink :to="consultLink">{{
						t('DstPriceItem1ConsultLink')
					}}</NuxtLink
					>{{ t('DstPriceItem1a') }}<NuxtLink :to="xrayLink">{{
						t('DstPriceItem1XrayLink')
					}}</NuxtLink
					>{{ t('DstPriceItem1b') }}</li
				>
				<li
					><NuxtLink :to="fillingLink">{{
						t('DstPriceItem2FillingLink')
					}}</NuxtLink
					>{{ t('DstPriceItem2End') }}</li
				>
				<li
					><NuxtLink :to="canalLink">{{
						t('DstPriceItem3CanalLink')
					}}</NuxtLink
					>{{ t('DstPriceItem3End') }}</li
				>
				<li
					><NuxtLink :to="extractLink">{{
						t('DstPriceItem4ExtractLink')
					}}</NuxtLink
					>{{ t('DstPriceItem4a') }}<NuxtLink :to="complexExtractLink">{{
						t('DstPriceItem4ComplexLink')
					}}</NuxtLink
					>{{ t('DstPriceItem4b') }}<NuxtLink :to="wisdomExtractLink">{{
						t('DstPriceItem4WisdomLink')
					}}</NuxtLink
					>{{ t('DstPriceItem4c') }}</li
				>
				<li
					><NuxtLink :to="cleaningLink">{{
						t('DstPriceItem5CleaningLink')
					}}</NuxtLink
					>{{ t('DstPriceItem5a') }}<NuxtLink :to="whiteningLink">{{
						t('DstPriceItem5WhiteningLink')
					}}</NuxtLink
					>{{ t('DstPriceItem5b') }}</li
				>
				<li
					>{{ t('DstPriceItem6a') }}<NuxtLink :to="metalCeramicCrownLink">{{
						t('DstPriceItem6MetalCeramicLink')
					}}</NuxtLink
					>{{ t('DstPriceItem6b') }}<NuxtLink :to="zirconiaCrownLink">{{
						t('DstPriceItem6ZirconiaLink')
					}}</NuxtLink
					>{{ t('DstPriceItem6c') }}<NuxtLink :to="removableDentureLink">{{
						t('DstPriceItem6DentureLink')
					}}</NuxtLink
					>{{ t('DstPriceItem6d') }}</li
				>
				<li
					><NuxtLink :to="implantLink">{{
						t('DstPriceItem7ImplantLink')
					}}</NuxtLink
					>{{ t('DstPriceItem7a') }}<NuxtLink :to="metalBracesLink">{{
						t('DstPriceItem7MetalBracesLink')
					}}</NuxtLink
					>{{ t('DstPriceItem7b') }}<NuxtLink :to="ceramicBracesLink">{{
						t('DstPriceItem7CeramicBracesLink')
					}}</NuxtLink
					>{{ t('DstPriceItem7c') }}</li
				>
			</ul>
			<p>{{ t('DstPrices2') }}</p>
			<p>{{ t('DstPrices3') }}</p>
		</ArticleSection>

		<ArticleSection id="section-choose" :title="t('DstToc_choose')">
			<p>{{ t('DstChoose1') }}</p>
			<p>{{ t('DstChoose2') }}</p>
			<p>
				{{ t('DstChoose3') }}
				<NuxtLink :to="dentalClinicsLink">{{ t('DstChoose3Link') }}</NuxtLink
				>{{ t('DstChoose3Mid') }}
				<NuxtLink :to="dentistsLink">{{ t('DstChoose3Link2') }}</NuxtLink
				>{{ t('DstChoose3End') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-emergency" :title="t('DstToc_emergency')">
			<p>{{ t('DstEmergency1') }}</p>
			<p>{{ t('DstEmergency2') }}</p>
			<p>{{ t('DstEmergency3') }}</p>
		</ArticleSection>

		<ArticleSection id="section-sources" :title="t('DstToc_sources')">
			<p>{{ t('DstSources0') }}</p>
			<ul>
				<li>
					<a
						href="https://fzocg.me"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('DstSourcesFzo') }}</a
					>
				</li>
				<li>
					<a
						href="https://www.kccg.me/poliklinika/stomatoloska-poliklinika/"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('DstSourcesKccg') }}</a
					>
				</li>
				<li>
					<a
						href="https://stomkomcg.me"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('DstSourcesKomora') }}</a
					>
				</li>
			</ul>
		</ArticleSection>
	</ArticlePage>
</template>
