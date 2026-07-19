<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import { combineI18nMessages } from '~/i18n/utils';
import { DoctorSpecialty } from '~/enums/specialty';

import articleMentalHealthI18n from '~/i18n/article-mental-health';
import breadcrumbI18n from '~/i18n/breadcrumb';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([articleMentalHealthI18n, breadcrumbI18n]),
});

const ARTICLE_SLUG = 'mental-health-in-montenegro';

// Каталог врачей с предустановленным фильтром «психиатрия»
const psychiatristsLink = computed(() => ({
	name: 'doctors',
	query: {
		specialtyIds: [String(DoctorSpecialty.PSYCHIATRY)],
		...getRegionalQuery(locale.value),
	},
}));

const doctorsLink = computed(() => ({
	name: 'doctors',
	query: getRegionalQuery(locale.value),
}));

const getClinicLink = (slug: string) => ({
	name: 'clinics-clinicSlug',
	params: { clinicSlug: slug },
	query: getRegionalQuery(locale.value),
});

const dobrotaHospitalLink = computed(() =>
	getClinicLink('specijalna-bolnica-za-psihijatriju-dobrota-kotor'),
);
const kccgLink = computed(() =>
	getClinicLink('klinicki-centar-crne-gore-podgorica'),
);

const medicationsLink = computed(() => ({
	name: 'medications',
	query: getRegionalQuery(locale.value),
}));

const healthcareArticleLink = computed(() => ({
	path: '/articles/healthcare-system-in-montenegro',
	query: getRegionalQuery(locale.value),
}));

const AA_BUDVA_URL = 'https://aabelarus.org/groups/groups-ru/chernogoria-aa/';
const NARDOS_URL = 'https://nardoscg.me/';

const SERTRALINE_SUBSTANCE_ID = 738;
const sertralineLink = computed(() => ({
	name: 'medicines',
	query: {
		substanceIds: SERTRALINE_SUBSTANCE_ID,
		...getRegionalQuery(locale.value),
	},
}));

// Секции статьи: id → ключи заголовков для TOC и разметки
const SECTION_IDS = [
	'system',
	'therapy',
	'prescriptions',
	'costs',
	'crisis',
	'sources',
] as const;

const articleToc = computed(() =>
	SECTION_IDS.map((id) => ({
		id: `section-${id}`,
		label: t(`MhmToc_${id}`),
	})),
);

// CTA: каталог психиатров
const articleCta = computed(() => ({
	title: t('MhmCtaTitle'),
	text: t('MhmCtaText'),
	button: t('MhmCtaButton'),
	link: psychiatristsLink.value,
}));

const { breadcrumbItems } = useArticlePageSeo({
	slug: ARTICLE_SLUG,
	title: computed(() => t('MentalHealthTitle')),
	description: computed(() => t('MentalHealthDescription')),
	image: `/img/articles/${ARTICLE_SLUG}.webp`,
	datePublished: '2026-07-16',
	t,
	locale,
});
</script>

<template>
	<ArticlePage
		:breadcrumbs="breadcrumbItems"
		:title="t('MentalHealthTitle')"
		:description="t('MentalHealthDescription')"
		image="/img/articles/mental-health-in-montenegro.webp"
		:toc="articleToc"
		:cta="articleCta"
	>
		<ArticleSection id="section-system" :title="t('MhmToc_system')">
			<p>{{ t('MhmSystem1') }}</p>
			<ul>
				<li>{{ t('MhmSystemLevel1') }}</li>
				<li>{{ t('MhmSystemLevel2') }}</li>
				<li
					>{{ t('MhmSystemLevel3a') }}<NuxtLink :to="dobrotaHospitalLink">{{
						t('MhmSystemLevel3DobrotaLink')
					}}</NuxtLink
					>{{ t('MhmSystemLevel3b') }}</li
				>
			</ul>
			<p>{{ t('MhmSystem2') }}</p>
			<p>
				{{ t('MhmSystem3') }}
				<NuxtLink :to="healthcareArticleLink">{{
					t('MhmSystem3Link')
				}}</NuxtLink
				>{{ t('MhmSystem3End') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-therapy" :title="t('MhmToc_therapy')">
			<p>{{ t('MhmTherapy1') }}</p>
			<p>{{ t('MhmTherapy2') }}</p>
			<p>{{ t('MhmTherapy3') }}</p>
			<p
				>{{ t('MhmTherapy3Groups') }}<a
					:href="AA_BUDVA_URL"
					target="_blank"
					rel="noopener nofollow"
					>{{ t('MhmTherapy3GroupsAaLink') }}</a
				>{{ t('MhmTherapy3GroupsMid') }}<a
					:href="NARDOS_URL"
					target="_blank"
					rel="noopener nofollow"
					>{{ t('MhmTherapy3GroupsNardosLink') }}</a
				>{{ t('MhmTherapy3GroupsEnd') }}</p
			>
			<p>
				{{ t('MhmTherapy4') }}
				<NuxtLink :to="doctorsLink">{{ t('MhmTherapy4Link') }}</NuxtLink
				>{{ t('MhmTherapy4End') }}
			</p>
		</ArticleSection>

		<ArticleSection
			id="section-prescriptions"
			:title="t('MhmToc_prescriptions')"
		>
			<p>{{ t('MhmRx1') }}</p>
			<p>{{ t('MhmRx2') }}</p>
			<p
				>{{ t('MhmRx3a') }}<NuxtLink :to="sertralineLink">{{
					t('MhmRx3SertralineLink')
				}}</NuxtLink
				>{{ t('MhmRx3b') }}</p
			>
			<p>{{ t('MhmRx4') }}</p>
			<p>
				{{ t('MhmRx5') }}
				<NuxtLink :to="medicationsLink">{{ t('MhmRx5Link') }}</NuxtLink
				>{{ t('MhmRx5End') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-costs" :title="t('MhmToc_costs')">
			<p>{{ t('MhmCosts1') }}</p>
			<p>{{ t('MhmCosts2') }}</p>
			<p>{{ t('MhmCosts3') }}</p>
		</ArticleSection>

		<ArticleSection id="section-crisis" :title="t('MhmToc_crisis')">
			<p>{{ t('MhmCrisis1') }}</p>
			<p>{{ t('MhmCrisis2') }}</p>
			<p>{{ t('MhmCrisis3') }}</p>
		</ArticleSection>

		<ArticleSection id="section-sources" :title="t('MhmToc_sources')">
			<p>{{ t('MhmSources0') }}</p>
			<ul>
				<li>{{ t('MhmSourcesPhones') }}</li>
				<li
					><NuxtLink :to="dobrotaHospitalLink">{{
						t('MhmSourcesDobrotaLink')
					}}</NuxtLink
					>{{ t('MhmSourcesDobrotaEnd') }}</li
				>
				<li
					><NuxtLink :to="kccgLink">{{
						t('MhmSourcesKccgLink')
					}}</NuxtLink
					>{{ t('MhmSourcesKccgEnd') }}</li
				>
				<li>
					<a
						href="https://fzocg.me"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('MhmSourcesFzo') }}</a
					>
				</li>
				<li>
					<a
						href="https://www.ezdravlje.me"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('MhmSourcesEzdravlje') }}</a
					>
				</li>
			</ul>
		</ArticleSection>
	</ArticlePage>
</template>
