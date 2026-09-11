<script setup lang="ts">
import { OG_IMAGE, SITE_URL } from '~/common/constants';
import {
	buildBreadcrumbsSchema,
	buildSchemaReviews,
	buildWebPageSchema,
} from '~/common/schema-org-builders';
import {
	getCanonicalPath,
	getCanonicalUrl,
	getRegionalQuery,
	getRegionalUrl,
} from '~/common/url-utils';
import type { ReviewFormEntity } from '~/components/review/form.vue';
import breadcrumbI18n from '~/i18n/breadcrumb';
import reviewsI18n from '~/i18n/reviews';
import { combineI18nMessages } from '~/i18n/utils';
import type { Rating, Review } from '~/interfaces/review';

const props = defineProps<{
	/** 'doctor' | 'clinic' */
	entityType: string;
	entitySlug: string;
	entityName: string;
	rating: Rating;
	reviews: Review[];
	pagination: {
		page: number;
		pageSize: number;
		totalReviews: number;
		totalPages: number;
	};
	/** Schema.org @type for the entity, e.g. 'Physician' */
	schemaOrgType: string;
	/** Schema.org fragment, e.g. 'physician' */
	schemaOrgFragment: string;
	/** i18n key for breadcrumb parent, e.g. 'BreadcrumbDoctors' */
	breadcrumbParentKey: string;
	/** Route name for the parent list page, e.g. 'doctors' */
	parentListRouteName: string;
	/** Route name for the entity page, e.g. 'doctors-doctorSlug' */
	entityRouteName: string;
	/** Route param name, e.g. 'doctorSlug' */
	entityRouteParam: string;
	clinicInfo?: Record<number, { name: string; slug: string }>;
	/** Database ID of the entity, for review form */
	entityId?: number;
	/** User's own review, returned separately from paginated list */
	ownReview?: Review | null;
	/** Related entities for review form selector */
	relatedEntities?: ReviewFormEntity[];
}>();

const localOwnReview = ref<Review | null>(null);
const ownReviewDeleted = ref(false);
const showReviewDialog = ref(false);

const currentOwnReview = computed(() => {
	if (ownReviewDeleted.value) return null;
	return localOwnReview.value || props.ownReview || null;
});

const onReviewSubmitted = (review: Review) => {
	localOwnReview.value = review;
	ownReviewDeleted.value = false;
};

const onReviewDeleted = () => {
	localOwnReview.value = null;
	ownReviewDeleted.value = true;
};

const { uiText } = useUiText();

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([breadcrumbI18n, reviewsI18n]),
});

const route = useRoute();
const router = useRouter();

const entityUrl = computed(
	() => `${SITE_URL}/${props.entityType}s/${props.entitySlug}`,
);
/*
 * Адрес N-й страницы отзывов — общей канонической функцией, как везде.
 *
 * Раньше здесь была своя склейка, и она расходилась с остальным сайтом
 * дважды. По порядку параметров: отзывы канонизировались в `?lang=ru&page=2`,
 * все прочие страницы — в `?page=2&lang=ru`, хотя hreflang им обеим ставил
 * `app.vue` в канонической форме — то есть self-canonical и языковые версии
 * указывали на разные адреса одной страницы. И по составу: `?sort=` из
 * canonical выбрасывался, так что `?sort=rating_low&page=2` канонизировалась
 * в `?page=2` — страницу с ДРУГИМИ отзывами. Именно ради этого случая `sort`
 * и внесён в allowlist (`common/url-utils.ts`).
 */
const buildPageQuery = (page: number) => ({
	...route.query,
	page: page > 1 ? String(page) : undefined,
});

/** Абсолютный — для rel=prev/next и для schema.org. */
const buildPageUrl = (page: number) =>
	getCanonicalUrl(route.path, buildPageQuery(page), locale.value);

/**
 * Он же без домена — для href номеров пагинации. Ссылки нужны краулеру:
 * `el-pagination` рисовал номера как `<li>`, и вторая страница отзывов была
 * достижима только исполнением JS (FR-10 в prd/element-plus-removal).
 */
const buildPageHref = (page: number) =>
	getCanonicalPath(route.path, buildPageQuery(page), locale.value);

const canonicalUrl = computed(() => buildPageUrl(props.pagination.page));

const pageTitle = computed(() => {
	const title = t('ReviewsPageTitle', { name: props.entityName });
	if (props.pagination.totalPages > 1 && props.pagination.page > 1) {
		return `${title} — ${t('PageOf', {
			page: props.pagination.page,
			total: props.pagination.totalPages,
		})}`;
	}
	return title;
});

const pageDescription = computed(() => {
	const { rating } = props;
	if (!rating) return '';
	return t('ReviewsPageDescription', {
		name: props.entityName,
		count: rating.totalReviews,
		rating: rating.averageRating?.toFixed(1) || '—',
	});
});

useSeoMeta({
	title: pageTitle,
	description: pageDescription,
	ogTitle: pageTitle,
	ogDescription: pageDescription,
	ogImage: OG_IMAGE,
	ogType: 'website',
	// Дефолтная og:image теперь 1200×630 — формат большой карточки
	twitterCard: 'summary_large_image',
	twitterTitle: pageTitle,
	twitterDescription: pageDescription,
	twitterImage: OG_IMAGE,
});

/*
 * Canonical эта страница больше НЕ регистрирует: он ставится в `app.vue` той
 * же `getCanonicalUrl` из тех же route.path и route.query. Пока дубликат тут
 * жил, он молча выигрывал у общего (одинаковый ключ, дочерний setup позже) —
 * и вместе с ним выигрывали обе его ошибки.
 */
const headLinks = computed(() => {
	const links: Array<{ rel: string; href: string }> = [];
	if (props.pagination.page > 1) {
		links.push({ rel: 'prev', href: buildPageUrl(props.pagination.page - 1) });
	}
	if (props.pagination.page < props.pagination.totalPages) {
		links.push({ rel: 'next', href: buildPageUrl(props.pagination.page + 1) });
	}
	return links;
});

useHead({ link: headLinks });

const schemaOrgStore = useSchemaOrgStore();

watchEffect(() => {
	if (!props.reviews?.length) return;

	// В разметку попадают только собственные docta_me-отзывы, и только валидные
	// (author + reviewRating обязательны у Google) — см. buildSchemaReviews.
	// aggregateRating не выводим, пока API-агрегат считает и сторонние отзывы
	// (google_maps и т.п.) — см. SCHEMA_REVIEWS_PROVIDER в schema-org-builders.ts
	const reviewSchemas = buildSchemaReviews(props.reviews);

	const reviewedEntity = {
		'@type': props.schemaOrgType,
		'@id': `${entityUrl.value}#${props.schemaOrgFragment}`,
		'mainEntityOfPage': entityUrl.value,
		'name': props.entityName,
		'review': reviewSchemas,
	};

	schemaOrgStore.setSchemas([
		buildWebPageSchema({
			url: canonicalUrl.value,
			locale: locale.value,
			name: pageTitle.value,
			description: pageDescription.value,
			mainEntityId: reviewedEntity['@id'] as string,
		}),
		reviewedEntity,
		buildBreadcrumbsSchema(canonicalUrl.value, [
			{
				name: t('BreadcrumbHome'),
				url: getRegionalUrl(`${SITE_URL}/`, {}, locale.value),
			},
			{
				name: t(props.breadcrumbParentKey),
				url: getRegionalUrl(
					`${SITE_URL}/${props.entityType}s`,
					{},
					locale.value,
				),
			},
			{
				name: props.entityName,
				url: getRegionalUrl(entityUrl.value, {}, locale.value),
			},
			{ name: t('BreadcrumbReviews') },
		]),
	]);
});

const currentSort = computed(() => (route.query.sort as string) || 'rank');

const SORT_OPTIONS = [
	{ value: 'rank', labelKey: 'SortRank' },
	{ value: 'newest', labelKey: 'SortNewest' },
	{ value: 'oldest', labelKey: 'SortOldest' },
	{ value: 'rating_high', labelKey: 'SortRatingHigh' },
	{ value: 'rating_low', labelKey: 'SortRatingLow' },
] as const;

const sortOptions = computed(() =>
	SORT_OPTIONS.map((o) => ({ value: o.value, label: t(o.labelKey) })),
);

const onSortChange = (sort: string) => {
	router.push({
		query: {
			...route.query,
			sort: sort && sort !== 'rank' ? sort : undefined,
			page: undefined,
		},
	});
	if (import.meta.client) {
		window.scrollTo({ top: 0, behavior: 'smooth' });
	}
};

const onPageChange = (page: number) => {
	router.push({
		query: {
			...route.query,
			page: page > 1 ? page.toString() : undefined,
		},
	});
	if (import.meta.client) {
		window.scrollTo({ top: 0, behavior: 'smooth' });
	}
};

const homeLink = computed(() => ({
	path: '/',
	query: getRegionalQuery(locale.value),
}));
const parentLink = computed(() => ({
	name: props.parentListRouteName,
	query: getRegionalQuery(locale.value),
}));
const entityLink = computed(() => ({
	name: props.entityRouteName,
	params: { [props.entityRouteParam]: props.entitySlug },
	query: getRegionalQuery(locale.value),
}));

const breadcrumbs = computed(() => [
	{ label: t('BreadcrumbHome'), to: homeLink.value },
	{ label: t(props.breadcrumbParentKey), to: parentLink.value },
	{ label: props.entityName, to: entityLink.value },
	{ label: t('BreadcrumbReviews') },
]);

const totalReviewsCount = computed(
	() => props.rating?.totalReviews ?? props.pagination.totalReviews ?? 0,
);
</script>

<template>
	<div class="reviews-page">
		<ClinicItemsPageHeader
			:breadcrumbs="breadcrumbs"
			:title="t('ReviewsPageTitle', { name: entityName })"
			:count="totalReviewsCount"
		>
			<template v-if="$slots.badges" #badges>
				<slot name="badges" />
			</template>
		</ClinicItemsPageHeader>

		<RatingSummary
			v-if="rating && rating.totalReviews > 0"
			:rating="rating"
			:hideWriteButton="!!currentOwnReview"
			@writeReview="showReviewDialog = true"
		/>

		<ReviewAiSummary
			v-if="entityId"
			:entityType="entityType as 'doctor' | 'clinic'"
			:entityId="entityId"
		/>

		<section v-if="currentOwnReview" class="own-review-section">
			<ReviewItem
				:review="currentOwnReview"
				@updated="(r) => (localOwnReview = r)"
				@deleted="onReviewDeleted"
			/>
		</section>

		<section class="other-reviews-section">
			<div class="reviews-sort">
				<KitSelect
					:modelValue="currentSort"
					:options="sortOptions"
					:placeholder="t('SortLabel')"
					:aria-label="t('SortLabel')"
					:no-data-text="uiText('NothingFound')"
					size="large"
					class="sort-select"
					@update:modelValue="(value) => onSortChange(String(value ?? ''))"
				/>
			</div>

			<KitEmpty
				v-if="reviews.length === 0 && !currentOwnReview"
				:description="t('NoReviews')"
			/>
			<DoctorReviews v-else :reviews="reviews" :clinicInfo="clinicInfo" />
		</section>

		<ReviewForm
			v-if="entityId"
			v-model="showReviewDialog"
			:entityType="entityType as 'doctor' | 'clinic'"
			:entityId="entityId"
			:entityName="entityName"
			:relatedEntities="relatedEntities"
			@submitted="onReviewSubmitted"
		/>

		<Pagination
			v-if="pagination.totalPages > 1"
			:total="pagination.totalReviews"
			:currentPage="pagination.page"
			:pageSize="pagination.pageSize"
			:href="buildPageHref"
			align="center"
			@update:current-page="onPageChange"
		/>
	</div>
</template>

<style lang="less" scoped>
.reviews-page {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-xl);
	max-width: 1100px;
	width: 100%;
	margin: 0 auto;
	padding: var(--kit-spacing-xl);
	box-sizing: border-box;
}

.own-review-section {
	padding-bottom: var(--kit-spacing-lg);
	border-bottom: var(--kit-border-width-thin) solid
		var(--kit-color-border-secondary);
}

.other-reviews-section {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-lg);
}

.reviews-sort {
	display: flex;
	justify-content: flex-end;
}

.sort-select {
	width: 240px;
	max-width: 100%;
}

@media (max-width: 640px) {
	.reviews-page {
		padding: var(--kit-spacing-md);
		gap: var(--kit-spacing-lg);
	}
}
</style>
