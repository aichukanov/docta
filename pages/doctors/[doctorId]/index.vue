<script setup lang="ts">
import { LanguageId } from '~/enums/language';
import {
	buildDoctorSchema,
	buildBreadcrumbsSchema,
} from '~/common/schema-org-builders';
import { SITE_URL, OG_IMAGE } from '~/common/constants';
import breadcrumbI18n from '~/i18n/breadcrumb';
import cityI18n from '~/i18n/city';
import doctorI18n from '~/i18n/doctor';
import languageI18n from '~/i18n/language';
import specialtyI18n from '~/i18n/specialty';
import { combineI18nMessages } from '~/i18n/utils';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		breadcrumbI18n,
		doctorI18n,
		specialtyI18n,
		languageI18n,
		cityI18n,
	]),
});

const route = useRoute();

const { pending: isLoading, data: doctorData } = await useFetch(
	'/api/doctors/details',
	{
		key: 'doctor-details',
		method: 'POST',
		body: computed(() => ({
			doctorId: route.params.doctorId,
			locale: locale.value,
			includeServices: true,
		})),
	},
);

const clinicsStore = useClinicsStore();
await clinicsStore.fetchClinics();

const clinicServices = computed(() => doctorData.value?.clinicServices || {});

const isFound = computed(() => doctorData.value?.id != null);

const localizedName = computed(() => {
	if (!doctorData.value) {
		return '';
	}
	return doctorData.value[`name_${locale.value}`] || doctorData.value.name;
});

// Set HTTP 404 status for not found doctor
if (import.meta.server && !isFound.value) {
	setResponseStatus(useRequestEvent()!, 404);
}

// clinicIds уже отсортированы на бэкенде по количеству услуг
const doctorClinics = computed(() => {
	if (!isFound.value || !clinicsStore.clinics) {
		return [];
	}

	const clinicIds = doctorData.value?.clinicIds.split(',').map(Number) || [];
	// Сохраняем порядок из API
	return clinicIds
		.map((id) => clinicsStore.clinics.find((c) => c.id === id))
		.filter(Boolean);
});

const pageTitle = computed(() => {
	if (!isFound.value) {
		return '';
	}

	const specialtiesText = doctorData.value?.specialtyIds
		?.split(',')
		.map((specialty) => t(`specialty_${specialty}`))
		.join(', ');

	const usedCities: { [key: string]: true } = {};
	const uniqueCities = doctorClinics.value
		.map((clinic) => {
			if (usedCities[clinic.cityId]) {
				return null;
			}
			usedCities[clinic.cityId] = true;
			return clinic.cityId;
		})
		.filter(Boolean);

	const locationText =
		uniqueCities.length === 1
			? t(`city_${uniqueCities[0]}`)
			: t('InMontenegro');

	const titleParts = [localizedName.value, specialtiesText, locationText];
	return titleParts.filter(Boolean).join(' | ');
});

const pageDescription = computed(() => {
	if (!isFound.value || !doctorData.value || !doctorClinics.value) {
		return '';
	}

	const { specialtyIds, languageIds, professionalTitle } = doctorData.value;

	const specialtiesText = specialtyIds
		?.split(',')
		.map((specialty) => t(`doctor_${specialty}`).toLowerCase());

	const languagesText =
		languageIds === LanguageId.SR.toString()
			? null
			: joinWithAnd(
					languageIds
						.split(',')
						.map((language) => t(`language_${language}_prepositional`)),
			  );

	const usedCities: { [key: string]: true } = {};
	const citiesText = joinWithAnd(
		doctorClinics.value
			.map((clinic) => {
				if (usedCities[clinic.cityId]) {
					return '';
				}

				usedCities[clinic.cityId] = true;
				return t(`city_${clinic.cityId}_genitive`);
			})
			.filter(Boolean),
	);

	const visitText =
		citiesText && languagesText
			? t('VisitLanguageCity', {
					language: languagesText,
					city: citiesText,
			  })
			: citiesText
			? t('VisitCity', { city: citiesText })
			: languagesText
			? t('VisitLanguage', { language: languagesText })
			: t('Visit');

	const doctorNameFull =
		(professionalTitle ? professionalTitle + ' ' : '') + localizedName.value;

	return `${doctorNameFull} — ${joinWithAnd(specialtiesText)}. ${visitText}`;
});

function joinWithAnd(items: string[]): string {
	if (items.length === 0) {
		return '';
	}

	if (items.length === 1) {
		return items[0];
	}

	return (
		items.slice(0, -1).join(', ') +
		' ' +
		t('And') +
		' ' +
		items[items.length - 1]
	);
}

const schemaOrgStore = useSchemaOrgStore();

const ogImage = computed(() => {
	if (doctorData.value?.photoUrl) {
		return doctorData.value.photoUrl;
	}
	return OG_IMAGE;
});

const robotsMeta = computed(() => (isFound.value ? undefined : 'noindex'));

useSeoMeta({
	title: pageTitle,
	description: pageDescription,
	ogTitle: pageTitle,
	ogDescription: pageDescription,
	ogImage: ogImage,
	ogType: 'profile',
	twitterCard: 'summary',
	twitterTitle: pageTitle,
	twitterDescription: pageDescription,
	twitterImage: ogImage,
	robots: robotsMeta,
});

const getCityName = (id: number): string | undefined => {
	const key = `city_${id}`;
	const value = t(key);
	return value && value !== key ? value : undefined;
};

const getSpecialtyName = (id: number): string | undefined => {
	const key = `specialty_${id}`;
	const value = t(key);
	return value && value !== key ? value : undefined;
};

watchEffect(() => {
	if (doctorData.value && isFound.value) {
		const specialtyIds = doctorData.value.specialtyIds?.split(',').map(Number);
		const languageIds = doctorData.value.languageIds?.split(',').map(Number);
		const doctorUrl = `${SITE_URL}/doctors/${doctorData.value.id}`;

		schemaOrgStore.setSchemas([
			...buildDoctorSchema({
				siteUrl: SITE_URL,
				id: doctorData.value.id,
				name: localizedName.value,
				photoUrl: doctorData.value.photoUrl,
				specialtyIds,
				languageIds,
				clinics: doctorClinics.value,
				clinicServices: clinicServices.value,
				title: doctorData.value.professionalTitle,
				locale: locale.value,
				pageTitle: pageTitle.value,
				pageDescription: pageDescription.value,
				facebook: doctorData.value.facebook,
				instagram: doctorData.value.instagram,
				getSpecialtyName,
				getCityName,
			}),
			buildBreadcrumbsSchema(doctorUrl, [
				{ name: t('BreadcrumbHome'), url: `${SITE_URL}/` },
				{ name: t('BreadcrumbDoctors'), url: `${SITE_URL}/doctors` },
				{ name: pageTitle.value },
			]),
		]);
	}
});
</script>

<template>
	<DetailsPage
		:isLoading="isLoading || clinicsStore.isLoadingClinics || false"
		:isFound="isFound"
		:clinics="doctorClinics"
		backRouteName="doctors"
		:loadingText="t('LoadingDoctor')"
		:notFoundText="t('DoctorNotFound')"
	>
		<template #info>
			<DoctorInfo v-if="doctorData" :service="doctorData" isMainHeading />
		</template>
		<template #clinics="{ showClinicOnMap }">
			<section class="clinics-list" role="list">
				<ClinicSummary
					v-for="clinic in doctorClinics"
					:key="clinic.id"
					:clinic="clinic"
					:services="clinicServices[clinic.id]"
					:serviceLimit="10"
					:showPrice="false"
					@show-on-map="showClinicOnMap(clinic)"
					role="listitem"
				/>
			</section>
		</template>
	</DetailsPage>
</template>

<style scoped lang="less">
.clinics-list {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
}
</style>
