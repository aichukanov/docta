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
				>{{ t('CityHcEmergency2a_budva')
				}}<ClinicRouteLink :to="kotorHospitalLink">{{
					t('CityHcEmergency2KotorLink_budva')
				}}</ClinicRouteLink
				>{{ t('CityHcEmergency2b_budva')
				}}<ClinicRouteLink :to="kccgLink">{{
					t('CityHcEmergency2KccgLink_budva')
				}}</ClinicRouteLink
				>{{ t('CityHcEmergency2c_budva') }}</p
			>
			<p v-else>{{ t(`CityHcEmergency2_${city}`) }}</p>
			<p>{{ t('CityHcEmergencyShared') }}</p>
		</ArticleSection>

		<ArticleSection id="section-state" :title="t('CityHcToc_state')">
			<p>{{ t(`CityHcState1_${city}`) }}</p>
			<p>{{ t(`CityHcState2_${city}`) }}</p>
			<p v-if="city === 'kotor'"
				>{{ t('CityHcState3a_kotor')
				}}<ClinicRouteLink :to="vasoCukovicRisanLink">{{
					t('CityHcState3VasoLink_kotor')
				}}</ClinicRouteLink
				>{{ t('CityHcState3b_kotor')
				}}<ClinicRouteLink :to="dobrotaPsychiatricLink">{{
					t('CityHcState3DobrotaLink_kotor')
				}}</ClinicRouteLink
				>{{ t('CityHcState3c_kotor') }}</p
			>
			<p v-else>{{ t(`CityHcState3_${city}`) }}</p>
			<p>
				{{ t(`CityHcStateCatalog_${city}`) }}
				<ClinicRouteLink :to="stateClinicLink">{{
					t(`CityHcStateLink_${city}`)
				}}</ClinicRouteLink
				>{{ t('CityHcLinkEnd') }}
			</p>
		</ArticleSection>

		<ArticleSection id="section-private" :title="t('CityHcToc_private')">
			<p>{{ t(`CityHcPrivate1_${city}`) }}</p>
			<ul v-if="city === 'budva'">
				<li
					>{{ t('CityHcPvGroupLabel_Polyclinic') }}:
					<ClinicRouteLink :to="milmedikaBudvaLink">{{
						t('CityHcPvMilmedika')
					}}</ClinicRouteLink
					>,
					<ClinicRouteLink :to="mojLabBudvaLink">{{
						t('CityHcPvMojLab')
					}}</ClinicRouteLink
					>,
					<ClinicRouteLink :to="bonoMedicaLink">{{
						t('CityHcPvBonoMedica')
					}}</ClinicRouteLink
					>,
					<ClinicRouteLink :to="medicalCentarBudvaLink">{{
						t('CityHcPvMedicalCentar')
					}}</ClinicRouteLink
					>.</li
				>
				<li
					>{{ t('CityHcPvGroupLabel_Dental') }}:
					<ClinicRouteLink :to="dukleyDentalLink">{{
						t('CityHcPvDukley')
					}}</ClinicRouteLink
					>,
					<ClinicRouteLink :to="reDentLink">{{
						t('CityHcPvReDent')
					}}</ClinicRouteLink
					>,
					<ClinicRouteLink :to="zecevicDentalLink">{{
						t('CityHcPvZecevic')
					}}</ClinicRouteLink
					>.</li
				>
				<li
					>{{ t('CityHcPvGroupLabel_Ophthalmology') }}:
					<ClinicRouteLink :to="laserFocusLink">{{
						t('CityHcPvLaserFocus')
					}}</ClinicRouteLink
					>,
					<ClinicRouteLink :to="svjetlostEyeLink">{{
						t('CityHcPvSvjetlost')
					}}</ClinicRouteLink
					>.</li
				>
				<li
					>{{ t('CityHcPvGroupLabel_Gynecology') }}:
					<ClinicRouteLink :to="humanaReprodukcijaLink">{{
						t('CityHcPvHumana')
					}}</ClinicRouteLink
					>.</li
				>
			</ul>
			<ul v-else-if="city === 'kotor'">
				<li
					>{{ t('CityHcPvGroupLabel_Polyclinic') }}:
					<ClinicRouteLink :to="smartMedKotorLink">{{
						t('CityHcPvSmartMed')
					}}</ClinicRouteLink
					>,
					<ClinicRouteLink :to="hipokratRadanoviciLink">{{
						t('CityHcPvHipokratRadanovici')
					}}</ClinicRouteLink
					>.</li
				>
				<li
					>{{ t('CityHcPvGroupLabel_Cardiology') }}:
					<ClinicRouteLink :to="interCardioKotorLink">{{
						t('CityHcPvInterCardio')
					}}</ClinicRouteLink
					>.</li
				>
				<li
					>{{ t('CityHcPvGroupLabel_Dental') }}:
					<ClinicRouteLink :to="dentalStudioVuceticLink">{{
						t('CityHcPvDentalStudioVucetic')
					}}</ClinicRouteLink
					>,
					<ClinicRouteLink :to="drCetkovicLink">{{
						t('CityHcPvDrCetkovic')
					}}</ClinicRouteLink
					>,
					<ClinicRouteLink :to="orthoCentarKotorLink">{{
						t('CityHcPvOrthoCentarKotor')
					}}</ClinicRouteLink
					>.</li
				>
				<li
					>{{ t('CityHcPvGroupLabel_Physiotherapy') }}:
					<ClinicRouteLink :to="endorfinRadanoviciLink">{{
						t('CityHcPvEndorfinRadanovici')
					}}</ClinicRouteLink
					>.</li
				>
			</ul>
			<ul v-else-if="city === 'bar'">
				<li
					>{{ t('CityHcPvGroupLabel_PolyclinicHospital') }}:
					<ClinicRouteLink :to="novoStandardBarLink">{{
						t('CityHcPvNoviStandardBar')
					}}</ClinicRouteLink
					>,
					<ClinicRouteLink :to="drZejnilovicLink">{{
						t('CityHcPvDrZejnilovic')
					}}</ClinicRouteLink
					>,
					<ClinicRouteLink :to="medicalVranesLink">{{
						t('CityHcPvMedicalVranes')
					}}</ClinicRouteLink
					>,
					<ClinicRouteLink :to="a3MedicalSutomoreLink">{{
						t('CityHcPvA3Medical')
					}}</ClinicRouteLink
					>.</li
				>
				<li
					>{{ t('CityHcPvGroupLabel_RussianDental') }}:
					<ClinicRouteLink :to="justDentalBarLink">{{
						t('CityHcPvJustDental')
					}}</ClinicRouteLink
					>,
					<ClinicRouteLink :to="pavlinDentalBarLink">{{
						t('CityHcPvPavlinDental')
					}}</ClinicRouteLink
					>,
					<ClinicRouteLink :to="drDebeljaBarLink">{{
						t('CityHcPvDrDebelja')
					}}</ClinicRouteLink
					>.</li
				>
				<li
					>{{ t('CityHcPvGroupLabel_OtherDental') }}:
					<ClinicRouteLink :to="bunticDentalLink">{{
						t('CityHcPvBuntic')
					}}</ClinicRouteLink
					>,
					<ClinicRouteLink :to="drSimonovicDentalLink">{{
						t('CityHcPvDrSimonovic')
					}}</ClinicRouteLink
					>,
					<ClinicRouteLink :to="drBajagicDentalLink">{{
						t('CityHcPvDrBajagic')
					}}</ClinicRouteLink
					>,
					<ClinicRouteLink :to="drZejakDentalLink">{{
						t('CityHcPvDrZejak')
					}}</ClinicRouteLink
					>,
					<ClinicRouteLink :to="gacinaDentalLink">{{
						t('CityHcPvGacina')
					}}</ClinicRouteLink
					>,
					<ClinicRouteLink :to="jovoticDentLink">{{
						t('CityHcPvJovoticDent')
					}}</ClinicRouteLink
					>,
					<ClinicRouteLink :to="cicmilDentalLink">{{
						t('CityHcPvCicmil')
					}}</ClinicRouteLink
					>.</li
				>
			</ul>
			<ul v-else-if="city === 'podgorica'">
				<li
					>{{ t('CityHcPvGroupLabel_SurgicalHospital') }}:
					<ClinicRouteLink :to="konzilijumPgLink">{{
						t('CityHcPvKonzilijum')
					}}</ClinicRouteLink
					>,
					<ClinicRouteLink :to="arsMedicaPgLink">{{
						t('CityHcPvArsMedica')
					}}</ClinicRouteLink
					>,
					<ClinicRouteLink :to="medtimPgLink">{{
						t('CityHcPvMedtim')
					}}</ClinicRouteLink
					>,
					<ClinicRouteLink :to="codraHospitalPgLink">{{
						t('CityHcPvCodraHospital')
					}}</ClinicRouteLink
					>.</li
				>
				<li
					>{{ t('CityHcPvGroupLabel_AestheticSurgery') }}:
					<ClinicRouteLink :to="aMedicPgLink">{{
						t('CityHcPvAMedic')
					}}</ClinicRouteLink
					>.</li
				>
				<li
					>{{ t('CityHcPvGroupLabel_Polyclinic') }}:
					<ClinicRouteLink :to="hipokratPgLink">{{
						t('CityHcPvHipokratPg')
					}}</ClinicRouteLink
					>,
					<ClinicRouteLink :to="mojLabPg1Link">{{
						t('CityHcPvMojLabPg')
					}}</ClinicRouteLink
					>,
					<ClinicRouteLink :to="milmedikaPgLink">{{
						t('CityHcPvMilmedikaPg')
					}}</ClinicRouteLink
					>,
					<ClinicRouteLink :to="filipovicPgLink">{{
						t('CityHcPvFilipovicPg')
					}}</ClinicRouteLink
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
