<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import { ClinicType } from '~/enums/clinic-type';
import { DoctorSpecialty } from '~/enums/specialty';
import { MedicalServiceCategory } from '~/enums/medical-service-category';
import { LabTestCategory } from '~/enums/labtest-category';
import specialtyI18n from '~/i18n/specialty';
import clinicTypeI18n from '~/i18n/clinic-type';
import cityI18n from '~/i18n/city';
import languageI18n from '~/i18n/language';
import { combineI18nMessages } from '~/i18n/utils';

const props = defineProps<{
	clinicTypeIds: number[];
	languageIds?: number[];
	cityIds?: number[];
}>();

const localI18n = {
	messages: {
		'en': {
			TipDoctors: 'You can also look for a doctor —',
			TipDoctorsLink: '{specialty} specialists{location}',
			TipServices: 'Looking for a specific procedure? Check',
			TipServicesLink: '{specialty} services with prices{location}',
			TipLabTests: 'Need to get tested? See',
			TipLabTestsLink: 'lab tests and prices{location}',
			LocationDefault: ' in Montenegro',
			LocationCity: ' in {city}',
			LocationLanguage: ' ({language}-speaking)',
			LocationCityLanguage: ' in {city} ({language}-speaking)',
		},
		'ru': {
			TipDoctors: 'Вы также можете найти врача —',
			TipDoctorsLink: 'специалисты по направлению «{specialty}»{location}',
			TipServices: 'Ищете конкретную процедуру? Посмотрите',
			TipServicesLink: 'услуги по направлению «{specialty}» с ценами{location}',
			TipLabTests: 'Нужно сдать анализы? Посмотрите',
			TipLabTestsLink: 'лабораторные исследования и цены{location}',
			LocationDefault: ' в Черногории',
			LocationCity: ' в {city}',
			LocationLanguage: ' с сопровождением на {language} языке',
			LocationCityLanguage: ' в {city} с сопровождением на {language} языке',
		},
		'sr': {
			TipDoctors: 'Takođe možete pronaći lekara —',
			TipDoctorsLink: 'specijalisti iz oblasti „{specialty}"{location}',
			TipServices: 'Tražite određenu proceduru? Pogledajte',
			TipServicesLink: 'usluge iz oblasti „{specialty}" sa cenama{location}',
			TipLabTests: 'Treba vam laboratorijska analiza? Pogledajte',
			TipLabTestsLink: 'laboratorijske analize i cene{location}',
			LocationDefault: ' u Crnoj Gori',
			LocationCity: ' u {city}',
			LocationLanguage: ' sa pratnjom na {language} jeziku',
			LocationCityLanguage: ' u {city} sa pratnjom na {language} jeziku',
		},
		'sr-cyrl': {
			TipDoctors: 'Такође можете пронаћи лекара —',
			TipDoctorsLink: 'специјалисти из области „{specialty}"{location}',
			TipServices: 'Тражите одређену процедуру? Погледајте',
			TipServicesLink: 'услуге из области „{specialty}" са ценама{location}',
			TipLabTests: 'Треба вам лабораторијска анализа? Погледајте',
			TipLabTestsLink: 'лабораторијске анализе и цене{location}',
			LocationDefault: ' у Црној Гори',
			LocationCity: ' у {city}',
			LocationLanguage: ' са пратњом на {language} језику',
			LocationCityLanguage: ' у {city} са пратњом на {language} језику',
		},
		'de': {
			TipDoctors: 'Sie können auch einen Arzt suchen —',
			TipDoctorsLink: 'Fachärzte für {specialty}{location}',
			TipServices: 'Suchen Sie eine bestimmte Behandlung? Sehen Sie sich',
			TipServicesLink:
				'Leistungen im Bereich {specialty} mit Preisen{location}',
			TipLabTests: 'Brauchen Sie eine Laboruntersuchung? Sehen Sie',
			TipLabTestsLink: 'Laboruntersuchungen und Preise{location}',
			LocationDefault: ' in Montenegro',
			LocationCity: ' in {city}',
			LocationLanguage: ' ({language}-sprachig)',
			LocationCityLanguage: ' in {city} ({language}-sprachig)',
		},
		'tr': {
			TipDoctors: 'Ayrıca doktor da arayabilirsiniz —',
			TipDoctorsLink: '{specialty} uzmanları{location}',
			TipServices: 'Belirli bir işlem mi arıyorsunuz?',
			TipServicesLink: '{specialty} alanındaki fiyatlı hizmetler{location}',
			TipLabTests: 'Test yaptırmanız mı gerekiyor?',
			TipLabTestsLink: 'Laboratuvar testleri ve fiyatlar{location}',
			LocationDefault: " Karadağ'da",
			LocationCity: " {city}'de",
			LocationLanguage: ' ({language} konuşulan)',
			LocationCityLanguage: " {city}'de ({language} konuşulan)",
		},
	},
};

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		localI18n,
		specialtyI18n,
		clinicTypeI18n,
		cityI18n,
		languageI18n,
	]),
});

const locationSuffix = computed(() => {
	const hasCity = props.cityIds?.length === 1;
	const hasLang = props.languageIds?.length === 1;
	const city = hasCity ? t(`city_${props.cityIds![0]}_genitive`) : '';
	const language = hasLang
		? t(`language_${props.languageIds![0]}_genitive`)
		: '';

	if (hasCity && hasLang) {
		return t('LocationCityLanguage', { city, language });
	}
	if (hasCity) {
		return t('LocationCity', { city });
	}
	if (hasLang) {
		return t('LocationLanguage', { language });
	}
	return t('LocationDefault');
});

/**
 * Maps clinic type → medical service category for services page filter
 */
const CLINIC_TYPE_TO_SERVICE_CATEGORY: Partial<Record<ClinicType, number>> = {
	[ClinicType.DENTAL_CLINIC]: MedicalServiceCategory.DENTISTRY,
	[ClinicType.GYNECOLOGICAL_CLINIC]: MedicalServiceCategory.GYNECOLOGY,
	[ClinicType.UROLOGICAL_CLINIC]: MedicalServiceCategory.UROLOGY,
	[ClinicType.OPHTHALMOLOGY_CLINIC]: MedicalServiceCategory.OPHTHALMOLOGY,
	[ClinicType.CARDIOLOGY_CLINIC]: MedicalServiceCategory.CARDIOLOGY,
	[ClinicType.ENT_CLINIC]: MedicalServiceCategory.ENT,
	[ClinicType.ORTHOPEDIC_CLINIC]: MedicalServiceCategory.ORTHOPEDICS,
	[ClinicType.DERMATOLOGY_CLINIC]: MedicalServiceCategory.DERMATOLOGY,
	[ClinicType.PEDIATRIC_CLINIC]: MedicalServiceCategory.PEDIATRICS,
	[ClinicType.NEUROLOGY_CLINIC]: MedicalServiceCategory.NEUROLOGY,
	[ClinicType.GASTROENTEROLOGY_CLINIC]: MedicalServiceCategory.GASTROENTEROLOGY,
	[ClinicType.ENDOCRINOLOGY_CLINIC]: MedicalServiceCategory.ENDOCRINOLOGY,
	[ClinicType.PULMONOLOGY_CLINIC]: MedicalServiceCategory.PULMONOLOGY,
};

/**
 * Maps clinic type → lab test category for lab tests page filter
 */
const CLINIC_TYPE_TO_LAB_CATEGORY: Partial<Record<ClinicType, number>> = {
	[ClinicType.CARDIOLOGY_CLINIC]: LabTestCategory.CARDIAC_MARKERS,
	[ClinicType.GYNECOLOGICAL_CLINIC]: LabTestCategory.PREGNANCY_FERTILITY,
	[ClinicType.ENDOCRINOLOGY_CLINIC]: LabTestCategory.HORMONES,
};

/**
 * Maps clinic type → doctor specialty ID for doctors page filter
 */
const CLINIC_TYPE_TO_SPECIALTY: Partial<Record<ClinicType, number>> = {
	[ClinicType.DENTAL_CLINIC]: DoctorSpecialty.DENTISTRY,
	[ClinicType.GYNECOLOGICAL_CLINIC]: DoctorSpecialty.GYNECOLOGY_OBSTETRICS,
	[ClinicType.UROLOGICAL_CLINIC]: DoctorSpecialty.UROLOGY,
	[ClinicType.OPHTHALMOLOGY_CLINIC]: DoctorSpecialty.OPHTHALMOLOGY,
	[ClinicType.CARDIOLOGY_CLINIC]: DoctorSpecialty.CARDIOLOGY,
	[ClinicType.ENT_CLINIC]: DoctorSpecialty.OTORHINOLARYNGOLOGY,
	[ClinicType.ORTHOPEDIC_CLINIC]: DoctorSpecialty.ORTHOPEDICS_TRAUMATOLOGY,
	[ClinicType.DERMATOLOGY_CLINIC]: DoctorSpecialty.DERMATOVENEROLOGY,
	[ClinicType.PEDIATRIC_CLINIC]: DoctorSpecialty.PEDIATRICS,
	[ClinicType.NEUROLOGY_CLINIC]: DoctorSpecialty.NEUROLOGY,
	[ClinicType.GASTROENTEROLOGY_CLINIC]: DoctorSpecialty.GASTROENTEROLOGY,
	[ClinicType.ENDOCRINOLOGY_CLINIC]: DoctorSpecialty.ENDOCRINOLOGY,
	[ClinicType.PULMONOLOGY_CLINIC]: DoctorSpecialty.PULMONOLOGY,
	[ClinicType.PSYCHIATRIC_CLINIC]: DoctorSpecialty.PSYCHIATRY,
	[ClinicType.ONCOLOGY_CLINIC]: DoctorSpecialty.ONCOLOGY,
};

const selectedTypeId = computed(() => {
	if (props.clinicTypeIds.length === 1) {
		return props.clinicTypeIds[0] as ClinicType;
	}
	return null;
});

const relatedSpecialtyId = computed(() => {
	if (!selectedTypeId.value) return null;
	return CLINIC_TYPE_TO_SPECIALTY[selectedTypeId.value] || null;
});

const specialtyName = computed(() => {
	if (!relatedSpecialtyId.value) return '';
	return t(`specialty_${relatedSpecialtyId.value}`);
});

const sharedFilters = computed(() => {
	const filters: Record<string, string | string[]> = {};
	if (props.languageIds?.length) {
		filters.languageIds = props.languageIds.map(String);
	}
	if (props.cityIds?.length) {
		filters.cityIds = props.cityIds.map(String);
	}
	return filters;
});

const doctorsLink = computed(() => {
	if (!relatedSpecialtyId.value) return null;
	return {
		name: 'doctors',
		query: {
			...getRegionalQuery(locale.value),
			...sharedFilters.value,
			specialtyIds: String(relatedSpecialtyId.value),
		},
	};
});

const relatedServiceCategoryId = computed(() => {
	if (!selectedTypeId.value) return null;
	return CLINIC_TYPE_TO_SERVICE_CATEGORY[selectedTypeId.value] || null;
});

const relatedLabCategoryId = computed(() => {
	if (!selectedTypeId.value) return null;
	return CLINIC_TYPE_TO_LAB_CATEGORY[selectedTypeId.value] || null;
});

const servicesLink = computed(() => ({
	name: 'services',
	query: {
		...getRegionalQuery(locale.value),
		...sharedFilters.value,
		...(relatedServiceCategoryId.value
			? { serviceCategoryIds: String(relatedServiceCategoryId.value) }
			: {}),
	},
}));

const labTestsLink = computed(() => ({
	name: 'labtests',
	query: {
		...getRegionalQuery(locale.value),
		...sharedFilters.value,
		...(relatedLabCategoryId.value
			? { categoryIds: String(relatedLabCategoryId.value) }
			: {}),
	},
}));

const showDoctorsTip = computed(() => !!doctorsLink.value);
const showServicesTip = computed(() => !!relatedSpecialtyId.value);
const showLabTip = computed(
	() =>
		selectedTypeId.value === ClinicType.DIAGNOSTIC_LAB ||
		selectedTypeId.value === ClinicType.POLYCLINIC ||
		selectedTypeId.value === ClinicType.HOSPITAL,
);

const doctorsLinkText = computed(() =>
	t('TipDoctorsLink', {
		specialty: specialtyName.value,
		location: locationSuffix.value,
	}),
);
const servicesLinkText = computed(() =>
	t('TipServicesLink', {
		specialty: specialtyName.value,
		location: locationSuffix.value,
	}),
);
const labTestsLinkText = computed(() =>
	t('TipLabTestsLink', { location: locationSuffix.value }),
);
</script>

<template>
	<TipsItem v-if="showDoctorsTip">
		{{ t('TipDoctors') }}
		<NuxtLink :to="doctorsLink!">{{ doctorsLinkText }}</NuxtLink
		>.
	</TipsItem>

	<TipsItem v-if="showServicesTip">
		{{ t('TipServices') }}
		<NuxtLink :to="servicesLink">{{ servicesLinkText }}</NuxtLink
		>.
	</TipsItem>

	<TipsItem v-if="showLabTip">
		{{ t('TipLabTests') }}
		<NuxtLink :to="labTestsLink">{{ labTestsLinkText }}</NuxtLink
		>.
	</TipsItem>
</template>
