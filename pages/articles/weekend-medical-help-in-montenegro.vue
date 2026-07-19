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

const getClinicLink = (slug: string) => ({
	name: 'clinics-clinicSlug',
	params: { clinicSlug: slug },
	query: getRegionalQuery(locale.value),
});

const codraHospitalLink = computed(() =>
	getClinicLink('codra-hospital-podgorica'),
);

const kccgLink = computed(() =>
	getClinicLink('klinicki-centar-crne-gore-podgorica'),
);
const kotorHospitalLink = computed(() => getClinicLink('opsta-bolnica-kotor'));
const barHospitalLink = computed(() =>
	getClinicLink('opsta-bolnica-blazo-orlandic'),
);
const bijeloPoljeHospitalLink = computed(() =>
	getClinicLink('opsta-bolnica-bijelo-polje'),
);
const meljineHospitalLink = computed(() =>
	getClinicLink('bolnica-meljine-herceg-novi'),
);
const daniloHospitalLink = computed(() =>
	getClinicLink('bolnica-danilo-i-cetinje'),
);

const hipokratPodgoricaLink = computed(() =>
	getClinicLink('hipokrat-poliklinika-podgorica'),
);
const milmedikaPodgoricaLink = computed(() =>
	getClinicLink('milmedika-podgorica'),
);
const mojLabPodgoricaLink = computed(() =>
	getClinicLink('moj-lab-podgorica-1'),
);
const mojLabPedijatriaLink = computed(() =>
	getClinicLink('moj-lab-pedijatria-podgorica'),
);
const medikidLink = computed(() => getClinicLink('medikid-podgorica'));

const milmedikaBudvaLink = computed(() => getClinicLink('milmedika-budva'));
const mojLabBudvaLink = computed(() => getClinicLink('moj-lab-budva'));

const drMasonicicLink = computed(() =>
	getClinicLink('poliklinika-dr-masonicic-bar'),
);
const a3MedicalLink = computed(() => getClinicLink('a3-medical-sutomore'));

const mansaMedicaLink = computed(() => getClinicLink('mansa-medica-tivat'));
const dentalExpertLink = computed(() => getClinicLink('dental-expert-tivat'));

const milmedikaNiksicLink = computed(() => getClinicLink('milmedika-niksic'));

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
			<p
				>{{ t('WmhHospitals1a') }}<NuxtLink :to="kccgLink">{{
					t('WmhHospitals1KccgLink')
				}}</NuxtLink
				>{{ t('WmhHospitals1b') }}<NuxtLink :to="kotorHospitalLink">{{
					t('WmhHospitals1KotorLink')
				}}</NuxtLink
				>{{ t('WmhHospitals1c') }}<NuxtLink :to="barHospitalLink">{{
					t('WmhHospitals1BarLink')
				}}</NuxtLink
				>{{ t('WmhHospitals1d') }}<NuxtLink :to="bijeloPoljeHospitalLink">{{
					t('WmhHospitals1BijeloPoljeLink')
				}}</NuxtLink
				>{{ t('WmhHospitals1e') }}<NuxtLink :to="meljineHospitalLink">{{
					t('WmhHospitals1MeljineLink')
				}}</NuxtLink
				>{{ t('WmhHospitals1f') }}<NuxtLink :to="daniloHospitalLink">{{
					t('WmhHospitals1DaniloLink')
				}}</NuxtLink
				>{{ t('WmhHospitals1g') }}</p
			>
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
			<p>{{ t('WmhClinicsIntro') }}</p>
			<ul>
				<li
					>{{ t('WmhClinicsPodgoricaLabel') }}
					<NuxtLink :to="hipokratPodgoricaLink">{{
						t('WmhClinicsHipokratLink')
					}}</NuxtLink
					>{{ t('WmhClinicsPodgoricaA') }}<NuxtLink
						:to="milmedikaPodgoricaLink"
						>{{ t('WmhClinicsMilmedikaPgLink') }}</NuxtLink
					>{{ t('WmhClinicsPodgoricaB') }}<NuxtLink
						:to="mojLabPodgoricaLink"
						>{{ t('WmhClinicsMojLabPgLink') }}</NuxtLink
					>{{ t('WmhClinicsPodgoricaC') }}<NuxtLink
						:to="mojLabPedijatriaLink"
						>{{ t('WmhClinicsMojLabPedLink') }}</NuxtLink
					>{{ t('WmhClinicsPodgoricaD') }}<NuxtLink :to="medikidLink">{{
						t('WmhClinicsMedikidLink')
					}}</NuxtLink
					>{{ t('WmhClinicsPodgoricaE') }}</li
				>
				<li
					>{{ t('WmhClinicsBudvaLabel') }}
					<NuxtLink :to="milmedikaBudvaLink">{{
						t('WmhClinicsMilmedikaBdLink')
					}}</NuxtLink
					>{{ t('WmhClinicsBudvaA') }}<NuxtLink :to="mojLabBudvaLink">{{
						t('WmhClinicsMojLabBdLink')
					}}</NuxtLink
					>{{ t('WmhClinicsBudvaB') }}</li
				>
				<li
					>{{ t('WmhClinicsBarLabel') }}
					<NuxtLink :to="drMasonicicLink">{{
						t('WmhClinicsMasonicicLink')
					}}</NuxtLink
					>{{ t('WmhClinicsBarA') }}<NuxtLink :to="a3MedicalLink">{{
						t('WmhClinicsA3Link')
					}}</NuxtLink
					>{{ t('WmhClinicsBarB') }}</li
				>
				<li
					>{{ t('WmhClinicsTivatLabel') }}
					<NuxtLink :to="mansaMedicaLink">{{
						t('WmhClinicsMansaLink')
					}}</NuxtLink
					>{{ t('WmhClinicsTivatA') }}<NuxtLink :to="dentalExpertLink">{{
						t('WmhClinicsDentalExpertLink')
					}}</NuxtLink
					>{{ t('WmhClinicsTivatB') }}</li
				>
				<li
					>{{ t('WmhClinicsNiksicLabel') }}
					<NuxtLink :to="milmedikaNiksicLink">{{
						t('WmhClinicsMilmedikaNkLink')
					}}</NuxtLink
					>{{ t('WmhClinicsNiksicA') }}</li
				>
			</ul>
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
			</ul>
			<p>{{ t('WmhSourcesCatalog') }}</p>
		</ArticleSection>
	</ArticlePage>
</template>
