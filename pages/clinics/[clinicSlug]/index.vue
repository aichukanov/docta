<script setup lang="ts">
import type { ClinicServicesMap } from '#components';
import { Clock, Discount } from '@element-plus/icons-vue';
import { formatClinicAddressLine } from '~/common/clinic-address';
import {
	CLINIC_ITEMS_INLINE_THRESHOLD,
	OG_IMAGE,
	REVIEWS_THRESHOLD,
	SITE_NAME,
	SITE_URL,
} from '~/common/constants';
import {
	buildCouponScopePhrase,
	buildCouponTitle,
	getCouponOgImageUrl,
} from '~/common/clinic-coupon';
import { isGonePayload } from '~/common/gone';
import {
	buildBreadcrumbsSchema,
	buildClinicSchema,
} from '~/common/schema-org-builders';
import {
	getCanonicalUrl,
	getRegionalQuery,
	getRegionalUrl,
} from '~/common/url-utils';
import {
	buildSeoDescription,
	fitSeoTitle,
	SEO_DESCRIPTION_MAX_LENGTH,
} from '~/common/seo-meta';
import { getLocalizedName } from '~/common/utils';
import breadcrumbI18n from '~/i18n/breadcrumb';
import cityI18n from '~/i18n/city';
import clinicI18n from '~/i18n/clinic';
import clinicCommonI18n from '~/i18n/clinic-common';
import clinicCouponI18n from '~/i18n/clinic-coupon';
import clinicTypeI18n from '~/i18n/clinic-type';
import labTestCategoryI18n from '~/i18n/labtest-category';
import languageI18n from '~/i18n/language';
import medicalServiceCategoryI18n from '~/i18n/medical-service-category';
import reviewsI18n from '~/i18n/reviews';
import seoDescriptionI18n from '~/i18n/seo-description';
import specialtyI18n from '~/i18n/specialty';
import { combineI18nMessages } from '~/i18n/utils';
import workingHoursI18n from '~/i18n/working-hours';
import type {
	ClinicItemTopEntry,
	ClinicPrice,
	ClinicServiceList,
	LabTestList,
} from '~/interfaces/clinic';
import type { DoctorList } from '~/interfaces/doctor';
import type { WorkingHours } from '~/interfaces/clinic-working-hours';
import { DAYS_OF_WEEK } from '~/interfaces/clinic-working-hours';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		breadcrumbI18n,
		clinicI18n,
		clinicCommonI18n,
		clinicCouponI18n,
		clinicTypeI18n,
		languageI18n,
		cityI18n,
		medicalServiceCategoryI18n,
		specialtyI18n,
		labTestCategoryI18n,
		reviewsI18n,
		workingHoursI18n,
		seoDescriptionI18n,
	]),
});

const route = useRoute();
const clinicSlug = computed(() => route.params.clinicSlug as string);
const clinicId = computed(() => clinicData.value?.id);

const { pending: isLoading, data: clinicPayload } = await useFetch(
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

// Скрытую админом клинику эндпоинт отдаёт маркером `{ gone: true }` вместо
// данных, чтобы страница ответила 410, а не 404 (см. common/gone.ts).
const clinicData = computed(() =>
	isGonePayload(clinicPayload.value) ? null : clinicPayload.value,
);

const { trackEvent } = useAnalytics();

provideAnalyticsEntity(
	computed(() =>
		clinicData.value?.id
			? {
					entity_type: 'clinic' as const,
					entity_id: clinicData.value.id,
					entity_slug: clinicSlug.value,
				}
			: null,
	),
);

if (import.meta.client) {
	const trackClinicView = () => {
		if (!clinicData.value?.id) return;
		trackEvent('entity_viewed', {
			entity_type: 'clinic',
			entity_id: clinicData.value.id,
			entity_slug: clinicSlug.value,
			entity_name: clinicData.value.name,
		});
	};
	// onMounted — первый показ; watch — клиентский переход клиника→клиника,
	// когда компонент страницы переиспользуется без remount
	onMounted(trackClinicView);
	watch(clinicId, (id, prevId) => {
		if (id && id !== prevId) trackClinicView();
	});
}

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
		fetchInlineList<DoctorList>(
			'/api/doctors/list',
			renderInline.value.doctors,
			{
				doctors: [],
				totalCount: 0,
			},
		),
	{ watch: [renderInline, clinicId] },
);

const { data: labTestsList } = await useAsyncData(
	`labtests-list-clinic-${clinicSlug.value}`,
	() =>
		fetchInlineList<LabTestList>(
			'/api/labtests/list',
			renderInline.value.labtests,
			{
				items: [],
				totalCount: 0,
			},
		),
	{ watch: [renderInline, clinicId] },
);

const { data: medicationsList } = await useAsyncData(
	`medications-list-clinic-${clinicSlug.value}`,
	() =>
		fetchInlineList<ClinicServiceList>(
			'/api/medications/list',
			renderInline.value.medications,
			{
				items: [],
				totalCount: 0,
			},
		),
	{ watch: [renderInline, clinicId] },
);

const { data: medicalServicesList } = await useAsyncData(
	`services-list-clinic-${clinicSlug.value}`,
	() =>
		fetchInlineList<ClinicServiceList>(
			'/api/services/list',
			renderInline.value.services,
			{
				items: [],
				totalCount: 0,
			},
		),
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

// Непубличная клиника (скрыта админом или черновик) — такие данные доезжают
// только до владельца и админа
const isNonPublicClinic = computed(
	() =>
		isFound.value &&
		(clinicData.value?.hidden === true ||
			(clinicData.value?.status != null &&
				clinicData.value.status !== 'published')),
);

const localizedName = computed(() =>
	getLocalizedName(clinicData.value, locale.value),
);

// Купон: заголовок таба-секции — сама скидка («Скидка 10% на медицинские
// услуги»), а оговорка про лабораторию нужна только клиникам с анализами
const coupon = computed(() => clinicData.value?.coupon ?? null);
const couponTitle = computed(() =>
	coupon.value ? buildCouponTitle(coupon.value, t, locale.value) : '',
);
// В заголовке таба процент уже стоит в купонном чипе, поэтому рядом — только
// «на что действует», без повтора скидки
const couponScopePhrase = computed(() =>
	coupon.value ? buildCouponScopePhrase(coupon.value, t, locale.value) : '',
);
const hasLabtests = computed(() => totals.value.labtests > 0);

const clinicTypeNames = computed(() => {
	if (!clinicData.value?.clinicTypeIds) return [];
	return clinicData.value.clinicTypeIds
		.split(',')
		.map(Number)
		.filter(Boolean)
		.map((id) => t(`clinic_type_${id}`));
});

// 404 для отсутствующей клиники, 410 — для скрытой администратором
if (!isFound.value) {
	setMissingEntityStatus(clinicPayload.value);
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
	// Купоны — первым табом: единственное на странице, что экономит деньги
	if (coupon.value) {
		result.push({ id: 'coupons', label: t('CouponTab') });
	}
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
	if (!isFound.value || !clinicData.value) {
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

	// У клиник название само по себе бывает под сотню символов («Specijalna
	// bolnica za ortopediju, neurohirurgiju i neurologiju "Vaso Ćuković"»), так
	// что сначала уходит бренд, потом статистика.
	return fitSeoTitle([
		statsParts.length > 0 &&
			`${clinicName} ${city} — ${statsParts.join(', ')} | ${SITE_NAME}`,
		statsParts.length > 0 && `${clinicName} ${city} — ${statsParts.join(', ')}`,
		statsParts.length > 0 && `${clinicName} ${city} — ${statsParts[0]}`,
		`${clinicName} | ${city}`,
		clinicName,
	]);
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

	// Адрес — единственный крупный факт, которого нет в заголовке клиники (там
	// уже стоят город и счётчики врачей/услуг). Дублировать счётчики в описании
	// нельзя: в выдаче заголовок и сниппет стоят рядом, и одни и те же цифры
	// читались бы дважды.
	// Только улица и населённый пункт: город уже стоит в интро, а индекс в
	// сниппете бесполезен — поэтому formatClinicAddressLine (он собирает полную
	// строку с городом и индексом) здесь не подходит.
	const addressLine = [clinicData.value.address, clinicData.value.town]
		.map((part) => (typeof part === 'string' ? part.trim() : ''))
		.filter(Boolean)
		.join(', ');
	if (addressLine) {
		segments.push(addressLine);
	}

	// CTA
	segments.push(t('SeoDescCta'));

	const intro = t('SeoDescIntro', { name: clinicName, city: cityGenitive });

	// Интро заканчивается двоеточием, поэтому в сборку сегментов он не идёт —
	// вместо этого его длина вычитается из бюджета.
	const body = buildSeoDescription(
		segments,
		SEO_DESCRIPTION_MAX_LENGTH - intro.length - 1,
	);

	return `${intro} ${body}`;
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

// Черновик виден только владельцу/админу, скрытая админом клиника — только
// админу; даже им страница отдаётся с noindex
const robotsMeta = computed(() =>
	isFound.value &&
	clinicData.value?.status === 'published' &&
	!clinicData.value?.hidden
		? undefined
		: 'noindex',
);

// Если у клиники есть купон с картинкой, превью ссылки — сам купон: им делятся
// именно ради скидки. Заголовок превью тоже ведёт со скидки, а не с названия
// клиники. На <title> и meta description это не влияет — там SEO-текст.
const couponOgImage = computed(() =>
	coupon.value ? getCouponOgImageUrl(coupon.value, SITE_URL) : null,
);
const ogImageUrl = computed(() => couponOgImage.value ?? OG_IMAGE);
const ogTitleText = computed(() =>
	couponOgImage.value && couponTitle.value
		? `${couponTitle.value} — ${localizedName.value}`
		: pageTitle.value,
);

useSeoMeta({
	title: pageTitle,
	description: pageDescription,
	ogTitle: ogTitleText,
	ogDescription: pageDescription,
	ogImage: ogImageUrl,
	// Размеры проставляем только для купона — он рисуется под 1200×630, и с
	// ними Facebook показывает превью сразу, не дожидаясь своей загрузки
	ogImageWidth: computed(() => (couponOgImage.value ? 1200 : undefined)),
	ogImageHeight: computed(() => (couponOgImage.value ? 630 : undefined)),
	// og:type business.business валиден для Facebook, но отсутствует в union-типе useSeoMeta
	ogType: 'business.business' as 'website',
	twitterCard: computed(() =>
		couponOgImage.value ? 'summary_large_image' : 'summary',
	),
	twitterTitle: ogTitleText,
	twitterDescription: pageDescription,
	twitterImage: ogImageUrl,
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
		const pageUrl = getCanonicalUrl(
			route.path,
			route.query as Record<string, string | string[]>,
			locale.value,
		);
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
				pageUrl,
				getCityName,
				services: schemaServices,
				labTests: schemaLabTests,
				medications: schemaMedications,
				doctors: schemaDoctors,
				workingHours: workingHoursData.value,
				// rating не передаём: API-агрегат включает сторонние отзывы
				// (google_maps и т.п.), а в разметку допустим только рейтинг
				// по собственным docta_me-отзывам — его пока нет на бэкенде
				reviews: displayedReviews.value.map((review) => ({
					id: review.id,
					text: review.text,
					rating: review.rating,
					author: review.author,
					publishedAt: review.publishedAt,
					provider: review.provider,
				})),
			}),
			buildBreadcrumbsSchema(pageUrl, [
				{
					name: t('BreadcrumbHome'),
					url: getRegionalUrl(`${SITE_URL}/`, {}, locale.value),
				},
				{
					name: t('BreadcrumbClinics'),
					url: getRegionalUrl(`${SITE_URL}/clinics`, {}, locale.value),
				},
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
			<!-- Непубличную клинику получают только владелец и админ: баннер
			     объясняет, почему пациенты её не видят. Для админа это
			     единственный признак, что страница скрыта. -->
			<ClinicOwnerBanner
				v-if="clinicData && (clinicData.isOwner || isNonPublicClinic)"
				:status="clinicData.status"
				:hidden="clinicData.hidden"
				:hiddenReason="clinicData.hiddenReason"
				:isOwner="clinicData.isOwner"
			/>
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
			<!-- Coupons -->
			<EntityPageSection v-if="coupon && clinicData" sectionId="coupons">
				<template #icon>
					<el-icon :size="20"><Discount /></el-icon>
				</template>
				<!-- Заголовок = купонный талон + на что действует: «просто скидка» в
				     заголовке читалась как шум, слово «купон» обязательно -->
				<template #title>
					<span class="coupon-title">
						<ClinicCouponBadge :coupon="coupon" :withTooltip="false" />
						<span class="coupon-scope">{{ couponScopePhrase }}</span>
					</span>
				</template>
				<ClinicCouponSection
					:coupon="coupon"
					:clinicId="clinicData.id"
					:clinicSlug="clinicData.slug"
					:clinicName="localizedName"
					:hasLabtests="hasLabtests"
				/>
			</EntityPageSection>

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
				v-if="hasWorkingHours && clinicId != null"
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
							:isOutdated="getClinicPrice(item.clinicPrices)?.isOutdated"
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
							:isOutdated="item.isOutdated"
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
							:isOutdated="getClinicPrice(item.clinicPrices)?.isOutdated"
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
							:isOutdated="item.isOutdated"
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
		"MedicationsAtClinic": "Lijekovi",
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
		"SeoDescCta": "Pronađite ljekara na Docta.me",
		"ViewAllServices": "Sve usluge ({count})",
		"ViewAllLabTests": "Sve analize ({count})",
		"ViewAllMedications": "Svi lijekovi ({count})",
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
		"MedicationsAtClinic": "Лијекови",
		"NoServicesAtClinic": "Тренутно немамо информације о услугама ове клинике",
		"TabAbout": "О клиници",
		"TabContacts": "Контакти",
		"TabReviews": "Рецензије",
		"TabMap": "Локација",
		"SeoTitleDoctors": "{count} љекара",
		"SeoTitleServices": "{count} услуга",
		"SeoDescIntro": "{name} у {city}:",
		"SeoDescMoreSpecialties": "{specialties} и још {count}+ специјалности",
		"SeoDescPriceFrom": "Цијене услуга од {price}€",
		"SeoDescCta": "Пронађите љекара на Docta.me",
		"ViewAllServices": "Све услуге ({count})",
		"ViewAllLabTests": "Све анализе ({count})",
		"ViewAllMedications": "Сви лијекови ({count})",
		"ViewAllDoctors": "Сви љекари ({count})",
		"PopularLabel": "Популарно",
		"ByCategoryLabel": "По категорији",
		"BySpecialtyLabel": "По специјалности"
	}
}
</i18n>

<style lang="less" scoped>
.coupon-title {
	display: inline-flex;
	align-items: center;
	flex-wrap: wrap;
	gap: var(--spacing-sm);
}

/* «на медицинские услуги и анализы» рядом с купонным чипом — обычным весом,
   акцент держит чип */
.coupon-scope {
	font-weight: var(--font-weight-medium);
	color: var(--color-text-secondary);
}

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
