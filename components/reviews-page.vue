<script setup lang="ts">
import { OG_IMAGE, SITE_URL } from '~/common/constants';
import {
	buildBreadcrumbsSchema,
	buildWebPageSchema,
} from '~/common/schema-org-builders';
import { getRegionalQuery } from '~/common/url-utils';
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

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([breadcrumbI18n, reviewsI18n]),
});

const route = useRoute();
const router = useRouter();

const entityUrl = computed(
	() => `${SITE_URL}/${props.entityType}s/${props.entitySlug}`,
);
const reviewsUrl = computed(() => `${entityUrl.value}/reviews`);
const langQuery = computed(() => {
	const q = getRegionalQuery(locale.value);
	return q.lang ? `lang=${q.lang}` : '';
});

const canonicalUrl = computed(() => {
	const params = [
		langQuery.value,
		props.pagination.page > 1 ? `page=${props.pagination.page}` : '',
	]
		.filter(Boolean)
		.join('&');
	return params ? `${reviewsUrl.value}?${params}` : reviewsUrl.value;
});

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
	twitterCard: 'summary',
	twitterTitle: pageTitle,
	twitterDescription: pageDescription,
	twitterImage: OG_IMAGE,
});

const buildReviewsLink = (page?: number) => {
	const params = [langQuery.value, page && page > 1 ? `page=${page}` : '']
		.filter(Boolean)
		.join('&');
	return params ? `${reviewsUrl.value}?${params}` : reviewsUrl.value;
};

const headLinks = computed(() => {
	const links: Array<{ key?: string; rel: string; href: string }> = [
		{ key: 'canonical', rel: 'canonical', href: canonicalUrl.value },
	];
	if (props.pagination.page > 1) {
		links.push({
			rel: 'prev',
			href: buildReviewsLink(props.pagination.page - 1),
		});
	}
	if (props.pagination.page < props.pagination.totalPages) {
		links.push({
			rel: 'next',
			href: buildReviewsLink(props.pagination.page + 1),
		});
	}
	return links;
});

useHead({ link: headLinks });

const schemaOrgStore = useSchemaOrgStore();

watchEffect(() => {
	if (!props.reviews?.length) return;

	const reviewSchemas = props.reviews
		.filter((r) => r.text)
		.map((review) => ({
			'@type': 'Review' as const,
			'author': review.author
				? {
						'@type': 'Person' as const,
						'name': review.author.name,
					}
				: undefined,
			'reviewRating': review.rating
				? {
						'@type': 'Rating' as const,
						'ratingValue': review.rating,
					}
				: undefined,
			'reviewBody': review.text,
			'datePublished': review.publishedAt || undefined,
			'provider': {
				'@type': 'Organization' as const,
				'name': review.provider,
			},
		}));

	const aggregateRating =
		props.rating && props.rating.averageRating && props.rating.totalReviews > 0
			? {
					'@type': 'AggregateRating' as const,
					'ratingValue': props.rating.averageRating.toFixed(1),
					'reviewCount': props.rating.totalReviews,
				}
			: undefined;

	const reviewedEntity = {
		'@type': props.schemaOrgType,
		'@id': `${entityUrl.value}#${props.schemaOrgFragment}`,
		'mainEntityOfPage': entityUrl.value,
		'name': props.entityName,
		aggregateRating,
		'review': reviewSchemas.length > 0 ? reviewSchemas : undefined,
	};

	schemaOrgStore.setSchemas([
		buildWebPageSchema({
			url: reviewsUrl.value,
			locale: locale.value,
			name: pageTitle.value,
			description: pageDescription.value,
			mainEntityId: reviewedEntity['@id'] as string,
		}),
		reviewedEntity,
		buildBreadcrumbsSchema(reviewsUrl.value, [
			{ name: t('BreadcrumbHome'), url: `${SITE_URL}/` },
			{
				name: t(props.breadcrumbParentKey),
				url: `${SITE_URL}/${props.entityType}s`,
			},
			{ name: props.entityName, url: entityUrl.value },
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

		<section v-if="currentOwnReview" class="own-review-section">
			<ReviewItem
				:review="currentOwnReview"
				@updated="(r) => (localOwnReview = r)"
				@deleted="onReviewDeleted"
			/>
		</section>

		<section class="other-reviews-section">
			<div class="reviews-sort">
				<el-select-v2
					:modelValue="currentSort"
					:options="sortOptions"
					:placeholder="t('SortLabel')"
					:aria-label="t('SortLabel')"
					size="large"
					class="sort-select"
					@update:modelValue="onSortChange"
				/>
			</div>

			<el-empty
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
			align="center"
			@update:current-page="onPageChange"
		/>
	</div>
</template>

<style lang="less" scoped>
.reviews-page {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xl);
	max-width: 1100px;
	width: 100%;
	margin: 0 auto;
	padding: var(--spacing-xl);
	box-sizing: border-box;
}

.own-review-section {
	padding-bottom: var(--spacing-lg);
	border-bottom: var(--border-width-thin) solid var(--color-border-secondary);
}

.other-reviews-section {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
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
		padding: var(--spacing-md);
		gap: var(--spacing-lg);
	}
}
</style>
