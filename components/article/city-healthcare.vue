<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import { combineI18nMessages } from '~/i18n/utils';
import { CityId } from '~/enums/cities';

import articlesI18n from '~/i18n/articles';
import cityHealthcareI18n from '~/i18n/article-city-healthcare';
import breadcrumbI18n from '~/i18n/breadcrumb';

// Общий рендер серии статей «Медицина в {городе}»:
// одна структура контента, город задаётся пропом
export type CityHealthcareCity = 'budva' | 'podgorica' | 'kotor' | 'bar';

const props = defineProps<{
	city: CityHealthcareCity;
}>();

const CITY_IDS: Record<CityHealthcareCity, CityId> = {
	budva: CityId.BUDVA,
	podgorica: CityId.PODGORICA,
	kotor: CityId.KOTOR,
	bar: CityId.BAR,
};

// Флагманское государственное учреждение города — прямая ссылка на его страницу в каталоге
const STATE_CLINIC_SLUGS: Record<CityHealthcareCity, string> = {
	budva: 'dom-zdravlja-budva',
	podgorica: 'klinicki-centar-crne-gore-podgorica',
	kotor: 'opsta-bolnica-kotor',
	bar: 'opsta-bolnica-blazo-orlandic',
};

const LENAPHARM_MAPS_URL = 'https://maps.app.goo.gl/hkf6JFxwT6MUXfuXA';

const weekendArticleLink = computed(() => ({
	path: '/articles/weekend-medical-help-in-montenegro',
	query: getRegionalQuery(locale.value),
}));

const ARTICLE_DATE = '2026-07-16';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		articlesI18n,
		cityHealthcareI18n,
		breadcrumbI18n,
	]),
});

const articleSlug = computed(() => `healthcare-in-${props.city}`);
const articleImagePath = computed(
	() => `/img/articles/healthcare-in-${props.city}.webp`,
);

// Перелинковка с каталогами, отфильтрованными по городу статьи
const clinicsCityLink = computed(() => ({
	name: 'clinics',
	query: {
		...getRegionalQuery(locale.value),
		cityIds: String(CITY_IDS[props.city]),
	},
}));

const labtestsCityLink = computed(() => ({
	name: 'labtests',
	query: {
		...getRegionalQuery(locale.value),
		cityIds: String(CITY_IDS[props.city]),
	},
}));

const stateClinicLink = computed(() => ({
	name: 'clinics-clinicSlug',
	params: { clinicSlug: STATE_CLINIC_SLUGS[props.city] },
	query: getRegionalQuery(locale.value),
}));

// Секции статьи: id → ключи заголовков для TOC и разметки
const SECTION_IDS = [
	'overview',
	'emergency',
	'state',
	'private',
	'pharmacies',
] as const;

const articleToc = computed(() =>
	SECTION_IDS.map((id) => ({
		id: `section-${id}`,
		label: t(`CityHcToc_${id}`),
	})),
);

// CTA: каталог клиник города
const articleCta = computed(() => ({
	title: t('CityHcCtaTitle'),
	text: t('CityHcCtaText'),
	button: t(`CityHcCtaButton_${props.city}`),
	link: clinicsCityLink.value,
}));

const { breadcrumbItems } = useArticlePageSeo({
	slug: articleSlug,
	title: computed(() => t(`CityHcTitle_${props.city}`)),
	description: computed(() => t(`CityHcDescription_${props.city}`)),
	image: articleImagePath,
	datePublished: ARTICLE_DATE,
	t,
	locale,
});
</script>

<template>
	<ArticlePage
		:breadcrumbs="breadcrumbItems"
		:title="t(`CityHcTitle_${city}`)"
		:description="t(`CityHcDescription_${city}`)"
		:image="articleImagePath"
		:toc="articleToc"
		:cta="articleCta"
	>
		<ArticleSection id="section-overview" :title="t('CityHcToc_overview')">
			<p>{{ t(`CityHcOverview1_${city}`) }}</p>
			<p>{{ t(`CityHcOverview2_${city}`) }}</p>
		</ArticleSection>

		<ArticleSection id="section-emergency" :title="t('CityHcToc_emergency')">
			<p>{{ t(`CityHcEmergency1_${city}`) }}</p>
			<p>{{ t(`CityHcEmergency2_${city}`) }}</p>
			<p>{{ t('CityHcEmergencyShared') }}</p>
		</ArticleSection>

		<ArticleSection id="section-state" :title="t('CityHcToc_state')">
			<p>{{ t(`CityHcState1_${city}`) }}</p>
			<p>{{ t(`CityHcState2_${city}`) }}</p>
			<p>{{ t(`CityHcState3_${city}`) }}</p>
			<p>
				{{ t(`CityHcStateCatalog_${city}`) }}
				<NuxtLink :to="stateClinicLink">{{
					t(`CityHcStateLink_${city}`)
				}}</NuxtLink
				>{{ t('CityHcLinkEnd') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-private" :title="t('CityHcToc_private')">
			<p>{{ t(`CityHcPrivate1_${city}`) }}</p>
			<p>
				{{ t(`CityHcPrivateCatalog_${city}`) }}
				<NuxtLink :to="clinicsCityLink">{{
					t(`CityHcPrivateLink_${city}`)
				}}</NuxtLink
				>{{ t('CityHcLinkEnd') }}
			</p>
			<p>
				{{ t(`CityHcLabs_${city}`) }}
				<NuxtLink :to="labtestsCityLink">{{
					t(`CityHcLabsLink_${city}`)
				}}</NuxtLink
				>{{ t('CityHcLinkEnd') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-pharmacies" :title="t('CityHcToc_pharmacies')">
			<p>{{ t(`CityHcPharmacy1_${city}`) }}</p>
			<p v-if="city === 'bar'">
				{{ t('CityHcLenapharmText_bar') }}
				<a :href="LENAPHARM_MAPS_URL" target="_blank" rel="noopener"
					>Lenapharm</a
				>
				{{ t('CityHcLenapharmAfter_bar') }}
			</p>
			<p>{{ t(`CityHcPharmacy2_${city}`) }}</p>
			<p>
				{{ t('CityHcWeekendText') }}
				<NuxtLink :to="weekendArticleLink">{{
					t('CityHcWeekendLink')
				}}</NuxtLink
				>{{ t('CityHcLinkEnd') }}
			</p>
		</ArticleSection>
	</ArticlePage>
</template>
