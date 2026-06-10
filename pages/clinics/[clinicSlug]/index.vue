<script setup lang="ts">
import { Clock } from '@element-plus/icons-vue';
import { formatClinicAddressLine } from '~/common/clinic-address';
import {
	CLINIC_ITEMS_INLINE_THRESHOLD,
	OG_IMAGE,
	REVIEWS_THRESHOLD,
	SITE_NAME,
	SITE_URL,
} from '~/common/constants';
import {
	buildBreadcrumbsSchema,
	buildClinicSchema,
} from '~/common/schema-org-builders';
import { getRegionalQuery } from '~/common/url-utils';
import { getLocalizedName } from '~/common/utils';
import breadcrumbI18n from '~/i18n/breadcrumb';
import cityI18n from '~/i18n/city';
import clinicI18n from '~/i18n/clinic';
import clinicCommonI18n from '~/i18n/clinic-common';
import clinicTypeI18n from '~/i18n/clinic-type';
import labTestCategoryI18n from '~/i18n/labtest-category';
import languageI18n from '~/i18n/language';
import medicalServiceCategoryI18n from '~/i18n/medical-service-category';
import reviewsI18n from '~/i18n/reviews';
import specialtyI18n from '~/i18n/specialty';
import { combineI18nMessages } from '~/i18n/utils';
import workingHoursI18n from '~/i18n/working-hours';
import type { ClinicItemTopEntry, ClinicPrice } from '~/interfaces/clinic';
import type { WorkingHours } from '~/interfaces/clinic-working-hours';
import { DAYS_OF_WEEK } from '~/interfaces/clinic-working-hours';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		breadcrumbI18n,
		clinicI18n,
		clinicCommonI18n,
		clinicTypeI18n,
		languageI18n,
		cityI18n,
		medicalServiceCategoryI18n,
		specialtyI18n,
		labTestCategoryI18n,
		reviewsI18n,
		workingHoursI18n,
	]),
});

const route = useRoute();
const clinicSlug = computed(() => route.params.clinicSlug as string);
const clinicId = computed(() => clinicData.value?.id);

const { pending: isLoading, data: clinicData } = await useFetch(
	'/api/clinics/details',
	{
		key: 'clinic-details',
		method: 'POST',
		body: computed(() => ({
			slug: clinicSlug.value,
			locale: locale.value,
		})),
	},
);

const itemsSummary = computed(() => clinicData.value?.itemsSummary);

const totals = computed(() => ({
	doctors: itemsSummary.value?.doctors.totalCount ?? 0,
	services: itemsSummary.value?.services.totalCount ?? 0,
	labtests: itemsSummary.value?.labtests.totalCount ?? 0,
	medications: itemsSummary.value?.medications.totalCount ?? 0,
}));

const isInline = (total: number) =>
	total > 0 && total <= CLINIC_ITEMS_INLINE_THRESHOLD;

const renderInline = computed(() => ({
	doctors: isInline(totals.value.doctors),
	services: isInline(totals.value.services),
	labtests: isInline(totals.value.labtests),
	medications: isInline(totals.value.medications),
}));

const fetchInlineList = async <T,>(
	endpoint: string,
	enabled: boolean,
	empty: T,
): Promise<T> => {
	if (!enabled || !clinicId.value) return empty;
	const res = (await $fetch(endpoint, {
		method: 'POST',
		body: {
			clinicIds: [clinicId.value],
			locale: locale.value,
		},
	})) as T | null;
	return res ?? empty;
};

const { data: doctorsList } = await useAsyncData(
	`doctors-list-clinic-${clinicSlug.value}`,
	() =>
		fetchInlineList('/api/doctors/list', renderInline.value.doctors, {
			doctors: [],
			totalCount: 0,
		}),
	{ watch: [renderInline, clinicId] },
);

const { data: labTestsList } = await useAsyncData(
	`labtests-list-clinic-${clinicSlug.value}`,
	() =>
		fetchInlineList('/api/labtests/list', renderInline.value.labtests, {
			items: [],
			totalCount: 0,
		}),
	{ watch: [renderInline, clinicId] },
);

const { data: medicationsList } = await useAsyncData(
	`medications-list-clinic-${clinicSlug.value}`,
	() =>
		fetchInlineList('/api/medications/list', renderInline.value.medications, {
			items: [],
			totalCount: 0,
		}),
	{ watch: [renderInline, clinicId] },
);

const { data: medicalServicesList } = await useAsyncData(
	`services-list-clinic-${clinicSlug.value}`,
	() =>
		fetchInlineList('/api/services/list', renderInline.value.services, {
			items: [],
			totalCount: 0,
		}),
	{ watch: [renderInline, clinicId] },
);

const { data: workingHoursData } = await useFetch<WorkingHours>(
	'/api/clinics/working-hours',
	{
		key: `clinic-wh-${clinicSlug.value}`,
		method: 'POST',
		body: computed(() => ({ clinicId: clinicId.value })),
	},
);

const hasWorkingHours = computed(() => {
	if (!workingHoursData.value) return false;
	return DAYS_OF_WEEK.some(
		(day) => workingHoursData.value![day]?.type !== 'not_specified',
	);
});

const isFound = computed(() => clinicData.value?.id != null);

const localizedName = computed(() =>
	getLocalizedName(clinicData.value, locale.value),
);

const clinicTypeNames = computed(() => {
	if (!clinicData.value?.clinicTypeIds) return [];
	return clinicData.value.clinicTypeIds
		.split(',')
		.map(Number)
		.filter(Boolean)
		.map((id) => t(`clinic_type_${id}`));
});

// Set HTTP 404 status for not found clinic
if (import.meta.server && !isFound.value) {
	setResponseStatus(useRequestEvent()!, 404);
}

const clinicDescription = computed(() => {
	if (!isFound.value || !clinicData.value) {
		return '';
	}

	return clinicData.value.description || '';
});

const clinicDoctors = computed(() => doctorsList.value?.doctors || []);
const clinicLabTests = computed(() => labTestsList.value?.items || []);
const clinicMedications = computed(() => medicationsList.value?.items || []);
const clinicMedicalServices = computed(
	() => medicalServicesList.value?.items || [],
);

// Группировка врачей по специальностям с переводами
const clinicDoctorsBySpecialty = useItemsByCategory(clinicDoctors, (doctor) =>
	doctor.specialtyIds?.split(',').map(Number).filter(Boolean),
);

const doctorCategoriesWithTitles = computed(() => ({
	categories: clinicDoctorsBySpecialty.value.categories.map((cat) => ({
		title: t(`specialty_${cat.categoryId}`),
		items: cat.items,
	})),
}));

// Группировка медицинских услуг по категориям с переводами
const clinicMedicalServicesByCategory = useItemsByCategory(
	clinicMedicalServices,
	(service) => service.categoryIds,
);

const serviceCategoriesWithTitles = computed(() => ({
	categories: clinicMedicalServicesByCategory.value.categories.map((cat) => ({
		title: t(`medical_service_category_${cat.categoryId}`),
		items: cat.items,
	})),
}));

// Группировка анализов по категориям с переводами
const clinicLabTestsByCategory = useItemsByCategory(
	clinicLabTests,
	(labTest) => labTest.categoryIds,
);

const labTestCategoriesWithTitles = computed(() => ({
	categories: clinicLabTestsByCategory.value.categories.map((cat) => ({
		title: t(`lab_test_category_${cat.categoryId}`),
		items: cat.items,
	})),
}));

const getClinicPrice = (clinicPrices?: ClinicPrice[]) => {
	return clinicPrices?.find((price) => price.clinicId === clinicId.value);
};

const clinicAsList = computed(() =>
	isFound.value && clinicData.value ? [clinicData.value] : [],
);

const EMPTY_TYPE_SUMMARY = {
	totalCount: 0,
	categories: [],
	topItems: [],
};
const servicesSummary = computed(
	() => itemsSummary.value?.services ?? EMPTY_TYPE_SUMMARY,
);
const labtestsSummary = computed(
	() => itemsSummary.value?.labtests ?? EMPTY_TYPE_SUMMARY,
);
const medicationsSummary = computed(
	() => itemsSummary.value?.medications ?? EMPTY_TYPE_SUMMARY,
);
const doctorsSummary = computed(
	() => itemsSummary.value?.doctors ?? EMPTY_TYPE_SUMMARY,
);

const serviceCategoryTitle = (id: number) =>
	t(`medical_service_category_${id}`);
const labtestCategoryTitle = (id: number) => t(`lab_test_category_${id}`);
const specialtyTitle = (id: number) => t(`specialty_${id}`);

const tabs = computed(() => {
	const result = [];
	if (clinicDescription.value) {
		result.push({ id: 'about', label: t('TabAbout') });
	}
	result.push({ id: 'contacts', label: t('TabContacts') });
	if (hasWorkingHours.value) {
		result.push({ id: 'hours', label: t('WorkingHours') });
	}
	if (totals.value.doctors > 0) {
		result.push({
			id: 'doctors',
			label: `${t('TabDoctors')} (${totals.value.doctors})`,
		});
	}
	if (totals.value.services > 0) {
		result.push({
			id: 'services',
			label: `${t('TabServices')} (${totals.value.services})`,
		});
	}
	if (totals.value.labtests > 0) {
		result.push({
			id: 'labtests',
			label: `${t('TabLabTests')} (${totals.value.labtests})`,
		});
	}
	if (totals.value.medications > 0) {
		result.push({
			id: 'medications',
			label: `${t('TabMedications')} (${totals.value.medications})`,
		});
	}
	if (clinicData.value) {
		const reviewCount =
			clinicData.value.rating?.totalReviews ||
			clinicData.value.reviews?.length ||
			0;
		result.push({
			id: 'reviews',
			label:
				reviewCount > 0
					? `${t('TabReviews')} (${reviewCount})`
					: t('TabReviews'),
		});
	}
	result.push({ id: 'map', label: t('TabMap') });
	return result;
});

const mapRef = ref<InstanceType<typeof ClinicServicesMap> | null>(null);
const { target: mapSentinel, hasBeenVisible: isMapVisible } = useInViewport();
const pendingMapAction = ref<(() => void) | null>(null);

const onMapReady = () => {
	if (pendingMapAction.value) {
		pendingMapAction.value();
		pendingMapAction.value = null;
	}
};

const scrollToMap = () => {
	const el = document.getElementById('map');
	if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' });
	const action = () => {
		if (clinicData.value) {
			mapRef.value?.openClinicPopup(clinicData.value);
		}
	};
	if (mapRef.value) {
		action();
	} else {
		pendingMapAction.value = action;
		isMapVisible.value = true;
	}
};

const pageTitle = computed(() => {
	if (!isFound.value) {
		return '';
	}

	const clinicName = localizedName.value;
	const city = t(`city_${clinicData.value.cityId}`);
	const doctorCount = totals.value.doctors;
	const serviceCount = totals.value.services;

	const statsParts: string[] = [];
	if (doctorCount > 0) {
		statsParts.push(t('SeoTitleDoctors', { count: doctorCount }));
	}
	if (serviceCount > 0) {
		statsParts.push(t('SeoTitleServices', { count: serviceCount }));
	}

	if (statsParts.length > 0) {
		return `${clinicName} ${city} — ${statsParts.join(', ')} | ${SITE_NAME}`;
	}

	return `${clinicName} | ${city}`;
});

const pageDescription = computed(() => {
	if (!isFound.value || !clinicData.value) {
		return '';
	}

	const clinicName = localizedName.value;
	const cityGenitive = t(`city_${clinicData.value.cityId}_genitive`);

	const segments: string[] = [];

	// Specialties (top 3 by doctor count) — prefer itemsSummary; fall back to list.
	const summaryDoctorCats = (itemsSummary.value?.doctors.categories || [])
		.filter((c) => c.categoryId != null)
		.map((c) => ({ categoryId: c.categoryId as number, count: c.count }))
		.sort((a, b) => b.count - a.count);

	const specialtyCategories = summaryDoctorCats.length
		? summaryDoctorCats
		: [...clinicDoctorsBySpecialty.value.categories]
				.sort((a, b) => b.items.length - a.items.length)
				.map((c) => ({ categoryId: c.categoryId, count: c.items.length }));

	if (specialtyCategories.length > 0) {
		const topSpecialties = specialtyCategories
			.slice(0, 3)
			.map((cat) => t(`specialty_${cat.categoryId}`).toLowerCase());

		if (specialtyCategories.length > 3) {
			segments.push(
				t('SeoDescMoreSpecialties', {
					specialties: topSpecialties.join(', '),
					count: specialtyCategories.length - 3,
				}),
			);
		} else {
			segments.push(topSpecialties.join(', '));
		}
	}

	// Min price — prefer inline list (covers all services); fall back to topItems
	// from itemsSummary so big clinics still get a price hint in SEO description.
	const inlinePrices = clinicMedicalServices.value
		.flatMap((s) => s.clinicPrices)
		.filter((p) => p.clinicId === clinicData.value!.id)
		.map((p) => p.price ?? p.priceMin)
		.filter((p): p is number => p != null && p > 0);
	const topItemPrices = (itemsSummary.value?.services.topItems || [])
		.flatMap((s) => [s.price, s.priceMin])
		.filter((p): p is number => p != null && p > 0);
	const allPrices = inlinePrices.length > 0 ? inlinePrices : topItemPrices;

	if (allPrices.length > 0) {
		const minPrice = Math.min(...allPrices);
		segments.push(t('SeoDescPriceFrom', { price: minPrice }));
	}

	// Rating & reviews
	const rating = clinicData.value.rating;
	if (rating?.averageRating && rating.totalReviews > 0) {
		segments.push(
			t('SeoDescRating', {
				rating: rating.averageRating.toFixed(1),
				count: rating.totalReviews,
			}),
		);
	}

	// CTA
	segments.push(t('SeoDescCta'));

	const intro = t('SeoDescIntro', { name: clinicName, city: cityGenitive });
	return `${intro} ${segments.join('. ')}.`;
});

const hasSeparateReviewsPage = computed(() => {
	const total =
		clinicData.value?.rating?.totalReviews ||
		clinicData.value?.reviews?.length ||
		0;
	return total > REVIEWS_THRESHOLD;
});

const allClinicReviews = computed(() => {
	if (!clinicData.value?.reviews) return [];
	return clinicData.value.reviews;
});

const localOwnReview = ref<any>(null);
const ownReviewDeleted = ref(false);
const showReviewDialog = ref(false);

const ownReview = computed(() => {
	if (ownReviewDeleted.value) return null;
	return (
		localOwnReview.value || allClinicReviews.value.find((r) => r.isOwn) || null
	);
});
const otherReviews = computed(() =>
	allClinicReviews.value.filter((r) => !r.isOwn),
);

const displayedReviews = computed(() => {
	if (hasSeparateReviewsPage.value) {
		return otherReviews.value.slice(0, REVIEWS_THRESHOLD);
	}
	return otherReviews.value;
});

const onReviewSubmitted = (review: any) => {
	localOwnReview.value = review;
	ownReviewDeleted.value = false;
};

const onReviewDeleted = () => {
	localOwnReview.value = null;
	ownReviewDeleted.value = true;
};

const allReviewsLink = computed(() => {
	if (!hasSeparateReviewsPage.value) return undefined;
	return {
		name: 'clinics-clinicSlug-reviews',
		params: { clinicSlug: clinicSlug.value },
		query: getRegionalQuery(locale.value),
	};
});

const schemaOrgStore = useSchemaOrgStore();

const robotsMeta = computed(() => (isFound.value ? undefined : 'noindex'));

useSeoMeta({
	title: pageTitle,
	description: pageDescription,
	ogTitle: pageTitle,
	ogDescription: pageDescription,
	ogImage: OG_IMAGE,
	ogType: 'business.business',
	twitterCard: 'summary',
	twitterTitle: pageTitle,
	twitterDescription: pageDescription,
	twitterImage: OG_IMAGE,
	robots: robotsMeta,
});

const getCityName = (id: number): string | undefined => {
	const key = `city_${id}`;
	const value = t(key);
	return value && value !== key ? value : undefined;
};

const topItemsToOffers = (
	items: ClinicItemTopEntry[] | undefined,
	clinicIdValue: number,
) =>
	(items || []).map((item) => ({
		id: item.id,
		slug: item.slug,
		name: item.name,
		clinicPrices: [
			{
				clinicId: clinicIdValue,
				price: item.price,
				priceMin: item.priceMin,
				priceMax: item.priceMax,
			},
		],
	}));

watchEffect(() => {
	if (clinicData.value && isFound.value) {
		const clinicUrl = `${SITE_URL}/clinics/${clinicData.value.slug}`;
		const cid = clinicData.value.id;

		const schemaServices =
			clinicMedicalServices.value.length > 0
				? clinicMedicalServices.value
				: topItemsToOffers(itemsSummary.value?.services.topItems, cid);
		const schemaLabTests =
			clinicLabTests.value.length > 0
				? clinicLabTests.value
				: topItemsToOffers(itemsSummary.value?.labtests.topItems, cid);
		const schemaMedications =
			clinicMedications.value.length > 0
				? clinicMedications.value
				: topItemsToOffers(itemsSummary.value?.medications.topItems, cid);
		const schemaDoctors =
			clinicDoctors.value.length > 0
				? clinicDoctors.value
				: (itemsSummary.value?.doctors.topItems || []).map((d) => ({
						id: d.id,
						slug: d.slug,
						professionalTitle: d.professionalTitle,
					}));

		schemaOrgStore.setSchemas([
			...buildClinicSchema({
				siteUrl: SITE_URL,
				clinic: clinicData.value,
				locale: locale.value,
				pageTitle: pageTitle.value,
				pageDescription: pageDescription.value,
				getCityName,
				services: schemaServices,
				labTests: schemaLabTests,
				medications: schemaMedications,
				doctors: schemaDoctors,
				workingHours: workingHoursData.value,
				rating: clinicData.value.rating,
				reviews: displayedReviews.value.map((review) => ({
					id: review.id,
					text: review.text,
					rating: review.rating,
					author: review.author,
					publishedAt: review.publishedAt,
					provider: review.provider,
				})),
			}),
			buildBreadcrumbsSchema(clinicUrl, [
				{ name: t('BreadcrumbHome'), url: `${SITE_URL}/` },
				{ name: t('BreadcrumbClinics'), url: `${SITE_URL}/clinics` },
				{ name: localizedName.value },
			]),
		]);
	}
});
</script>

<template>
	<EntityPage
		:isLoading="isLoading || false"
		:isFound="isFound"
		backRouteName="clinics"
		:loadingText="t('LoadingClinic')"
		:notFoundText="t('ClinicNotFound')"
		:tabs="tabs"
	>
		<template #hero>
			<ClinicHero
				v-if="clinicData"
				:clinic="clinicData"
				:cityName="t(`city_${clinicData.cityId}`)"
				:languageAssistanceLabel="t('LanguageAssistance')"
				:clinicTypeNames="clinicTypeNames"
				@scrollToMap="scrollToMap"
			/>
		</template>

		<template #sections>
			<!-- About -->
			<EntityPageSection
				v-if="clinicDescription"
				sectionId="about"
				:title="t('TabAbout')"
			>
				<template #icon><IconInfo :size="20" /></template>
				<CollapsibleContent>
					<MarkedContent :content="clinicDescription" />
				</CollapsibleContent>
			</EntityPageSection>

			<!-- Contacts -->
			<EntityPageSection
				v-if="clinicData"
				sectionId="contacts"
				:title="t('TabContacts')"
			>
				<template #icon><IconPhone :size="20" /></template>
				<ContactsList :list="clinicData" />
			</EntityPageSection>

			<!-- Working Hours -->
			<EntityPageSection
				v-if="hasWorkingHours"
				sectionId="hours"
				:title="t('WorkingHours')"
			>
				<template #icon>
					<el-icon :size="20"><Clock /></el-icon>
				</template>
				<ClinicWorkingHours :clinicId="clinicId" />
			</EntityPageSection>

			<!-- Doctors -->
			<EntityPageSection v-if="totals.doctors > 0" sectionId="doctors">
				<ClinicCategorizedSection
					v-if="renderInline.doctors"
					:title="t('DoctorsAtClinic')"
					:totalCount="totals.doctors"
					routeName="doctors"
					:categories="doctorCategoriesWithTitles.categories"
					:initialLimit="0"
				>
					<template #icon><IconDoctor /></template>
					<template #default="{ item }">
						<DoctorInfo :service="item" short headingLevel="h4" />
					</template>
				</ClinicCategorizedSection>
				<ClinicItemsSummary
					v-else
					:title="t('DoctorsAtClinic')"
					:summary="doctorsSummary"
					:clinicSlug="clinicSlug"
					subpageRouteName="clinics-clinicSlug-doctors"
					categoryQueryKey="category"
					:getCategoryTitle="specialtyTitle"
					:viewAllLabel="t('ViewAllDoctors', { count: totals.doctors })"
					:popularLabel="t('PopularLabel')"
					:categoriesLabel="t('BySpecialtyLabel')"
				>
					<template #icon><IconDoctor /></template>
					<template #item="{ item }">
						<DoctorInfo :service="item" short headingLevel="h4" />
					</template>
				</ClinicItemsSummary>
			</EntityPageSection>

			<!-- Services -->
			<EntityPageSection v-if="totals.services > 0" sectionId="services">
				<ClinicCategorizedSection
					v-if="renderInline.services"
					:title="t('MedicalServicesAtClinic')"
					:totalCount="totals.services"
					routeName="services"
					:categories="serviceCategoriesWithTitles.categories"
				>
					<template #icon><IconMedicalService /></template>
					<template #default="{ item }">
						<PricedItemCard
							:id="item.id"
							:slug="item.slug"
							:name="item.name"
							:localName="item.localName"
							:price="getClinicPrice(item.clinicPrices)?.price"
							:priceMax="getClinicPrice(item.clinicPrices)?.priceMax"
							:priceMin="getClinicPrice(item.clinicPrices)?.priceMin"
							routeName="services-serviceSlug"
							routeParamName="serviceSlug"
						/>
					</template>
				</ClinicCategorizedSection>
				<ClinicItemsSummary
					v-else
					:title="t('MedicalServicesAtClinic')"
					:summary="servicesSummary"
					:clinicSlug="clinicSlug"
					subpageRouteName="clinics-clinicSlug-services"
					categoryQueryKey="category"
					:getCategoryTitle="serviceCategoryTitle"
					:viewAllLabel="t('ViewAllServices', { count: totals.services })"
					:popularLabel="t('PopularLabel')"
					:categoriesLabel="t('ByCategoryLabel')"
				>
					<template #icon><IconMedicalService /></template>
					<template #item="{ item }">
						<PricedItemCard
							:id="item.id"
							:slug="item.slug"
							:name="item.name"
							:localName="item.localName"
							:price="item.price"
							:priceMax="item.priceMax"
							:priceMin="item.priceMin"
							routeName="services-serviceSlug"
							routeParamName="serviceSlug"
						/>
					</template>
				</ClinicItemsSummary>
			</EntityPageSection>

			<!-- Lab Tests -->
			<EntityPageSection v-if="totals.labtests > 0" sectionId="labtests">
				<ClinicCategorizedSection
					v-if="renderInline.labtests"
					:title="t('LabTestsAtClinic')"
					:totalCount="totals.labtests"
					routeName="labtests"
					:categories="labTestCategoriesWithTitles.categories"
				>
					<template #icon><IconLabTest /></template>
					<template #default="{ item }">
						<PricedItemCard
							:id="item.id"
							:slug="item.slug"
							:name="item.name"
							:localName="item.localName"
							:price="getClinicPrice(item.clinicPrices)?.price"
							:priceMax="getClinicPrice(item.clinicPrices)?.priceMax"
							routeName="labtests-labTestSlug"
							routeParamName="labTestSlug"
						/>
					</template>
				</ClinicCategorizedSection>
				<ClinicItemsSummary
					v-else
					:title="t('LabTestsAtClinic')"
					:summary="labtestsSummary"
					:clinicSlug="clinicSlug"
					subpageRouteName="clinics-clinicSlug-labtests"
					categoryQueryKey="category"
					:getCategoryTitle="labtestCategoryTitle"
					:viewAllLabel="t('ViewAllLabTests', { count: totals.labtests })"
					:popularLabel="t('PopularLabel')"
					:categoriesLabel="t('ByCategoryLabel')"
				>
					<template #icon><IconLabTest /></template>
					<template #item="{ item }">
						<PricedItemCard
							:id="item.id"
							:slug="item.slug"
							:name="item.name"
							:localName="item.localName"
							:price="item.price"
							:priceMax="item.priceMax"
							routeName="labtests-labTestSlug"
							routeParamName="labTestSlug"
						/>
					</template>
				</ClinicItemsSummary>
			</EntityPageSection>

			<!-- Medications -->
			<EntityPageSection v-if="totals.medications > 0" sectionId="medications">
				<ClinicServiceSection
					v-if="renderInline.medications"
					:title="t('MedicationsAtClinic')"
					:items="clinicMedications"
					routeName="medications"
				>
					<template #icon><IconMedication /></template>
					<template #default="{ item }">
						<PricedItemCard
							:id="item.id"
							:slug="item.slug"
							:name="item.name"
							:localName="item.localName"
							:price="getClinicPrice(item.clinicPrices)?.price"
							:priceMax="getClinicPrice(item.clinicPrices)?.priceMax"
							routeName="medications-medicationSlug"
							routeParamName="medicationSlug"
						/>
					</template>
				</ClinicServiceSection>
				<ClinicItemsSummary
					v-else
					:title="t('MedicationsAtClinic')"
					:summary="medicationsSummary"
					:clinicSlug="clinicSlug"
					subpageRouteName="clinics-clinicSlug-medications"
					categoryQueryKey="category"
					:getCategoryTitle="() => ''"
					:viewAllLabel="t('ViewAllMedications', { count: totals.medications })"
					:popularLabel="t('PopularLabel')"
				>
					<template #icon><IconMedication /></template>
					<template #item="{ item }">
						<PricedItemCard
							:id="item.id"
							:slug="item.slug"
							:name="item.name"
							:localName="item.localName"
							:price="item.price"
							:priceMax="item.priceMax"
							routeName="medications-medicationSlug"
							routeParamName="medicationSlug"
						/>
					</template>
				</ClinicItemsSummary>
			</EntityPageSection>

			<!-- Reviews -->
			<EntityPageSection v-if="clinicData" sectionId="reviews">
				<div class="reviews-header">
					<EntityPageSectionTitle :title="t('TabReviews')">
						<template #icon><IconStar :size="20" /></template>
					</EntityPageSectionTitle>
					<ViewAllLink
						v-if="allReviewsLink && clinicData.rating"
						:to="allReviewsLink"
						:label="t('AllReviews', { count: clinicData.rating.totalReviews })"
					/>
				</div>
				<div class="reviews-content">
					<RatingSummary
						v-if="clinicData.rating && clinicData.rating.totalReviews > 0"
						:rating="clinicData.rating"
						:hideWriteButton="!!ownReview"
						@writeReview="showReviewDialog = true"
					/>
					<ReviewItem
						v-if="ownReview"
						:review="ownReview"
						@updated="(r) => (localOwnReview = r)"
						@deleted="onReviewDeleted"
					/>
					<DoctorReviews
						:reviews="displayedReviews"
						:noReviewsText="t('NoReviewsClinic')"
					/>
				</div>
				<ReviewForm
					v-if="clinicData.id"
					v-model="showReviewDialog"
					entityType="clinic"
					:entityId="clinicData.id"
					:entityName="localizedName"
					:relatedEntities="
						clinicDoctors.map((d) => ({ id: d.id, name: d.name }))
					"
					@submitted="onReviewSubmitted"
				/>
			</EntityPageSection>

			<!-- Map -->
			<EntityPageSection sectionId="map" :title="t('TabMap')">
				<template #icon><IconMapPin :size="20" color="#ffffff" /></template>
				<div ref="mapSentinel" class="clinic-map">
					<LazyClinicServicesMap
						v-if="isMapVisible"
						ref="mapRef"
						:services="[]"
						:clinics="clinicAsList"
						:showAllClinics="true"
						@ready="onMapReady"
					/>
				</div>
			</EntityPageSection>
		</template>
	</EntityPage>
</template>

<i18n lang="json">
{
	"en": {
		"ClinicLanguageAssistance": "Assistance is provided in {language}.",
		"Contacts": "Contacts",
		"MedicalServicesAtClinic": "Medical services",
		"LabTestsAtClinic": "Lab tests",
		"MedicationsAtClinic": "Medications",
		"NoServicesAtClinic": "Information about services at this clinic is not yet available",
		"TabAbout": "About",
		"TabContacts": "Contacts",
		"TabReviews": "Reviews",
		"TabMap": "Location",
		"SeoTitleDoctors": "{count} doctors",
		"SeoTitleServices": "{count} services",
		"SeoDescIntro": "{name} in {city}:",
		"SeoDescMoreSpecialties": "{specialties} and {count}+ more specialties",
		"SeoDescPriceFrom": "Services from {price}€",
		"SeoDescRating": "Rating {rating} ★ ({count} reviews)",
		"SeoDescCta": "Find a doctor on Docta.me",
		"ViewAllServices": "All services ({count})",
		"ViewAllLabTests": "All lab tests ({count})",
		"ViewAllMedications": "All medications ({count})",
		"ViewAllDoctors": "All doctors ({count})",
		"PopularLabel": "Popular",
		"ByCategoryLabel": "Browse by category",
		"BySpecialtyLabel": "Browse by specialty"
	},
	"ru": {
		"ClinicLanguageAssistance": "Предоставляется сопровождение на {language} языке.",
		"Contacts": "Контакты",
		"MedicalServicesAtClinic": "Медицинские услуги",
		"LabTestsAtClinic": "Анализы",
		"MedicationsAtClinic": "Лекарства",
		"NoServicesAtClinic": "У нас пока нет информации об услугах этой клиники",
		"TabAbout": "О клинике",
		"TabContacts": "Контакты",
		"TabReviews": "Отзывы",
		"TabMap": "На карте",
		"SeoTitleDoctors": "{count} врачей",
		"SeoTitleServices": "{count} услуг",
		"SeoDescIntro": "{name} в {city}:",
		"SeoDescMoreSpecialties": "{specialties} и ещё {count}+ специальностей",
		"SeoDescPriceFrom": "Цены на услуги от {price}€",
		"SeoDescRating": "Оценка {rating} ★ ({count} отзывов)",
		"SeoDescCta": "Найдите врача на Docta.me",
		"ViewAllServices": "Все услуги ({count})",
		"ViewAllLabTests": "Все анализы ({count})",
		"ViewAllMedications": "Все лекарства ({count})",
		"ViewAllDoctors": "Все врачи ({count})",
		"PopularLabel": "Популярные",
		"ByCategoryLabel": "По категориям",
		"BySpecialtyLabel": "По специальностям"
	},
	"de": {
		"ClinicLanguageAssistance": "Unterstützung wird in {language} bereitgestellt.",
		"Contacts": "Kontakte",
		"MedicalServicesAtClinic": "Medizinische Dienstleistungen",
		"LabTestsAtClinic": "Laboruntersuchungen",
		"MedicationsAtClinic": "Medikamente",
		"NoServicesAtClinic": "Informationen über die Leistungen dieser Klinik sind noch nicht verfügbar",
		"TabAbout": "Über uns",
		"TabContacts": "Kontakte",
		"TabReviews": "Bewertungen",
		"TabMap": "Standort",
		"SeoTitleDoctors": "{count} Ärzte",
		"SeoTitleServices": "{count} Leistungen",
		"SeoDescIntro": "{name} in {city}:",
		"SeoDescMoreSpecialties": "{specialties} und {count}+ weitere Fachgebiete",
		"SeoDescPriceFrom": "Leistungen ab {price}€",
		"SeoDescRating": "Bewertung {rating} ★ ({count} Bewertungen)",
		"SeoDescCta": "Finden Sie einen Arzt auf Docta.me",
		"ViewAllServices": "Alle Leistungen ({count})",
		"ViewAllLabTests": "Alle Laboruntersuchungen ({count})",
		"ViewAllMedications": "Alle Medikamente ({count})",
		"ViewAllDoctors": "Alle Ärzte ({count})",
		"PopularLabel": "Beliebt",
		"ByCategoryLabel": "Nach Kategorie",
		"BySpecialtyLabel": "Nach Fachgebiet"
	},
	"tr": {
		"ClinicLanguageAssistance": "{language} dilinde destek sağlanır.",
		"Contacts": "İletişim",
		"MedicalServicesAtClinic": "Tıbbi hizmetler",
		"LabTestsAtClinic": "Laboratuvar testleri",
		"MedicationsAtClinic": "İlaçlar",
		"NoServicesAtClinic": "Bu kliniğin hizmetleri hakkında henüz bilgi bulunmamaktadır",
		"TabAbout": "Hakkında",
		"TabContacts": "İletişim",
		"TabReviews": "Değerlendirmeler",
		"TabMap": "Konum",
		"SeoTitleDoctors": "{count} doktor",
		"SeoTitleServices": "{count} hizmet",
		"SeoDescIntro": "{name} {city}:",
		"SeoDescMoreSpecialties": "{specialties} ve {count}+ uzmanlık alanı daha",
		"SeoDescPriceFrom": "Hizmetler {price}€'dan başlayan fiyatlarla",
		"SeoDescRating": "Puan {rating} ★ ({count} değerlendirme)",
		"SeoDescCta": "Docta.me'de doktor bulun",
		"ViewAllServices": "Tüm hizmetler ({count})",
		"ViewAllLabTests": "Tüm laboratuvar testleri ({count})",
		"ViewAllMedications": "Tüm ilaçlar ({count})",
		"ViewAllDoctors": "Tüm doktorlar ({count})",
		"PopularLabel": "Popüler",
		"ByCategoryLabel": "Kategoriye göre",
		"BySpecialtyLabel": "Uzmanlığa göre"
	},
	"sr": {
		"ClinicLanguageAssistance": "Pomoć se pruža na {language} jeziku.",
		"Contacts": "Kontakti",
		"MedicalServicesAtClinic": "Medicinske usluge",
		"LabTestsAtClinic": "Laboratorijske analize",
		"MedicationsAtClinic": "Lekovi",
		"NoServicesAtClinic": "Trenutno nemamo informacije o uslugama ove klinike",
		"TabAbout": "O klinici",
		"TabContacts": "Kontakti",
		"TabReviews": "Recenzije",
		"TabMap": "Lokacija",
		"SeoTitleDoctors": "{count} ljekara",
		"SeoTitleServices": "{count} usluga",
		"SeoDescIntro": "{name} u {city}:",
		"SeoDescMoreSpecialties": "{specialties} i još {count}+ specijalnosti",
		"SeoDescPriceFrom": "Cijene usluga od {price}€",
		"SeoDescRating": "Ocjena {rating} ★ ({count} recenzija)",
		"SeoDescCta": "Pronađite ljekara na Docta.me",
		"ViewAllServices": "Sve usluge ({count})",
		"ViewAllLabTests": "Sve analize ({count})",
		"ViewAllMedications": "Svi lekovi ({count})",
		"ViewAllDoctors": "Svi ljekari ({count})",
		"PopularLabel": "Popularno",
		"ByCategoryLabel": "Po kategoriji",
		"BySpecialtyLabel": "Po specijalnosti"
	},
	"sr-cyrl": {
		"ClinicLanguageAssistance": "Помоћ се пружа на {language} језику.",
		"Contacts": "Контакти",
		"MedicalServicesAtClinic": "Медицинске услуге",
		"LabTestsAtClinic": "Лабораторијске анализе",
		"MedicationsAtClinic": "Лекови",
		"NoServicesAtClinic": "Тренутно немамо информације о услугама ове клинике",
		"TabAbout": "О клиници",
		"TabContacts": "Контакти",
		"TabReviews": "Рецензије",
		"TabMap": "Локација",
		"SeoTitleDoctors": "{count} лекара",
		"SeoTitleServices": "{count} услуга",
		"SeoDescIntro": "{name} у {city}:",
		"SeoDescMoreSpecialties": "{specialties} и још {count}+ специјалности",
		"SeoDescPriceFrom": "Цијене услуга од {price}€",
		"SeoDescRating": "Оцјена {rating} ★ ({count} рецензија)",
		"SeoDescCta": "Пронађите лекара на Docta.me",
		"ViewAllServices": "Све услуге ({count})",
		"ViewAllLabTests": "Све анализе ({count})",
		"ViewAllMedications": "Сви лекови ({count})",
		"ViewAllDoctors": "Сви лекари ({count})",
		"PopularLabel": "Популарно",
		"ByCategoryLabel": "По категорији",
		"BySpecialtyLabel": "По специјалности"
	}
}
</i18n>

<style lang="less" scoped>
.clinic-services {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xl);
}

.reviews-header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: var(--spacing-md);
	flex-wrap: wrap;
}

.reviews-content {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
}

.clinic-map {
	height: 400px;
	border-radius: var(--border-radius-md);
	overflow: hidden;
	border: 1px solid var(--color-border-light);
}

.empty-state {
	text-align: center;
	padding: 40px;
	color: #6b7280;
}
</style>
