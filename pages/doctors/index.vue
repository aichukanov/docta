<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import {
	buildDoctorListSchema,
	buildBreadcrumbsSchema,
} from '~/common/schema-org-builders';
import { CityId, CITY_COORDINATES } from '~/enums/cities';
import { SITE_URL } from '~/common/constants';
import { combineI18nMessages } from '~/i18n/utils';
import type { ClinicData } from '~/interfaces/clinic';

import breadcrumbI18n from '~/i18n/breadcrumb';
import cityI18n from '~/i18n/city';
import doctorI18n from '~/i18n/doctor';
import languageI18n from '~/i18n/language';
import specialtyI18n from '~/i18n/specialty';

// Clinic IDs
const CLINIC_DOM_ZDRAVLJA_BUDVA = 43;
const CLINIC_CLINICAL_CENTER_PODGORICA = 65;

const tipsI18n = {
	messages: {
		en: {
			TipBudva1: 'Budva does not have its own hospital, only',
			TipDomZdravlja: 'Dom Zdravlya (polyclinic)',
			TipBudva2: 'The nearest hospitals are in',
			TipBar: 'Bar',
			TipCetinje: 'Cetinje',
			TipKotor: 'Kotor',
			TipTivat: 'Tivat does not have its own hospital. The nearest are in',
			TipRisan: 'Risan',
			TipUlcinj: 'Ulcinj does not have its own hospital. The nearest is in',
			TipBarCity:
				'Bar has a Hospital with adult and pediatric departments and Dom Zdravlya (polyclinic).',
			TipEmergency: 'In case of emergency, call ambulance at 📞 124.',
			TipClinicalCenter1: 'The largest and most modern medical center is',
			TipClinicalCenter2: 'Clinical Center of Montenegro in Podgorica',
			TipClinicalCenter3: '(261 doctors!).',
			And: 'and',
		},
		ru: {
			TipBudva1: 'В Будве нет своей больницы, только',
			TipDomZdravlja: 'Дом Здравля (поликлиника)',
			TipBudva2: 'Ближайшие больницы находятся в',
			TipBar: 'Баре',
			TipCetinje: 'Цетине',
			TipKotor: 'Которе',
			TipTivat: 'В Тивате нет своей больницы. Ближайшие находятся в',
			TipRisan: 'Рисане',
			TipUlcinj: 'В Ульцине нет своей больницы. Ближайшая находится в',
			TipBarCity:
				'В Баре есть Больница со взрослым и детским отделениями и Дом Здравля (поликлиника).',
			TipEmergency:
				'В случае экстренной ситуации скорую помощь можно вызвать по номеру 📞 124.',
			TipClinicalCenter1: 'Самый большой и современный медицинский центр —',
			TipClinicalCenter2: 'Клинический центр Черногории в Подгорице',
			TipClinicalCenter3: '(261 врач!).',
			And: 'и',
		},
		sr: {
			TipBudva1: 'Budva nema svoju bolnicu, samo',
			TipDomZdravlja: 'Dom Zdravlja (poliklinika)',
			TipBudva2: 'Najbliže bolnice su u',
			TipBar: 'Baru',
			TipCetinje: 'Cetinju',
			TipKotor: 'Kotoru',
			TipTivat: 'Tivat nema svoju bolnicu. Najbliže su u',
			TipRisan: 'Risnu',
			TipUlcinj: 'Ulcinj nema svoju bolnicu. Najbliža je u',
			TipBarCity:
				'Bar ima Bolnicu sa odeljenjima za odrasle i decu i Dom Zdravlja (poliklinika).',
			TipEmergency: 'U slučaju hitnosti, pozovite hitnu pomoć na 📞 124.',
			TipClinicalCenter1: 'Najveći i najsavremeniji medicinski centar je',
			TipClinicalCenter2: 'Klinički centar Crne Gore u Podgorici',
			TipClinicalCenter3: '(261 lekar!).',
			And: 'i',
		},
		de: {
			TipBudva1: 'Budva hat kein eigenes Krankenhaus, nur',
			TipDomZdravlja: 'Dom Zdravlja (Poliklinik)',
			TipBudva2: 'Die nächsten Krankenhäuser sind in',
			TipBar: 'Bar',
			TipCetinje: 'Cetinje',
			TipKotor: 'Kotor',
			TipTivat: 'Tivat hat kein eigenes Krankenhaus. Die nächsten sind in',
			TipRisan: 'Risan',
			TipUlcinj: 'Ulcinj hat kein eigenes Krankenhaus. Das nächste ist in',
			TipBarCity:
				'Bar hat ein Krankenhaus mit Erwachsenen- und Kinderabteilungen und Dom Zdravlja (Poliklinik).',
			TipEmergency: 'Im Notfall rufen Sie den Krankenwagen unter 📞 124.',
			TipClinicalCenter1:
				'Das größte und modernste medizinische Zentrum ist das',
			TipClinicalCenter2: 'Klinische Zentrum Montenegros in Podgorica',
			TipClinicalCenter3: '(261 Ärzte!).',
			And: 'und',
		},
		tr: {
			TipBudva1: "Budva'nın kendi hastanesi yok, sadece",
			TipDomZdravlja: 'Dom Zdravlja (poliklinik)',
			TipBudva2: 'En yakın hastaneler',
			TipBar: 'Bar',
			TipCetinje: 'Cetinje',
			TipKotor: 'Kotor',
			TipTivat: "Tivat'ın kendi hastanesi yok. En yakınları",
			TipRisan: 'Risan',
			TipUlcinj: "Ulcinj'in kendi hastanesi yok. En yakını",
			TipBarCity:
				"Bar'da yetişkin ve çocuk bölümlerinden oluşan bir Hastane ve Dom Zdravlja (poliklinik) var.",
			TipEmergency: 'Acil durumda 📞 124 numaralı telefonu arayın.',
			TipClinicalCenter1: 'En büyük ve en modern tıp merkezi',
			TipClinicalCenter2: "Podgorica'daki Karadağ Klinik Merkezi",
			TipClinicalCenter3: '(261 doktor!).',
			And: 've',
		},
	},
};

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		breadcrumbI18n,
		doctorI18n,
		specialtyI18n,
		cityI18n,
		languageI18n,
		tipsI18n,
	]),
});

const {
	specialtyIds,
	cityIds,
	languageIds,
	clinicIds,
	name,
	updateFromRoute,
	getRouteParams,
} = useFilters();

updateFromRoute(useRoute().query);

const filterList = computed(() => ({
	specialtyIds: specialtyIds.value,
	cityIds: cityIds.value,
	languageIds: languageIds.value,
	clinicIds: clinicIds.value,
	name: name.value,
}));

const filterQuery = computed(() => getRouteParams().query);

const clinicsStore = useClinicsStore();
await clinicsStore.fetchClinics();

const clinicName = computed(() => {
	if (clinicIds.value.length === 1) {
		const clinic = clinicsStore.clinics.find(
			(c) => c.id === clinicIds.value[0],
		);
		return clinic?.name || '';
	}
	return '';
});

const { pending: isLoadingDoctors, data: doctorsList } = await useFetch(
	'/api/doctors/list',
	{
		key: 'doctors-list',
		method: 'POST',
		body: filterList,
	},
);

const pageTitle = computed(() => {
	if (languageIds.value.length === 1) {
		if (specialtyIds.value.length === 1) {
			if (cityIds.value.length === 1) {
				if (clinicIds.value.length === 1) {
					return t('DoctorsLanguageSpecialtyCityClinic', {
						language: t(`language_${languageIds.value[0]}_genitive`),
						specialtyDoctors: t(`doctors_${specialtyIds.value[0]}`),
						city: t(`city_${cityIds.value[0]}_genitive`),
						clinic: clinicName.value,
					});
				}
				return t('DoctorsLanguageSpecialtyCity', {
					language: t(`language_${languageIds.value[0]}_genitive`),
					specialtyDoctors: t(`doctors_${specialtyIds.value[0]}`),
					city: t(`city_${cityIds.value[0]}_genitive`),
				});
			} else {
				if (clinicIds.value.length === 1) {
					return t('DoctorsLanguageSpecialtyClinic', {
						language: t(`language_${languageIds.value[0]}_genitive`),
						specialtyDoctors: t(`doctors_${specialtyIds.value[0]}`),
						clinic: clinicName.value,
					});
				}
				return t('DoctorsLanguageSpecialty', {
					language: t(`language_${languageIds.value[0]}_genitive`),
					specialtyDoctors: t(`doctors_${specialtyIds.value[0]}`),
				});
			}
		} else {
			if (cityIds.value.length === 1) {
				if (clinicIds.value.length === 1) {
					return t('DoctorsLanguageCityClinic', {
						language: t(`language_${languageIds.value[0]}_genitive`),
						city: t(`city_${cityIds.value[0]}_genitive`),
						clinic: clinicName.value,
					});
				}
				return t('DoctorsLanguageCity', {
					language: t(`language_${languageIds.value[0]}_genitive`),
					city: t(`city_${cityIds.value[0]}_genitive`),
				});
			} else {
				if (clinicIds.value.length === 1) {
					return t('DoctorsLanguageClinic', {
						language: t(`language_${languageIds.value[0]}_genitive`),
						clinic: clinicName.value,
					});
				}
				return t('DoctorsLanguage', {
					language: t(`language_${languageIds.value[0]}_genitive`),
				});
			}
		}
	} else {
		if (specialtyIds.value.length === 1) {
			if (cityIds.value.length === 1) {
				if (clinicIds.value.length === 1) {
					return t('DoctorsSpecialtyCityClinic', {
						specialtyDoctors: t(`doctors_${specialtyIds.value[0]}`),
						city: t(`city_${cityIds.value[0]}_genitive`),
						clinic: clinicName.value,
					});
				}
				return t('DoctorsSpecialtyCity', {
					specialtyDoctors: t(`doctors_${specialtyIds.value[0]}`),
					city: t(`city_${cityIds.value[0]}_genitive`),
				});
			}

			if (clinicIds.value.length === 1) {
				return t('DoctorsSpecialtyClinic', {
					specialtyDoctors: t(`doctors_${specialtyIds.value[0]}`),
					clinic: clinicName.value,
				});
			}
			return t('DoctorsSpecialty', {
				specialtyDoctors: t(`doctors_${specialtyIds.value[0]}`),
			});
		} else {
			if (cityIds.value.length === 1) {
				if (clinicIds.value.length === 1) {
					return t('DoctorsCityClinic', {
						city: t(`city_${cityIds.value[0]}_genitive`),
						clinic: clinicName.value,
					});
				}
				return t('DoctorsCity', {
					city: t(`city_${cityIds.value[0]}_genitive`),
				});
			}
		}
	}

	if (clinicIds.value.length === 1) {
		return t('DoctorsClinic', {
			clinic: clinicName.value,
		});
	}

	return t('Doctors');
});

const pageTitleWithCount = computed(() => {
	return `${pageTitle.value} (${doctorsList.value?.totalCount})`;
});

const pageDescription = computed(() => {
	const count = doctorsList.value?.totalCount || 0;
	const hasFilters =
		specialtyIds.value.length > 0 ||
		cityIds.value.length > 0 ||
		languageIds.value.length > 0 ||
		clinicIds.value.length > 0;

	if (hasFilters) {
		return t('DoctorsListDescriptionFiltered', {
			count,
			title: pageTitle.value,
		});
	}
	return t('DoctorsListDescription');
});

// Schema.org for doctors list
const schemaOrgStore = useSchemaOrgStore();
const route = useRoute();

const ogImage = `${SITE_URL}/logo-site.png`;

useSeoMeta({
	title: pageTitleWithCount,
	description: pageDescription,
	ogTitle: pageTitleWithCount,
	ogDescription: pageDescription,
	ogImage: ogImage,
	twitterCard: 'summary',
	twitterTitle: pageTitleWithCount,
	twitterDescription: pageDescription,
	twitterImage: ogImage,
});
const isFiltered = computed(() => {
	return (
		specialtyIds.value.length > 0 ||
		cityIds.value.length > 0 ||
		languageIds.value.length > 0 ||
		clinicIds.value.length > 0 ||
		!!name.value
	);
});
watchEffect(() => {
	if (doctorsList.value) {
		const pageUrl = `${SITE_URL}${route.fullPath}`;
		schemaOrgStore.setSchemas([
			...buildDoctorListSchema({
				siteUrl: SITE_URL,
				pageUrl,
				locale: locale.value,
				title: pageTitle.value,
				description: pageDescription.value,
				totalCount: doctorsList.value.totalCount,
				doctors: doctorsList.value.doctors,
				isFiltered: isFiltered.value,
				getSpecialtyName: (id) => t(`specialty_${id}`),
			}),
			buildBreadcrumbsSchema(pageUrl, [
				{ name: t('BreadcrumbHome'), url: `${SITE_URL}/` },
				{ name: t('BreadcrumbDoctors') },
			]),
		]);
	}
});

// Clinic links for tips
const clinicLink = (clinicId: number) => ({
	name: 'clinics-clinicId',
	params: { clinicId: String(clinicId) },
	query: getRegionalQuery(locale.value),
});

const cityClinicLink = (cityId: number) => ({
	name: 'clinics',
	query: { ...getRegionalQuery(locale.value), cityIds: String(cityId) },
});

const domZdravljaBudvaLink = computed(() =>
	clinicLink(CLINIC_DOM_ZDRAVLJA_BUDVA),
);
const clinicalCenterLink = computed(() =>
	clinicLink(CLINIC_CLINICAL_CENTER_PODGORICA),
);
const barClinicsLink = computed(() => cityClinicLink(CityId.BAR));
const kotorClinicsLink = computed(() => cityClinicLink(CityId.KOTOR));

// Determine which city tips to show
const selectedCityId = computed(() => {
	if (cityIds.value.length === 1) {
		return cityIds.value[0];
	}
	return null;
});
</script>

<template>
	<ListPage
		:pageTitle="pageTitleWithCount"
		:pageDescription="pageDescription"
		:list="doctorsList.doctors"
		:totalCount="doctorsList.totalCount"
		:isLoading="isLoadingDoctors"
		:filterQuery="filterQuery"
		:cityIds="cityIds"
	>
		<template #filters>
			<FilterName
				:label="t('DoctorName')"
				:placeholder="t('InsertDoctorName')"
			/>
			<FilterCitySelect v-model:value="cityIds" />
			<FilterLanguageSelect v-model:value="languageIds" />
			<FilterSpecialtySelect v-model:value="specialtyIds" />
			<FilterClinicSelect v-model:value="clinicIds" />
		</template>

		<template #item="{ item }">
			<DoctorInfo :service="item" />
		</template>

		<template #map-clinic-popup="{ service }">
			<DoctorInfo :service="service" short />
		</template>

		<template #tips>
			<!-- General tips (always shown) -->
			<TipsItem type="emergency" :text="t('TipEmergency')" />

			<!-- City-specific tips -->
			<TipsItem v-if="selectedCityId === CityId.BUDVA">
				{{ t('TipBudva1') }}
				<NuxtLink :to="domZdravljaBudvaLink">{{ t('TipDomZdravlja') }}</NuxtLink
				>.
				{{ t('TipBudva2') }}
				<NuxtLink :to="barClinicsLink">{{ t('TipBar') }}</NuxtLink
				>,
				{{ t('TipCetinje') }}
				{{ t('And') }}
				<NuxtLink :to="kotorClinicsLink">{{ t('TipKotor') }}</NuxtLink
				>.
			</TipsItem>

			<TipsItem v-if="selectedCityId === CityId.TIVAT">
				{{ t('TipTivat') }}
				<NuxtLink :to="kotorClinicsLink">{{ t('TipKotor') }}</NuxtLink>
				{{ t('And') }}
				{{ t('TipRisan') }}.
			</TipsItem>

			<TipsItem v-if="selectedCityId === CityId.ULCINJ">
				{{ t('TipUlcinj') }}
				<NuxtLink :to="barClinicsLink">{{ t('TipBar') }}</NuxtLink
				>.
			</TipsItem>

			<TipsItem v-if="selectedCityId === CityId.BAR" :text="t('TipBarCity')" />

			<TipsItem>
				{{ t('TipClinicalCenter1') }}
				<NuxtLink :to="clinicalCenterLink">{{
					t('TipClinicalCenter2')
				}}</NuxtLink>
				{{ t('TipClinicalCenter3') }}
			</TipsItem>
		</template>
	</ListPage>
</template>
