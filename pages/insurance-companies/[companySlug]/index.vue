<script setup lang="ts">
import type { InsuranceCompanyBranchesMap } from '#components';
import { OG_IMAGE, REVIEWS_THRESHOLD, SITE_URL } from '~/common/constants';
import {
	buildBreadcrumbsSchema,
	buildInsuranceCompanySchema,
} from '~/common/schema-org-builders';
import {
	getCanonicalUrl,
	getRegionalQuery,
	getRegionalUrl,
} from '~/common/url-utils';
import { combineI18nMessages } from '~/i18n/utils';
import breadcrumbI18n from '~/i18n/breadcrumb';
import cityI18n from '~/i18n/city';
import insuranceCompanyI18n from '~/i18n/insurance-company';
import reviewsI18n from '~/i18n/reviews';
import type { InsuranceCompanyData } from '~/interfaces/insurance-company';
import type { Review } from '~/interfaces/review';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		breadcrumbI18n,
		cityI18n,
		insuranceCompanyI18n,
		reviewsI18n,
	]),
});

const route = useRoute();
const companySlug = computed(() => route.params.companySlug as string);

const { pending: isLoading, data: companyData } =
	await useFetch<InsuranceCompanyData | null>(
		'/api/insurance-companies/details',
		{
			// Slug в ключе — иначе переход между компаниями показывает прежнюю,
			// см. комментарий у useFetch в pages/clinics/[clinicSlug]/index.vue.
			key: `insurance-company-details:${companySlug.value}`,
			method: 'POST',
			body: computed(() => ({
				slug: companySlug.value,
				locale: locale.value,
			})),
		},
	);

const isFound = computed(() => companyData.value?.id != null);

if (import.meta.server && !isFound.value) {
	setResponseStatus(useRequestEvent()!, 404);
}

const branches = computed(() => companyData.value?.branches || []);

const branchesLabel = computed(() =>
	t('OfficeCount', { count: branches.value.length }),
);

const tabs = computed(() => {
	const result = [{ id: 'offices', label: t('OfficesTitle') }];
	if (companyData.value) {
		const reviewCount =
			companyData.value.rating?.totalReviews ||
			companyData.value.reviews?.length ||
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

// === Отзывы — та же механика, что на странице клиники ===

const hasSeparateReviewsPage = computed(() => {
	const total =
		companyData.value?.rating?.totalReviews ||
		companyData.value?.reviews?.length ||
		0;
	return total > REVIEWS_THRESHOLD;
});

const allCompanyReviews = computed(() => companyData.value?.reviews || []);

const localOwnReview = ref<Review | null>(null);
const ownReviewDeleted = ref(false);
const showReviewDialog = ref(false);

const ownReview = computed(() => {
	if (ownReviewDeleted.value) return null;
	return (
		localOwnReview.value || allCompanyReviews.value.find((r) => r.isOwn) || null
	);
});
const otherReviews = computed(() =>
	allCompanyReviews.value.filter((r) => !r.isOwn),
);

const displayedReviews = computed(() => {
	if (hasSeparateReviewsPage.value) {
		return otherReviews.value.slice(0, REVIEWS_THRESHOLD);
	}
	return otherReviews.value;
});

const onReviewSubmitted = (review: Review) => {
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
		name: 'insurance-companies-companySlug-reviews',
		params: { companySlug: companySlug.value },
		query: getRegionalQuery(locale.value),
	};
});

// Аналог scrollToMap на странице клиники — открывает попап нужного филиала
// на карте офисов (см. components/insurance-company/branches-map.vue).
const mapRef = ref<InstanceType<typeof InsuranceCompanyBranchesMap> | null>(
	null,
);
const { target: mapSentinel, hasBeenVisible: isMapVisible } = useInViewport();
const pendingMapAction = ref<(() => void) | null>(null);

const onMapReady = () => {
	if (pendingMapAction.value) {
		pendingMapAction.value();
		pendingMapAction.value = null;
	}
};

const scrollToMap = (branch: (typeof branches.value)[number]) => {
	const el = document.getElementById('map');
	if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' });

	const action = () => mapRef.value?.openBranchPopup(branch);
	if (mapRef.value) {
		action();
	} else {
		pendingMapAction.value = action;
		isMapVisible.value = true;
	}
};

// У несуществующей компании заголовок и описание — про ошибку, а не пустая
// строка и описание листинга: пустой <title> нечего показать в выдаче, а
// описание листинга делало из 404 «валидную» страницу-дубль каталога.
const pageTitle = computed(() => {
	if (!isFound.value || !companyData.value) {
		return t('InsuranceCompanyNotFound');
	}
	return companyData.value.name;
});

const pageDescription = computed(() => {
	if (!isFound.value || !companyData.value) {
		return t('InsuranceCompanyNotFound');
	}
	return t('InsuranceCompanyPageDescription', { name: companyData.value.name });
});

// Единственная из шести детальных страниц, где noindex не стоял: страница
// несуществующей компании индексировалась как обычная
const robotsMeta = computed(() => (isFound.value ? undefined : 'noindex'));

const getCityName = (id: number): string | undefined => {
	const key = `city_${id}`;
	const value = t(key);
	return value && value !== key ? value : undefined;
};

useSeoMeta({
	title: pageTitle,
	description: pageDescription,
	ogTitle: pageTitle,
	ogDescription: pageDescription,
	ogImage: OG_IMAGE,
	// Дефолтная og:image теперь 1200×630 — формат большой карточки
	twitterCard: 'summary_large_image',
	twitterTitle: pageTitle,
	twitterDescription: pageDescription,
	twitterImage: OG_IMAGE,
	robots: robotsMeta,
});

const schemaOrgStore = useSchemaOrgStore();

watchEffect(() => {
	if (!companyData.value || !isFound.value) return;

	const pageUrl = getCanonicalUrl(
		route.path,
		route.query as Record<string, string | string[]>,
		locale.value,
	);

	// BreadcrumbList вернулась: AppBreadcrumbs теперь рисуется в EntityPage из
	// этой же разметки, то есть крошки на странице видны и расхождения
	// «размечено, но не показано» больше нет.
	schemaOrgStore.setSchemas([
		buildBreadcrumbsSchema(pageUrl, [
			{
				name: t('BreadcrumbHome'),
				url: getRegionalUrl(`${SITE_URL}/`, {}, locale.value),
			},
			{
				name: t('BreadcrumbInsuranceCompanies'),
				url: getRegionalUrl(
					`${SITE_URL}/insurance-companies`,
					{},
					locale.value,
				),
			},
			{ name: companyData.value.name },
		]),
		...buildInsuranceCompanySchema({
			siteUrl: SITE_URL,
			company: companyData.value,
			locale: locale.value,
			pageTitle: pageTitle.value,
			pageDescription: pageDescription.value,
			pageUrl,
			getCityName,
			// aggregateRating не передаём: API-агрегат может включать сторонние
			// отзывы, в разметку идут только собственные docta_me
			// (см. buildSchemaReviews и комментарий на странице клиники)
			reviews: displayedReviews.value.map((review) => ({
				id: review.id,
				text: review.text,
				rating: review.rating,
				author: review.author,
				publishedAt: review.publishedAt,
				provider: review.provider,
			})),
		}),
	]);
});
</script>

<template>
	<EntityPage
		:isLoading="isLoading || false"
		:isFound="isFound"
		backRouteName="insurance-companies"
		:loadingText="t('InsuranceCompanyLoading')"
		:notFoundText="t('InsuranceCompanyNotFound')"
		:tabs="tabs"
	>
		<template #hero>
			<InsuranceCompanyHero
				v-if="companyData"
				:company="companyData"
				:branchesLabel="branchesLabel"
			/>
		</template>

		<template #sections>
			<EntityPageSection sectionId="offices" :title="t('OfficesTitle')">
				<template #icon
					><IconMapPin :size="20" color="var(--kit-color-text-on-solid)"
				/></template>
				<div class="insurance-branches-list">
					<InsuranceCompanyBranchItem
						v-for="branch in branches"
						:key="branch.id"
						:branch="branch"
						:companyPhone="companyData?.phone"
						:companyEmail="companyData?.email"
						@showOnMap="scrollToMap(branch)"
					/>
				</div>
			</EntityPageSection>

			<EntityPageSection
				v-if="
					companyData &&
					(companyData.website || companyData.phone || companyData.email)
				"
				sectionId="contacts"
				:title="t('ContactsTitle')"
			>
				<template #icon
					><IconPhone :size="20" color="var(--kit-color-text-on-solid)"
				/></template>
				<ContactsList :list="companyData" />
			</EntityPageSection>

			<!-- Reviews -->
			<EntityPageSection v-if="companyData" sectionId="reviews">
				<div class="reviews-header">
					<EntityPageSectionTitle :title="t('TabReviews')">
						<template #icon><IconStar :size="20" /></template>
					</EntityPageSectionTitle>
					<ViewAllLink
						v-if="allReviewsLink && companyData.rating"
						:to="allReviewsLink"
						:label="t('AllReviews', { count: companyData.rating.totalReviews })"
					/>
				</div>
				<div class="reviews-content">
					<RatingSummary
						v-if="companyData.rating"
						:rating="companyData.rating"
						:hideWriteButton="!!ownReview"
						@writeReview="showReviewDialog = true"
					/>
					<ReviewItem
						v-if="ownReview"
						:review="ownReview"
						@updated="(r) => (localOwnReview = r)"
						@deleted="onReviewDeleted"
					/>
					<DoctorReviews :reviews="displayedReviews" />
				</div>
				<ReviewForm
					v-if="companyData.id"
					v-model="showReviewDialog"
					entityType="insurance_company"
					:entityId="companyData.id"
					:entityName="companyData.name"
					@submitted="onReviewSubmitted"
				/>
			</EntityPageSection>

			<EntityPageSection sectionId="map" :title="t('TabMap')">
				<template #icon
					><IconMapPin :size="20" color="var(--kit-color-text-on-solid)"
				/></template>
				<div ref="mapSentinel" class="insurance-map">
					<InsuranceCompanyBranchesMap
						v-if="isMapVisible"
						ref="mapRef"
						:branches="branches"
						:companyPhone="companyData?.phone"
						@ready="onMapReady"
					/>
				</div>
			</EntityPageSection>
		</template>
	</EntityPage>
</template>

<style scoped lang="less">
.insurance-branches-list {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(min(380px, 100%), 1fr));
	gap: var(--kit-spacing-md);
}

.reviews-header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: var(--kit-spacing-md);
	flex-wrap: wrap;
}

.reviews-content {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-lg);
}

.insurance-map {
	width: 100%;
	height: 500px;
}
</style>
