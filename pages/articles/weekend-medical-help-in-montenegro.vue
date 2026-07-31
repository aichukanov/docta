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
const SECTION_IDS = [
	'overview',
	'pharmacies',
	'hospitals',
	'clinics',
	'sources',
] as const;

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
				>{{ t('WmhHospitals1a')
				}}<ClinicRouteLink :to="kccgLink">{{
					t('WmhHospitals1KccgLink')
				}}</ClinicRouteLink
				>{{ t('WmhHospitals1b')
				}}<ClinicRouteLink :to="kotorHospitalLink">{{
					t('WmhHospitals1KotorLink')
				}}</ClinicRouteLink
				>{{ t('WmhHospitals1c')
				}}<ClinicRouteLink :to="barHospitalLink">{{
					t('WmhHospitals1BarLink')
				}}</ClinicRouteLink
				>{{ t('WmhHospitals1d')
				}}<ClinicRouteLink :to="bijeloPoljeHospitalLink">{{
					t('WmhHospitals1BijeloPoljeLink')
				}}</ClinicRouteLink
				>{{ t('WmhHospitals1e')
				}}<ClinicRouteLink :to="meljineHospitalLink">{{
					t('WmhHospitals1MeljineLink')
				}}</ClinicRouteLink
				>{{ t('WmhHospitals1f')
				}}<ClinicRouteLink :to="daniloHospitalLink">{{
					t('WmhHospitals1DaniloLink')
				}}</ClinicRouteLink
				>{{ t('WmhHospitals1g') }}</p
			>
			<p>
				{{ t('WmhHospitals2') }}
				<ClinicRouteLink :to="codraHospitalLink">{{
					t('WmhHospitalsLink')
				}}</ClinicRouteLink>
				{{ t('WmhHospitalsMid') }}
				{{ t('WmhHospitalsEnd') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-clinics" :title="t('WmhToc_clinics')">
			<p>{{ t('WmhClinicsIntro') }}</p>
			<ul>
				<li
					>{{ t('WmhClinicsPodgoricaLabel') }}
					<ClinicRouteLink :to="hipokratPodgoricaLink">{{
						t('WmhClinicsHipokratLink')
					}}</ClinicRouteLink
					>{{ t('WmhClinicsPodgoricaA')
					}}<ClinicRouteLink :to="milmedikaPodgoricaLink">{{
						t('WmhClinicsMilmedikaPgLink')
					}}</ClinicRouteLink
					>{{ t('WmhClinicsPodgoricaB')
					}}<ClinicRouteLink :to="mojLabPodgoricaLink">{{
						t('WmhClinicsMojLabPgLink')
					}}</ClinicRouteLink
					>{{ t('WmhClinicsPodgoricaC')
					}}<ClinicRouteLink :to="mojLabPedijatriaLink">{{
						t('WmhClinicsMojLabPedLink')
					}}</ClinicRouteLink
					>{{ t('WmhClinicsPodgoricaD')
					}}<ClinicRouteLink :to="medikidLink">{{
						t('WmhClinicsMedikidLink')
					}}</ClinicRouteLink
					>{{ t('WmhClinicsPodgoricaE') }}</li
				>
				<li
					>{{ t('WmhClinicsBudvaLabel') }}
					<ClinicRouteLink :to="milmedikaBudvaLink">{{
						t('WmhClinicsMilmedikaBdLink')
					}}</ClinicRouteLink
					>{{ t('WmhClinicsBudvaA')
					}}<ClinicRouteLink :to="mojLabBudvaLink">{{
						t('WmhClinicsMojLabBdLink')
					}}</ClinicRouteLink
					>{{ t('WmhClinicsBudvaB') }}</li
				>
				<li
					>{{ t('WmhClinicsBarLabel') }}
					<ClinicRouteLink :to="drMasonicicLink">{{
						t('WmhClinicsMasonicicLink')
					}}</ClinicRouteLink
					>{{ t('WmhClinicsBarA')
					}}<ClinicRouteLink :to="a3MedicalLink">{{
						t('WmhClinicsA3Link')
					}}</ClinicRouteLink
					>{{ t('WmhClinicsBarB') }}</li
				>
				<li
					>{{ t('WmhClinicsTivatLabel') }}
					<ClinicRouteLink :to="mansaMedicaLink">{{
						t('WmhClinicsMansaLink')
					}}</ClinicRouteLink
					>{{ t('WmhClinicsTivatA')
					}}<ClinicRouteLink :to="dentalExpertLink">{{
						t('WmhClinicsDentalExpertLink')
					}}</ClinicRouteLink
					>{{ t('WmhClinicsTivatB') }}</li
				>
				<li
					>{{ t('WmhClinicsNiksicLabel') }}
					<ClinicRouteLink :to="milmedikaNiksicLink">{{
						t('WmhClinicsMilmedikaNkLink')
					}}</ClinicRouteLink
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
