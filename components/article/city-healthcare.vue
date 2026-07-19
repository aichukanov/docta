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

const getClinicLink = (slug: string) => ({
	name: 'clinics-clinicSlug',
	params: { clinicSlug: slug },
	query: getRegionalQuery(locale.value),
});

// Реферальная больница из Emergency2_budva — общая с opsta-bolnica-kotor,
// но здесь используется отдельно от stateClinicLink (тот указывает на Dom Zdravlja Budva)
const kotorHospitalLink = computed(() => getClinicLink('opsta-bolnica-kotor'));
const kccgLink = computed(() =>
	getClinicLink('klinicki-centar-crne-gore-podgorica'),
);

// Более-менее полный список частных клиник Будвы (раздел section-private),
// сгруппированный по профилю; для остальных городов список пока не заведён
const milmedikaBudvaLink = computed(() => getClinicLink('milmedika-budva'));
const mojLabBudvaLink = computed(() => getClinicLink('moj-lab-budva'));
const bonoMedicaLink = computed(() => getClinicLink('bonomedica-budva'));
const medicalCentarBudvaLink = computed(() =>
	getClinicLink('medical-centar-budva'),
);
const dukleyDentalLink = computed(() =>
	getClinicLink('dukley-dental-clinic-budva'),
);
const reDentLink = computed(() => getClinicLink('redent-budva'));
const zecevicDentalLink = computed(() => getClinicLink('zecevic-dental-budva'));
const laserFocusLink = computed(() =>
	getClinicLink('laserfocus-centar-za-mikrohirurgiju-oka'),
);
const svjetlostEyeLink = computed(() =>
	getClinicLink('svjetlost-eye-clinic-budva'),
);
const humanaReprodukcijaLink = computed(() =>
	getClinicLink('humana-reprodukcija-budva'),
);

// Специализированные государственные больницы, упоминаемые в section-state
// статьи о Которе (Рисан и Доброта — не тот же слаг, что stateClinicLink)
const vasoCukovicRisanLink = computed(() =>
	getClinicLink(
		'specijalna-bolnica-za-ortopediju-neurohirurgiju-i-neurologiju-vaso-cukovic-risan',
	),
);
const dobrotaPsychiatricLink = computed(() =>
	getClinicLink('specijalna-bolnica-za-psihijatriju-dobrota-kotor'),
);

// Более-менее полный список частных клиник Котора (раздел section-private)
const smartMedKotorLink = computed(() => getClinicLink('smartmed-kotor'));
const hipokratRadanoviciLink = computed(() =>
	getClinicLink('hipokrat-poliklinika-radanovici'),
);
const interCardioKotorLink = computed(() =>
	getClinicLink('inter-cardio-kotor'),
);
const dentalStudioVuceticLink = computed(() =>
	getClinicLink('dental-studio-vucetic'),
);
const drCetkovicLink = computed(() =>
	getClinicLink('dr-cetkovic-stomatoloska-ordinacija'),
);
const orthoCentarKotorLink = computed(() => getClinicLink('ortho-centar'));
const endorfinRadanoviciLink = computed(() =>
	getClinicLink('endorfin-fizio-centar-radanovici'),
);

// Более-менее полный список частных клиник Бара (раздел section-private)
const novoStandardBarLink = computed(() =>
	getClinicLink('novi-standard-poliklinika'),
);
const drZejnilovicLink = computed(() =>
	getClinicLink('dr-zejnilovic-pzu-dnevna-bolnica-bar'),
);
const medicalVranesLink = computed(() => getClinicLink('medical-vranes-bar'));
const a3MedicalSutomoreLink = computed(() =>
	getClinicLink('a3-medical-sutomore'),
);
const justDentalBarLink = computed(() =>
	getClinicLink('just-dental-clinic-bar'),
);
const pavlinDentalBarLink = computed(() =>
	getClinicLink('pavlin-dental-clinic-bar'),
);
const drDebeljaBarLink = computed(() =>
	getClinicLink('dental-esthetic-studio-dr-debelja'),
);

// Остальные стоматологии Бара (Бар богат ими, отдельная группа от русскоговорящих)
const bunticDentalLink = computed(() =>
	getClinicLink('buntic-stomatoloska-ordinacija-bar'),
);
const drSimonovicDentalLink = computed(() =>
	getClinicLink('dr-simonovic-stomatoloska-ordinacija-bar'),
);
const drBajagicDentalLink = computed(() =>
	getClinicLink('dental-clinic-dr-bajagic-bar'),
);
const drZejakDentalLink = computed(() =>
	getClinicLink('dental-studio-dr-zejak-bar'),
);
const gacinaDentalLink = computed(() => getClinicLink('dental-studio-gacina'));
const jovoticDentLink = computed(() => getClinicLink('jovetic-dent-bar'));
const cicmilDentalLink = computed(() =>
	getClinicLink('stomatologija-cicmil-bar'),
);

// Кластер частных госпиталей/поликлиник Подгорицы с реальной хирургией/МРТ (section-private)
const konzilijumPgLink = computed(() =>
	getClinicLink('konzilijum-poliklinika-i-bolnica-podgorica'),
);
const arsMedicaPgLink = computed(() =>
	getClinicLink('ars-medica-specijalna-bolnica'),
);
const medtimPgLink = computed(() => getClinicLink('medtim-privatna-bolnica'));
const aMedicPgLink = computed(() =>
	getClinicLink('a-medic-plasticna-i-estetska-hirurgija'),
);
const codraHospitalPgLink = computed(() =>
	getClinicLink('codra-hospital-podgorica'),
);
const hipokratPgLink = computed(() =>
	getClinicLink('hipokrat-poliklinika-podgorica'),
);
const mojLabPg1Link = computed(() => getClinicLink('moj-lab-podgorica-1'));
const milmedikaPgLink = computed(() => getClinicLink('milmedika-podgorica'));
const filipovicPgLink = computed(() =>
	getClinicLink('poliklinika-filipovic-podgorica'),
);

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
			<p v-if="city === 'budva'"
				>{{ t('CityHcEmergency2a_budva') }}<NuxtLink :to="kotorHospitalLink">{{
					t('CityHcEmergency2KotorLink_budva')
				}}</NuxtLink
				>{{ t('CityHcEmergency2b_budva') }}<NuxtLink :to="kccgLink">{{
					t('CityHcEmergency2KccgLink_budva')
				}}</NuxtLink
				>{{ t('CityHcEmergency2c_budva') }}</p
			>
			<p v-else>{{ t(`CityHcEmergency2_${city}`) }}</p>
			<p>{{ t('CityHcEmergencyShared') }}</p>
		</ArticleSection>

		<ArticleSection id="section-state" :title="t('CityHcToc_state')">
			<p>{{ t(`CityHcState1_${city}`) }}</p>
			<p>{{ t(`CityHcState2_${city}`) }}</p>
			<p v-if="city === 'kotor'"
				>{{ t('CityHcState3a_kotor') }}<NuxtLink :to="vasoCukovicRisanLink">{{
					t('CityHcState3VasoLink_kotor')
				}}</NuxtLink
				>{{ t('CityHcState3b_kotor') }}<NuxtLink :to="dobrotaPsychiatricLink">{{
					t('CityHcState3DobrotaLink_kotor')
				}}</NuxtLink
				>{{ t('CityHcState3c_kotor') }}</p
			>
			<p v-else>{{ t(`CityHcState3_${city}`) }}</p>
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
			<ul v-if="city === 'budva'">
				<li
					>{{ t('CityHcPvGroupLabel_Polyclinic') }}:
					<NuxtLink :to="milmedikaBudvaLink">{{
						t('CityHcPvMilmedika')
					}}</NuxtLink
					>, <NuxtLink :to="mojLabBudvaLink">{{
						t('CityHcPvMojLab')
					}}</NuxtLink
					>, <NuxtLink :to="bonoMedicaLink">{{
						t('CityHcPvBonoMedica')
					}}</NuxtLink
					>, <NuxtLink :to="medicalCentarBudvaLink">{{
						t('CityHcPvMedicalCentar')
					}}</NuxtLink
					>.</li
				>
				<li
					>{{ t('CityHcPvGroupLabel_Dental') }}:
					<NuxtLink :to="dukleyDentalLink">{{
						t('CityHcPvDukley')
					}}</NuxtLink
					>, <NuxtLink :to="reDentLink">{{ t('CityHcPvReDent') }}</NuxtLink
					>, <NuxtLink :to="zecevicDentalLink">{{
						t('CityHcPvZecevic')
					}}</NuxtLink
					>.</li
				>
				<li
					>{{ t('CityHcPvGroupLabel_Ophthalmology') }}:
					<NuxtLink :to="laserFocusLink">{{
						t('CityHcPvLaserFocus')
					}}</NuxtLink
					>, <NuxtLink :to="svjetlostEyeLink">{{
						t('CityHcPvSvjetlost')
					}}</NuxtLink
					>.</li
				>
				<li
					>{{ t('CityHcPvGroupLabel_Gynecology') }}:
					<NuxtLink :to="humanaReprodukcijaLink">{{
						t('CityHcPvHumana')
					}}</NuxtLink
					>.</li
				>
			</ul>
			<ul v-else-if="city === 'kotor'">
				<li
					>{{ t('CityHcPvGroupLabel_Polyclinic') }}:
					<NuxtLink :to="smartMedKotorLink">{{
						t('CityHcPvSmartMed')
					}}</NuxtLink
					>, <NuxtLink :to="hipokratRadanoviciLink">{{
						t('CityHcPvHipokratRadanovici')
					}}</NuxtLink
					>.</li
				>
				<li
					>{{ t('CityHcPvGroupLabel_Cardiology') }}:
					<NuxtLink :to="interCardioKotorLink">{{
						t('CityHcPvInterCardio')
					}}</NuxtLink
					>.</li
				>
				<li
					>{{ t('CityHcPvGroupLabel_Dental') }}:
					<NuxtLink :to="dentalStudioVuceticLink">{{
						t('CityHcPvDentalStudioVucetic')
					}}</NuxtLink
					>, <NuxtLink :to="drCetkovicLink">{{
						t('CityHcPvDrCetkovic')
					}}</NuxtLink
					>, <NuxtLink :to="orthoCentarKotorLink">{{
						t('CityHcPvOrthoCentarKotor')
					}}</NuxtLink
					>.</li
				>
				<li
					>{{ t('CityHcPvGroupLabel_Physiotherapy') }}:
					<NuxtLink :to="endorfinRadanoviciLink">{{
						t('CityHcPvEndorfinRadanovici')
					}}</NuxtLink
					>.</li
				>
			</ul>
			<ul v-else-if="city === 'bar'">
				<li
					>{{ t('CityHcPvGroupLabel_PolyclinicHospital') }}:
					<NuxtLink :to="novoStandardBarLink">{{
						t('CityHcPvNoviStandardBar')
					}}</NuxtLink
					>, <NuxtLink :to="drZejnilovicLink">{{
						t('CityHcPvDrZejnilovic')
					}}</NuxtLink
					>, <NuxtLink :to="medicalVranesLink">{{
						t('CityHcPvMedicalVranes')
					}}</NuxtLink
					>, <NuxtLink :to="a3MedicalSutomoreLink">{{
						t('CityHcPvA3Medical')
					}}</NuxtLink
					>.</li
				>
				<li
					>{{ t('CityHcPvGroupLabel_RussianDental') }}:
					<NuxtLink :to="justDentalBarLink">{{
						t('CityHcPvJustDental')
					}}</NuxtLink
					>, <NuxtLink :to="pavlinDentalBarLink">{{
						t('CityHcPvPavlinDental')
					}}</NuxtLink
					>, <NuxtLink :to="drDebeljaBarLink">{{
						t('CityHcPvDrDebelja')
					}}</NuxtLink
					>.</li
				>
				<li
					>{{ t('CityHcPvGroupLabel_OtherDental') }}:
					<NuxtLink :to="bunticDentalLink">{{
						t('CityHcPvBuntic')
					}}</NuxtLink
					>, <NuxtLink :to="drSimonovicDentalLink">{{
						t('CityHcPvDrSimonovic')
					}}</NuxtLink
					>, <NuxtLink :to="drBajagicDentalLink">{{
						t('CityHcPvDrBajagic')
					}}</NuxtLink
					>, <NuxtLink :to="drZejakDentalLink">{{
						t('CityHcPvDrZejak')
					}}</NuxtLink
					>, <NuxtLink :to="gacinaDentalLink">{{
						t('CityHcPvGacina')
					}}</NuxtLink
					>, <NuxtLink :to="jovoticDentLink">{{
						t('CityHcPvJovoticDent')
					}}</NuxtLink
					>, <NuxtLink :to="cicmilDentalLink">{{
						t('CityHcPvCicmil')
					}}</NuxtLink
					>.</li
				>
			</ul>
			<ul v-else-if="city === 'podgorica'">
				<li
					>{{ t('CityHcPvGroupLabel_SurgicalHospital') }}:
					<NuxtLink :to="konzilijumPgLink">{{
						t('CityHcPvKonzilijum')
					}}</NuxtLink
					>, <NuxtLink :to="arsMedicaPgLink">{{
						t('CityHcPvArsMedica')
					}}</NuxtLink
					>, <NuxtLink :to="medtimPgLink">{{ t('CityHcPvMedtim') }}</NuxtLink
					>, <NuxtLink :to="codraHospitalPgLink">{{
						t('CityHcPvCodraHospital')
					}}</NuxtLink
					>.</li
				>
				<li
					>{{ t('CityHcPvGroupLabel_AestheticSurgery') }}:
					<NuxtLink :to="aMedicPgLink">{{ t('CityHcPvAMedic') }}</NuxtLink
					>.</li
				>
				<li
					>{{ t('CityHcPvGroupLabel_Polyclinic') }}:
					<NuxtLink :to="hipokratPgLink">{{
						t('CityHcPvHipokratPg')
					}}</NuxtLink
					>, <NuxtLink :to="mojLabPg1Link">{{
						t('CityHcPvMojLabPg')
					}}</NuxtLink
					>, <NuxtLink :to="milmedikaPgLink">{{
						t('CityHcPvMilmedikaPg')
					}}</NuxtLink
					>, <NuxtLink :to="filipovicPgLink">{{
						t('CityHcPvFilipovicPg')
					}}</NuxtLink
					>.</li
				>
			</ul>
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
