<script setup lang="ts">
import { OG_IMAGE, SITE_URL, REVIEWS_THRESHOLD } from '~/common/constants';
import { getRegionalQuery } from '~/common/url-utils';
import {
	buildBreadcrumbsSchema,
	buildDoctorSchema,
} from '~/common/schema-org-builders';
import { LanguageId } from '~/enums/language';
import breadcrumbI18n from '~/i18n/breadcrumb';
import cityI18n from '~/i18n/city';
import doctorI18n from '~/i18n/doctor';
import languageI18n from '~/i18n/language';
import reviewsI18n from '~/i18n/reviews';
import specialtyI18n from '~/i18n/specialty';
import { combineI18nMessages } from '~/i18n/utils';
import type { ClinicData } from '~/interfaces/clinic';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		breadcrumbI18n,
		doctorI18n,
		specialtyI18n,
		languageI18n,
		cityI18n,
		reviewsI18n,
	]),
});

const route = useRoute();

const { pending: isLoading, data: doctorData } = await useFetch(
	'/api/doctors/details',
	{
		key: 'doctor-details',
		method: 'POST',
		body: computed(() => ({
			slug: route.params.doctorSlug,
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

const doctorDescription = computed(() => {
	if (!isFound.value || !doctorData.value) {
		return '';
	}

	return doctorData.value.description || '';
});

const tabs = computed(() => {
	const result = [];
	if (doctorDescription.value) {
		result.push({ id: 'about', label: t('TabAbout') });
	}
	if (doctorClinics.value.length > 0) {
		result.push({ id: 'clinics', label: t('TabClinics') });
	}
	if (doctorData.value?.reviews?.length) {
		result.push({
			id: 'reviews',
			label: `${t('TabReviews')} (${
				doctorData.value.rating?.totalReviews || doctorData.value.reviews.length
			})`,
		});
	}
	if (doctorClinics.value.length > 0) {
		result.push({ id: 'map', label: t('TabMap') });
	}
	return result;
});

const mapRef = ref<InstanceType<typeof ClinicServicesMap> | null>(null);

const showClinicOnMap = (clinic: ClinicData) => {
	const el = document.getElementById('map');
	if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' });
	mapRef.value?.openClinicPopup(clinic);
};

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

const clinicInfoMap = computed(() => {
	const map: Record<number, { name: string; slug: string }> = {};
	for (const clinic of doctorClinics.value) {
		if (clinic) map[clinic.id] = { name: clinic.localName || clinic.name, slug: clinic.slug };
	}
	return map;
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

const hasSeperateReviewsPage = computed(() => {
	const total = doctorData.value?.rating?.totalReviews || doctorData.value?.reviews?.length || 0;
	return total > REVIEWS_THRESHOLD;
});

const displayedReviews = computed(() => {
	if (!doctorData.value?.reviews) return [];
	if (hasSeperateReviewsPage.value) {
		return doctorData.value.reviews.slice(0, REVIEWS_THRESHOLD);
	}
	return doctorData.value.reviews;
});

const allReviewsLink = computed(() => {
	if (!hasSeperateReviewsPage.value) return undefined;
	return {
		name: 'doctors-doctorSlug-reviews',
		params: { doctorSlug: route.params.doctorSlug },
		query: getRegionalQuery(locale.value),
	};
});

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
		const doctorUrl = `${SITE_URL}/doctors/${doctorData.value.slug}`;

		schemaOrgStore.setSchemas([
			...buildDoctorSchema({
				siteUrl: SITE_URL,
				id: doctorData.value.id,
				slug: doctorData.value.slug,
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
				rating: doctorData.value.rating,
				reviews: displayedReviews.value.map((review) => ({
					id: review.id,
					text: review.text,
					rating: review.rating,
					author: review.author,
					publishedAt: review.publishedAt,
					provider: review.provider,
				})),
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
	<EntityPage
		:isLoading="isLoading || clinicsStore.isLoadingClinics || false"
		:isFound="isFound"
		backRouteName="doctors"
		:loadingText="t('LoadingDoctor')"
		:notFoundText="t('DoctorNotFound')"
		:tabs="tabs"
	>
		<template #hero>
			<DoctorHero
				v-if="doctorData"
				:doctor="doctorData"
				:isOwner="doctorData.isOwner"
			/>
		</template>

		<template #sections>
			<!-- About -->
			<EntityPageSection
				v-if="doctorDescription"
				sectionId="about"
				:title="t('TabAbout')"
			>
				<template #icon><IconInfo :size="20" /></template>
				<MarkedContent :content="doctorDescription" />
			</EntityPageSection>

			<!-- Clinics -->
			<EntityPageSection
				v-if="doctorClinics.length > 0"
				sectionId="clinics"
				:title="t('TabClinics')"
				:count="doctorClinics.length"
			>
				<template #icon><IconClinic :size="20" /></template>
				<div class="clinics-list">
					<ClinicSummary
						v-for="clinic in doctorClinics"
						:key="clinic.id"
						:clinic="clinic"
						:services="clinicServices[clinic.id]"
						:serviceLimit="10"
						:showPrice="false"
						@show-on-map="showClinicOnMap(clinic)"
					/>
				</div>
			</EntityPageSection>

			<!-- Reviews -->
			<EntityPageSection
				v-if="doctorData?.reviews?.length"
				sectionId="reviews"
				:title="t('TabReviews')"
				:count="doctorData.rating?.totalReviews || doctorData.reviews.length"
			>
				<template #icon><IconStar :size="20" /></template>
				<DoctorReviews
					:reviews="displayedReviews"
					:rating="doctorData.rating"
					:clinicInfo="clinicInfoMap"
					:allReviewsLink="allReviewsLink"
				/>
			</EntityPageSection>

			<!-- Map -->
			<EntityPageSection
				v-if="doctorClinics.length > 0"
				sectionId="map"
				:title="t('TabMap')"
			>
				<template #icon><IconMapPin :size="20" color="#ffffff" /></template>
				<div class="doctor-map">
					<ClinicServicesMap
						ref="mapRef"
						:services="[]"
						:clinics="doctorClinics"
						:showAllClinics="true"
					/>
				</div>
			</EntityPageSection>
		</template>
	</EntityPage>
</template>

<style scoped lang="less">
.clinics-list {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
}

.doctor-map {
	height: 400px;
	border-radius: var(--border-radius-md);
	overflow: hidden;
	border: 1px solid var(--color-border-light);
}
</style>
