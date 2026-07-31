<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import { combineI18nMessages } from '~/i18n/utils';

import articlesI18n from '~/i18n/articles';
import articleHealthcareI18n from '~/i18n/article-healthcare-system';
import breadcrumbI18n from '~/i18n/breadcrumb';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		articlesI18n,
		articleHealthcareI18n,
		breadcrumbI18n,
	]),
});

const ARTICLE_SLUG = 'healthcare-system-in-montenegro';

const clinicsLink = computed(() => ({
	name: 'clinics',
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

const kccgLink = computed(() =>
	getClinicLink('klinicki-centar-crne-gore-podgorica'),
);
const kotorHospitalLink = computed(() => getClinicLink('opsta-bolnica-kotor'));
const barHospitalLink = computed(() =>
	getClinicLink('opsta-bolnica-blazo-orlandic'),
);
const risanHospitalLink = computed(() =>
	getClinicLink(
		'specijalna-bolnica-za-ortopediju-neurohirurgiju-i-neurologiju-vaso-cukovic-risan',
	),
);
const cetinjeHospitalLink = computed(() =>
	getClinicLink('bolnica-danilo-i-cetinje'),
);
const bijeloPoljeHospitalLink = computed(() =>
	getClinicLink('opsta-bolnica-bijelo-polje'),
);
const dobrotaHospitalLink = computed(() =>
	getClinicLink('specijalna-bolnica-za-psihijatriju-dobrota-kotor'),
);
const brezovikHospitalLink = computed(() =>
	getClinicLink(
		'specijalna-bolnica-za-plucne-bolesti-dr-jovan-bulajic-brezovik',
	),
);
const niksicHospitalLink = computed(() =>
	getClinicLink('opsta-bolnica-niksic'),
);
const beraneHospitalLink = computed(() =>
	getClinicLink('opsta-bolnica-berane'),
);
const pljevljaHospitalLink = computed(() =>
	getClinicLink('opsta-bolnica-pljevlja'),
);

const SL_LIST_URL =
	'https://fzocg.me/wp-content/uploads/2025/10/Zakon-o-obaveznom-zdravstvenom-osiguranju-2024.pdf';

// Ссылки на страховые ведут на внутренние страницы каталога
// (pages/insurance-companies/[companySlug]) вместо внешних сайтов страховых.
const insuranceCompanyLink = (slug: string) => ({
	name: 'insurance-companies-companySlug',
	params: { companySlug: slug },
	query: getRegionalQuery(locale.value),
});

const savaLink = computed(() => insuranceCompanyLink('sava'));
const lovcenLink = computed(() => insuranceCompanyLink('lovcen'));
const uniqaLink = computed(() => insuranceCompanyLink('uniqa'));
const generaliLink = computed(() => insuranceCompanyLink('generali'));
const graweLink = computed(() => insuranceCompanyLink('grawe'));

const medicationsLink = computed(() => ({
	name: 'medications',
	query: getRegionalQuery(locale.value),
}));

// Секции статьи: id → ключи заголовков для TOC и разметки
const SECTION_IDS = [
	'emergency',
	'state-system',
	'knjizica',
	'without-knjizica',
	'foreigners',
	'insurance',
	'medications',
	'sources',
] as const;

const articleToc = computed(() =>
	SECTION_IDS.map((id) => ({
		id: `section-${id}`,
		label: t(`HcsToc_${id}`),
	})),
);

// CTA: каталог клиник
const articleCta = computed(() => ({
	title: t('CtaClinicsTitle'),
	text: t('CtaClinicsText'),
	button: t('CtaClinicsButton'),
	link: clinicsLink.value,
}));

const { breadcrumbItems } = useArticlePageSeo({
	slug: ARTICLE_SLUG,
	title: computed(() => t('HealthcareSystemTitle')),
	description: computed(() => t('HealthcareSystemDescription')),
	image: `/img/articles/${ARTICLE_SLUG}.webp`,
	datePublished: '2026-07-16',
	t,
	locale,
});
</script>

<template>
	<ArticlePage
		:breadcrumbs="breadcrumbItems"
		:title="t('HealthcareSystemTitle')"
		:description="t('HealthcareSystemDescription')"
		image="/img/articles/healthcare-system-in-montenegro.webp"
		:toc="articleToc"
		:cta="articleCta"
	>
		<ArticleSection id="section-emergency" :title="t('HcsToc_emergency')">
			<p>{{ t('HcsEmergency1') }}</p>
			<p>{{ t('HcsEmergency2') }}</p>
			<p>
				{{ t('HcsEmergency3a') }}
				<ClinicRouteLink :to="kccgLink">{{
					t('HcsEmergency3KccgLink')
				}}</ClinicRouteLink
				>{{ t('HcsEmergency3b') }}
				<ClinicRouteLink :to="kotorHospitalLink">{{
					t('HcsEmergency3KotorLink')
				}}</ClinicRouteLink
				>{{ t('HcsEmergency3c') }}
				<ClinicRouteLink :to="barHospitalLink">{{
					t('HcsEmergency3BarLink')
				}}</ClinicRouteLink
				>{{ t('HcsEmergency3d') }}
				<ClinicRouteLink :to="risanHospitalLink">{{
					t('HcsEmergency3RisanLink')
				}}</ClinicRouteLink
				>{{ t('HcsEmergency3e') }}
			</p>
			<p>{{ t('HcsEmergency4') }}</p>
		</ArticleSection>

		<ArticleSection id="section-state-system" :title="t('HcsToc_state-system')">
			<p
				>{{ t('HcsState1a')
				}}<ClinicRouteLink :to="risanHospitalLink">{{
					t('HcsState1RisanLink')
				}}</ClinicRouteLink
				>{{ t('HcsState1b')
				}}<ClinicRouteLink :to="brezovikHospitalLink">{{
					t('HcsState1BrezovikLink')
				}}</ClinicRouteLink
				>{{ t('HcsState1b2')
				}}<ClinicRouteLink :to="dobrotaHospitalLink">{{
					t('HcsState1DobrotaLink')
				}}</ClinicRouteLink
				>{{ t('HcsState1c') }}</p
			>
			<ul>
				<li>{{ t('HcsStateLevel1') }}</li>
				<li>
					{{ t('HcsStateLevel2a') }}
					<ClinicRouteLink :to="barHospitalLink">{{
						t('HcsStateLevel2BarLink')
					}}</ClinicRouteLink
					>{{ t('HcsStateLevel2b') }}
					<ClinicRouteLink :to="kotorHospitalLink">{{
						t('HcsStateLevel2KotorLink')
					}}</ClinicRouteLink
					>{{ t('HcsStateLevel2c')
					}}<ClinicRouteLink :to="niksicHospitalLink">{{
						t('HcsStateLevel2NiksicLink')
					}}</ClinicRouteLink
					>{{ t('HcsStateLevel2c2')
					}}<ClinicRouteLink :to="beraneHospitalLink">{{
						t('HcsStateLevel2BeraneLink')
					}}</ClinicRouteLink
					>{{ t('HcsStateLevel2c3') }}
					<ClinicRouteLink :to="bijeloPoljeHospitalLink">{{
						t('HcsStateLevel2BijeloPoljeLink')
					}}</ClinicRouteLink
					>{{ t('HcsStateLevel2d') }}
					<ClinicRouteLink :to="cetinjeHospitalLink">{{
						t('HcsStateLevel2CetinjeLink')
					}}</ClinicRouteLink
					>{{ t('HcsStateLevel2e')
					}}<ClinicRouteLink :to="pljevljaHospitalLink">{{
						t('HcsStateLevel2PljevljaLink')
					}}</ClinicRouteLink
					>{{ t('HcsStateLevel2e2') }}
				</li>
				<li
					>{{ t('HcsStateLevel3Pre')
					}}<ClinicRouteLink :to="kccgLink">{{
						t('HcsStateLevel3KccgLink')
					}}</ClinicRouteLink
					>{{ t('HcsStateLevel3a') }}</li
				>
			</ul>
			<p>{{ t('HcsState2') }}</p>
			<p>
				{{ t('HcsState3a') }}
				<a
					href="https://www.ezdravlje.me"
					target="_blank"
					rel="noopener nofollow"
					>{{ t('HcsState3EzdravljeLink') }}</a
				>{{ t('HcsState3b') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-knjizica" :title="t('HcsToc_knjizica')">
			<p
				>{{ t('HcsKnjizica1a')
				}}<a :href="SL_LIST_URL" target="_blank" rel="noopener nofollow">{{
					t('HcsKnjizica1SlListLink')
				}}</a
				>{{ t('HcsKnjizica1b') }}</p
			>
			<p>{{ t('HcsKnjizica2') }}</p>
			<p>{{ t('HcsKnjizica3') }}</p>
			<p>{{ t('HcsKnjizica4') }}</p>
		</ArticleSection>

		<ArticleSection
			id="section-without-knjizica"
			:title="t('HcsToc_without-knjizica')"
		>
			<p>{{ t('HcsWithout1') }}</p>
			<p>{{ t('HcsWithout2') }}</p>
			<p>
				{{ t('HcsWithout3') }}
				<NuxtLink :to="servicesLink">{{ t('HcsWithout3Link') }}</NuxtLink
				>{{ t('HcsWithout3End') }}
			</p>
			<p>
				{{ t('HcsWithout4') }}
				<NuxtLink :to="labtestsLink">{{ t('HcsWithout4Link') }}</NuxtLink
				>{{ t('HcsWithout4End') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-foreigners" :title="t('HcsToc_foreigners')">
			<p>{{ t('HcsForeigners1') }}</p>
			<p>{{ t('HcsForeigners2') }}</p>
			<p>{{ t('HcsForeigners3') }}</p>
			<p>{{ t('HcsForeigners4') }}</p>
		</ArticleSection>

		<ArticleSection id="section-insurance" :title="t('HcsToc_insurance')">
			<p>
				{{ t('HcsInsurance1a') }}
				<NuxtLink :to="savaLink">{{ t('HcsInsurance1SavaLink') }}</NuxtLink
				>{{ t('HcsInsurance1b') }}
				<NuxtLink :to="lovcenLink">{{ t('HcsInsurance1LovcenLink') }}</NuxtLink
				>{{ t('HcsInsurance1c') }}
				<NuxtLink :to="uniqaLink">{{ t('HcsInsurance1UniqaLink') }}</NuxtLink
				>{{ t('HcsInsurance1d') }}
				<NuxtLink :to="generaliLink">{{
					t('HcsInsurance1GeneraliLink')
				}}</NuxtLink
				>{{ t('HcsInsurance1e') }}
				<NuxtLink :to="graweLink">{{ t('HcsInsurance1GraweLink') }}</NuxtLink
				>{{ t('HcsInsurance1f') }}
			</p>
			<p>{{ t('HcsInsurance2') }}</p>
		</ArticleSection>

		<ArticleSection id="section-medications" :title="t('HcsToc_medications')">
			<p>{{ t('HcsMedications1') }}</p>
			<p>
				{{ t('HcsMedications2') }}
				<NuxtLink :to="medicationsLink">{{ t('HcsMedications2Link') }}</NuxtLink
				>{{ t('HcsMedications2End') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-sources" :title="t('HcsToc_sources')">
			<p>{{ t('HcsSources0') }}</p>
			<ul>
				<li>{{ t('HcsSourcesPhones') }}</li>
				<li>
					<a href="https://fzocg.me" target="_blank" rel="noopener nofollow">{{
						t('HcsSourcesFzo')
					}}</a>
				</li>
				<li>
					<a
						href="https://www.ezdravlje.me"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('HcsSourcesEzdravlje') }}</a
					>
				</li>
				<li>
					<a
						href="https://www.kccg.me/lista-cekanja/"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('HcsSourcesWaiting') }}</a
					>
				</li>
				<li>
					<a
						href="https://www.gov.uk/guidance/uk-reciprocal-healthcare-agreements-with-non-eu-countries"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('HcsSourcesGovUk') }}</a
					>
				</li>
			</ul>
		</ArticleSection>
	</ArticlePage>
</template>
