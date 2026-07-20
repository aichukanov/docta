<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import { combineI18nMessages } from '~/i18n/utils';
import { DoctorSpecialty } from '~/enums/specialty';

import articlesI18n from '~/i18n/articles';
import articleBirthI18n from '~/i18n/article-birth-in-montenegro';
import breadcrumbI18n from '~/i18n/breadcrumb';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([articlesI18n, articleBirthI18n, breadcrumbI18n]),
});

const ARTICLE_SLUG = 'birth-in-montenegro';

const BIRTH_SCANDAL_SOURCE_URL =
	'https://press.co.me/novorodence-u-kccg-potrosilo-600-eura/';

const clinicsLink = computed(() => ({
	name: 'clinics',
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
const barHospitalLink = computed(() =>
	getClinicLink('opsta-bolnica-blazo-orlandic'),
);
const kotorHospitalLink = computed(() => getClinicLink('opsta-bolnica-kotor'));
const bijeloPoljeHospitalLink = computed(() =>
	getClinicLink('opsta-bolnica-bijelo-polje'),
);
const cetinjeHospitalLink = computed(() =>
	getClinicLink('bolnica-danilo-i-cetinje'),
);
const codraHospitalLink = computed(() =>
	getClinicLink('codra-hospital-podgorica'),
);
const niksicHospitalLink = computed(() => getClinicLink('opsta-bolnica-niksic'));
const beraneHospitalLink = computed(() => getClinicLink('opsta-bolnica-berane'));
const pljevljaHospitalLink = computed(() =>
	getClinicLink('opsta-bolnica-pljevlja'),
);
const domZdravljaPodgoricaLink = computed(() =>
	getClinicLink('dom-zdravlja-podgorica'),
);

const vaginalDeliveryLink = computed(() => ({
	name: 'services-serviceSlug',
	params: { serviceSlug: 'vaginal-delivery-anterior-occiput-presentation' },
	query: getRegionalQuery(locale.value),
}));

const cesareanSectionLink = computed(() => ({
	name: 'services-serviceSlug',
	params: { serviceSlug: 'low-isthmic-cesarean-section-with-delivery' },
	query: getRegionalQuery(locale.value),
}));

const amniocentesisLink = computed(() => ({
	name: 'services-serviceSlug',
	params: { serviceSlug: 'amniocentesis' },
	query: getRegionalQuery(locale.value),
}));

const pappaLink = computed(() => ({
	name: 'labtests-labTestSlug',
	params: { labTestSlug: 'papp-a' },
	query: getRegionalQuery(locale.value),
}));

const freeBetaHcgLink = computed(() => ({
	name: 'labtests-labTestSlug',
	params: { labTestSlug: 'free-beta-hcg' },
	query: getRegionalQuery(locale.value),
}));

// Каталог врачей с предустановленным фильтром «гинекология и акушерство»
const gynecologistsLink = computed(() => ({
	name: 'doctors',
	query: {
		specialtyIds: [String(DoctorSpecialty.GYNECOLOGY_OBSTETRICS)],
		...getRegionalQuery(locale.value),
	},
}));

// Секции статьи: id → ключи заголовков для TOC и разметки
const SECTION_IDS = [
	'prenatal',
	'where',
	'costs',
	'practical',
	'after',
	'sources',
] as const;

const articleToc = computed(() =>
	SECTION_IDS.map((id) => ({
		id: `section-${id}`,
		label: t(`BimToc_${id}`),
	})),
);

// CTA: каталог врачей-гинекологов
const articleCta = computed(() => ({
	title: t('BimCtaTitle'),
	text: t('BimCtaText'),
	button: t('BimCtaButton'),
	link: gynecologistsLink.value,
}));

const { breadcrumbItems } = useArticlePageSeo({
	slug: ARTICLE_SLUG,
	title: computed(() => t('BirthInMontenegroTitle')),
	description: computed(() => t('BirthInMontenegroDescription')),
	image: `/img/articles/${ARTICLE_SLUG}.webp`,
	datePublished: '2026-07-16',
	t,
	locale,
});
</script>

<template>
	<ArticlePage
		:breadcrumbs="breadcrumbItems"
		:title="t('BirthInMontenegroTitle')"
		:description="t('BirthInMontenegroDescription')"
		image="/img/articles/birth-in-montenegro.webp"
		:toc="articleToc"
		:cta="articleCta"
	>
		<ArticleSection id="section-prenatal" :title="t('BimToc_prenatal')">
			<p>{{ t('BimPrenatal1') }}</p>
			<p>{{ t('BimPrenatal2') }}</p>
			<p
				>{{ t('BimPrenatal3a') }}<NuxtLink :to="pappaLink">{{
					t('BimPrenatal3PappaLink')
				}}</NuxtLink
				>{{ t('BimPrenatal3b') }}<NuxtLink :to="freeBetaHcgLink">{{
					t('BimPrenatal3FreeBetaHcgLink')
				}}</NuxtLink
				>{{ t('BimPrenatal3c') }}<NuxtLink :to="amniocentesisLink">{{
					t('BimPrenatal3AmnioLink')
				}}</NuxtLink
				>{{ t('BimPrenatal3d') }}</p
			>
			<p>
				{{ t('BimPrenatal4') }}
				<NuxtLink :to="gynecologistsLink">{{ t('BimPrenatal4Link') }}</NuxtLink
				>{{ t('BimPrenatal4End') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-where" :title="t('BimToc_where')">
			<p>{{ t('BimWhere1') }}</p>
			<ul>
				<li
					>{{ t('BimWhereList1Pre') }}<NuxtLink :to="kccgLink">{{
						t('BimWhereList1KccgLink')
					}}</NuxtLink
					>{{ t('BimWhereList1a') }}</li
				>
				<li
					>{{ t('BimWhereList2a') }}<NuxtLink :to="barHospitalLink">{{
						t('BimWhereList2BarLink')
					}}</NuxtLink
					>{{ t('BimWhereList2b') }}<NuxtLink :to="kotorHospitalLink">{{
						t('BimWhereList2KotorLink')
					}}</NuxtLink
					>{{ t('BimWhereList2c') }}<NuxtLink :to="niksicHospitalLink">{{
						t('BimWhereList2NiksicLink')
					}}</NuxtLink
					>{{ t('BimWhereList2c2') }}<NuxtLink :to="beraneHospitalLink">{{
						t('BimWhereList2BeraneLink')
					}}</NuxtLink
					>{{ t('BimWhereList2c3') }}<NuxtLink :to="bijeloPoljeHospitalLink">{{
						t('BimWhereList2BijeloPoljeLink')
					}}</NuxtLink
					>{{ t('BimWhereList2d') }}<NuxtLink :to="cetinjeHospitalLink">{{
						t('BimWhereList2CetinjeLink')
					}}</NuxtLink
					>{{ t('BimWhereList2e') }}<NuxtLink :to="pljevljaHospitalLink">{{
						t('BimWhereList2PljevljaLink')
					}}</NuxtLink
					>{{ t('BimWhereList2e2') }}</li
				>
				<li>{{ t('BimWhereList3') }}</li>
			</ul>
			<p>{{ t('BimWhere2') }}</p>
			<p
				>{{ t('BimWhere3a') }}<NuxtLink :to="codraHospitalLink">{{
					t('BimWhere3CodraLink')
				}}</NuxtLink
				>{{ t('BimWhere3b') }}<NuxtLink :to="kccgLink">{{
					t('BimWhere3KccgLink')
				}}</NuxtLink
				>{{ t('BimWhere3c') }}</p
			>
			<p>
				{{ t('BimWhere4') }}
				<NuxtLink :to="clinicsLink">{{ t('BimWhere4Link') }}</NuxtLink
				>{{ t('BimWhere4End') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-costs" :title="t('BimToc_costs')">
			<p>{{ t('BimCosts1') }}</p>
			<p>{{ t('BimCosts2') }}</p>
			<p>
				{{ t('BimCosts3') }}
				<NuxtLink :to="vaginalDeliveryLink">{{ t('BimCosts3Link') }}</NuxtLink>
				{{ t('BimCosts3Mid') }}
				<NuxtLink :to="cesareanSectionLink">{{ t('BimCosts3Link2') }}</NuxtLink
				>{{ t('BimCosts3End') }}
			</p>
			<p>{{ t('BimCosts4') }}</p>
			<p>
				{{ t('BimScandal1') }}
				<a :href="BIRTH_SCANDAL_SOURCE_URL" target="_blank" rel="noopener">{{
					t('BimScandalLink')
				}}</a
				>{{ t('BimScandalEnd') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-practical" :title="t('BimToc_practical')">
			<p>{{ t('BimPractical1') }}</p>
			<p>{{ t('BimPractical2') }}</p>
			<p>{{ t('BimPractical3') }}</p>
			<p>{{ t('BimPractical4') }}</p>
		</ArticleSection>

		<ArticleSection id="section-after" :title="t('BimToc_after')">
			<p>{{ t('BimAfter1') }}</p>
			<p>{{ t('BimAfter2') }}</p>
			<p>{{ t('BimAfter3') }}</p>
			<p>{{ t('BimAfter4') }}</p>
		</ArticleSection>

		<ArticleSection id="section-sources" :title="t('BimToc_sources')">
			<p>{{ t('BimSources0') }}</p>
			<ul>
				<li>
					<a
						href="https://www.kccg.me/klinike-i-centri/klinika-za-ginekologiju-i-akuserstvo/"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('BimSourcesKccg') }}</a
					>
				</li>
				<li>
					<a
						href="https://fzocg.me/osiguranici-i-osigurana-lica-fonda/"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('BimSourcesFzo') }}</a
					>
				</li>
				<li>{{ t('BimSourcesMup') }}</li>
				<li>
					<NuxtLink :to="domZdravljaPodgoricaLink">{{
						t('BimSourcesDz')
					}}</NuxtLink>
				</li>
			</ul>
		</ArticleSection>
	</ArticlePage>
</template>
