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

// SEO
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

// Schema.org
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

const onSortChange = (sort: string) => {
	router.push({
		query: {
			...route.query,
			sort: sort !== 'rank' ? sort : undefined,
			page: undefined, // reset to page 1
		},
	});
	window.scrollTo({ top: 0, behavior: 'smooth' });
};

const onPageChange = (page: number) => {
	router.push({
		query: {
			...route.query,
			page: page > 1 ? page.toString() : undefined,
		},
	});
	window.scrollTo({ top: 0, behavior: 'smooth' });
};
</script>

<template>
	<div class="reviews-page">
		<!-- Breadcrumbs -->
		<nav class="breadcrumbs" aria-label="breadcrumb">
			<NuxtLink to="/" :query="getRegionalQuery(locale)">{{
				t('BreadcrumbHome')
			}}</NuxtLink>
			<span class="separator">/</span>
			<NuxtLink
				:to="{ name: parentListRouteName, query: getRegionalQuery(locale) }"
				>{{ t(breadcrumbParentKey) }}</NuxtLink
			>
			<span class="separator">/</span>
			<NuxtLink
				:to="{
					name: entityRouteName,
					params: { [entityRouteParam]: entitySlug },
					query: getRegionalQuery(locale),
				}"
				>{{ entityName }}</NuxtLink
			>
			<span class="separator">/</span>
			<span class="current">{{ t('BreadcrumbReviews') }}</span>
		</nav>

		<h1 class="reviews-page-title">
			{{ t('ReviewsPageTitle', { name: entityName }) }}
		</h1>

		<!-- Badges (specialties, clinic types, etc.) -->
		<div v-if="$slots.badges" class="reviews-page-badges">
			<slot name="badges" />
		</div>

		<!-- Rating summary + write button -->
		<RatingSummary
			v-if="rating && rating.totalReviews > 0"
			:rating="rating"
			:hideWriteButton="!!currentOwnReview"
			@writeReview="showReviewDialog = true"
		/>

		<!-- Own review (pinned, outside pagination) -->
		<section v-if="currentOwnReview" class="own-review-section">
			<ReviewItem
				:review="currentOwnReview"
				@updated="(r) => localOwnReview = r"
				@deleted="onReviewDeleted"
			/>
		</section>

		<!-- Other reviews -->
		<section class="other-reviews-section">
			<div class="reviews-sort">
				<el-select
					:modelValue="currentSort"
					@update:modelValue="onSortChange"
					size="default"
					:aria-label="t('SortLabel')"
				>
					<el-option value="rank" :label="t('SortRank')" />
					<el-option value="newest" :label="t('SortNewest')" />
					<el-option value="oldest" :label="t('SortOldest')" />
					<el-option value="rating_high" :label="t('SortRatingHigh')" />
					<el-option value="rating_low" :label="t('SortRatingLow')" />
				</el-select>
			</div>

			<DoctorReviews :reviews="reviews" :clinicInfo="clinicInfo" />
		</section>

		<!-- Review form dialog -->
		<ReviewForm
			v-if="entityId"
			v-model="showReviewDialog"
			:entityType="entityType as 'doctor' | 'clinic'"
			:entityId="entityId"
			:entityName="entityName"
			:relatedEntities="relatedEntities"
			@submitted="onReviewSubmitted"
		/>

		<!-- Pagination -->
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

<style scoped>
.reviews-page {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
	max-width: 800px;
	min-width: 0;
	width: 100%;
	margin: 0 auto;
	padding: var(--spacing-lg);
	box-sizing: border-box;
}

.breadcrumbs {
	display: flex;
	align-items: center;
	gap: var(--spacing-sm);
	font-size: var(--font-size-sm);
	color: var(--color-text-muted);
	flex-wrap: wrap;
}

.breadcrumbs a {
	color: var(--color-text-muted);
	text-decoration: none;
}

.breadcrumbs a:hover {
	color: var(--color-primary);
	text-decoration: underline;
}

.breadcrumbs .separator {
	color: var(--color-text-light);
}

.breadcrumbs .current {
	color: var(--color-text-secondary);
	font-weight: var(--font-weight-medium);
}

.reviews-page-title {
	font-size: 1.5rem;
	font-weight: var(--font-weight-bold);
	color: var(--color-text-heading);
}

.reviews-page-badges {
	display: flex;
	flex-wrap: wrap;
	gap: var(--spacing-xs);
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
</style>
