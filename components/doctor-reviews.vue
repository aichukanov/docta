<script setup lang="ts">
import RatingStars from '~/components/rating-stars.vue';
import ReviewProviderIcon from '~/components/review-provider-icon.vue';
import { getRegionalQuery } from '~/common/url-utils';
import reviewsI18n from '~/i18n/reviews';
import type { Rating, Review } from '~/interfaces/review';

const props = withDefaults(
	defineProps<{
		reviews?: Review[];
		rating?: Rating;
		noReviewsText?: string;
		clinicInfo?: Record<number, { name: string; slug: string }>;
	}>(),
	{
		reviews: () => [],
		rating: undefined,
		noReviewsText: undefined,
		clinicInfo: () => ({}),
	},
);

const { t, locale } = useI18n(reviewsI18n);

const PAGE_SIZE = 5;
const visibleCount = ref(PAGE_SIZE);

const visibleReviews = computed(
	() => props.reviews?.slice(0, visibleCount.value) || [],
);

const nextPageSize = computed(() =>
	Math.min(PAGE_SIZE, (props.reviews?.length || 0) - visibleCount.value),
);

const showMore = () => {
	visibleCount.value += PAGE_SIZE;
};

const showingOriginal = ref(new Set<string>());

const isShowingOriginal = (key: string) => showingOriginal.value.has(key);

const toggleOriginal = (key: string) => {
	const next = new Set(showingOriginal.value);
	if (next.has(key)) {
		next.delete(key);
	} else {
		next.add(key);
	}
	showingOriginal.value = next;
};

const getLangName = (langCode?: string) => {
	if (!langCode) return '';
	return langCode.replace(/-.*$/, '').toUpperCase();
};

const formatDate = (dateString: string) => {
	const date = new Date(dateString);
	return date.toLocaleDateString(locale.value, {
		year: 'numeric',
		month: 'long',
		day: 'numeric',
	});
};

const formatRelativeDate = (dateString: string) => {
	const now = Date.now();
	const diff = now - new Date(dateString).getTime();
	const seconds = Math.floor(diff / 1000);
	const minutes = Math.floor(seconds / 60);
	const hours = Math.floor(minutes / 60);
	const days = Math.floor(hours / 24);
	const weeks = Math.floor(days / 7);
	const months = Math.floor(days / 30);
	const years = Math.floor(days / 365);

	const rtf = new Intl.RelativeTimeFormat(locale.value, { numeric: 'auto' });

	if (years > 0) return rtf.format(-years, 'year');
	if (months > 0) return rtf.format(-months, 'month');
	if (weeks > 0) return rtf.format(-weeks, 'week');
	if (days > 0) return rtf.format(-days, 'day');
	if (hours > 0) return rtf.format(-hours, 'hour');
	if (minutes > 0) return rtf.format(-minutes, 'minute');
	return rtf.format(-seconds, 'second');
};

const formatReviewDate = (dateString: string, provider: string) => {
	return provider === 'google_maps'
		? formatRelativeDate(dateString)
		: formatDate(dateString);
};
</script>

<template>
	<div class="doctor-reviews">
		<!-- Рейтинг -->
		<div class="rating-summary" v-if="rating && rating.totalReviews > 0">
			<RatingStars :rating="rating.averageRating" :show-value="true" />
			<span class="reviews-count">
				{{ t('BasedOn', { count: rating.totalReviews }) }}
			</span>
		</div>

		<!-- Список отзывов -->
		<div class="reviews-list" v-if="reviews && reviews.length > 0">
			<div
				v-for="review in visibleReviews"
				:key="review.id"
				class="review-item"
			>
				<div class="review-header">
					<div class="review-author">
						<div class="author-info">
							<div class="author-name">{{
								review.author?.name || t('Anonymous')
							}}</div>
							<div class="review-meta">
								<RatingStars v-if="review.rating" :rating="review.rating" />
								<span class="review-date">{{
									review.publishedAt
										? formatReviewDate(review.publishedAt, review.provider)
										: ''
								}}</span>
								<span
									class="review-provider"
									v-if="review.provider && review.provider !== 'docta_me'"
								>
									<ReviewProviderIcon :provider="review.provider" />
									{{ t(`Provider_${review.provider}`) }}
								</span>
								<NuxtLink
									class="review-clinic"
									v-if="review.clinicId && clinicInfo[review.clinicId]"
									:to="{
										name: 'clinics-clinicSlug',
										params: { clinicSlug: clinicInfo[review.clinicId].slug },
										query: getRegionalQuery(locale),
									}"
								>
									{{ clinicInfo[review.clinicId].name }}
								</NuxtLink>
							</div>
						</div>
					</div>
				</div>

				<div class="review-content">
					<div class="review-text">
						{{
							isShowingOriginal(`review-${review.id}`)
								? review.originalText
								: review.text
						}}
					</div>
					<button
						v-if="review.originalText"
						class="toggle-original-btn"
						@click="toggleOriginal(`review-${review.id}`)"
					>
						{{
							isShowingOriginal(`review-${review.id}`)
								? t('ShowTranslation')
								: t('ShowOriginal', {
										lang: getLangName(review.originalLanguage),
								  })
						}}
					</button>
				</div>

				<!-- Ответы -->
				<div
					class="review-replies"
					v-if="review.replies && review.replies.length > 0"
				>
					<div
						v-for="reply in review.replies"
						:key="reply.id"
						class="reply-item"
					>
						<div class="reply-header">
							<div class="reply-author">
								{{ t(`Replier_${reply.responderType}`) }}
							</div>
							<div class="reply-date" v-if="reply.publishedAt">{{
								formatReviewDate(reply.publishedAt, reply.provider)
							}}</div>
						</div>
						<div class="reply-content">
							{{
								isShowingOriginal(`reply-${reply.id}`)
									? reply.originalText
									: reply.text
							}}
						</div>
						<button
							v-if="reply.originalText"
							class="toggle-original-btn"
							@click="toggleOriginal(`reply-${reply.id}`)"
						>
							{{
								isShowingOriginal(`reply-${reply.id}`)
									? t('ShowTranslation')
									: t('ShowOriginal', {
											lang: getLangName(reply.originalLanguage),
									  })
							}}
						</button>
					</div>
				</div>
			</div>
		</div>

		<!-- Показать ещё -->
		<ShowMoreButton
			v-if="reviews && reviews.length > visibleCount"
			:label="
				t('ShowMore', {
					count: nextPageSize,
					remaining: reviews.length - visibleCount,
				})
			"
			@click="showMore"
		/>

		<!-- Нет отзывов -->
		<div class="no-reviews" v-else-if="!reviews || reviews.length === 0">
			{{ noReviewsText || t('NoReviews') }}
		</div>
	</div>
</template>

<style scoped>
.doctor-reviews {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
}

.rating-summary {
	display: flex;
	align-items: center;
	gap: 0.5rem;
	padding: 1rem;
	background: #f8f9fa;
	border-radius: 8px;
}

.reviews-count {
	font-size: 0.9rem;
	color: #666;
}

.reviews-list {
	display: flex;
	flex-direction: column;
	gap: 1.5rem;
}

.review-item {
	padding: 1.5rem;
	border: 1px solid #e9ecef;
	border-radius: 12px;
	background: #fff;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.review-header {
	display: flex;
	align-items: flex-start;
	gap: 1rem;
	margin-bottom: 1rem;
}

.author-avatar {
	width: 40px;
	height: 40px;
	border-radius: 50%;
	object-fit: cover;
}

.author-avatar-placeholder {
	width: 40px;
	height: 40px;
	border-radius: 50%;
	background: #007bff;
	color: white;
	display: flex;
	align-items: center;
	justify-content: center;
	font-weight: 600;
	font-size: 1.1rem;
}

.author-info {
	flex: 1;
}

.author-name {
	font-weight: 600;
	color: #333;
	margin-bottom: 0.25rem;
}

.review-meta {
	display: flex;
	align-items: center;
	gap: 0.75rem;
	font-size: 0.85rem;
	color: #666;
}

.review-date {
	font-size: 0.85rem;
	color: #666;
}

.review-provider {
	font-size: 0.8rem;
	color: #007bff;
	background: #e7f3ff;
	padding: 0.2rem 0.5rem;
	border-radius: 4px;
	display: inline-flex;
	align-items: center;
	gap: 0.25rem;
}

.review-clinic {
	font-size: 0.85rem;
	color: #007bff;
	text-decoration: none;
}

.review-clinic:hover {
	text-decoration: underline;
}

.review-content {
	margin-bottom: 1rem;
}

.review-text {
	line-height: 1.6;
	color: #333;
	white-space: pre-wrap;
}

.toggle-original-btn {
	display: inline-block;
	margin-top: 0.5rem;
	padding: 0;
	border: none;
	background: none;
	color: #007bff;
	font-size: 0.85rem;
	cursor: pointer;
	text-decoration: none;
}

.toggle-original-btn:hover {
	text-decoration: underline;
}

.review-replies {
	border-top: 1px solid #e9ecef;
	padding-top: 1rem;
	margin-top: 1rem;
}

.reply-item {
	padding: 1rem;
	background: #f8f9fa;
	border-radius: 8px;
	margin-top: 0.5rem;
}

.reply-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 0.5rem;
}

.reply-author {
	font-weight: 600;
	color: #007bff;
	font-size: 0.9rem;
}

.reply-date {
	font-size: 0.8rem;
	color: #666;
}

.reply-content {
	line-height: 1.5;
	color: #333;
	white-space: pre-wrap;
}
</style>
