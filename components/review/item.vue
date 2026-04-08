<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import RatingStars from '~/components/rating-stars.vue';
import ReviewProviderIcon from '~/components/review-provider-icon.vue';
import reviewsI18n from '~/i18n/reviews';
import { combineI18nMessages } from '~/i18n/utils';
import type { Review } from '~/interfaces/review';

const props = defineProps<{
	review: Review;
	clinicInfo?: Record<number, { name: string; slug: string }>;
}>();

const emit = defineEmits<{
	updated: [review: Review];
	deleted: [];
}>();

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([reviewsI18n]),
});

const { confirm } = useConfirm();

const isEditing = ref(false);
const editRating = ref(0);
const editText = ref('');
const isSaving = ref(false);
const isDeleting = ref(false);

const startEdit = () => {
	editRating.value = props.review.rating || 0;
	editText.value = props.review.text;
	isEditing.value = true;
};

const cancelEdit = () => {
	isEditing.value = false;
};

const saveEdit = async () => {
	if (!editRating.value) return;
	try {
		isSaving.value = true;
		await $fetch('/api/reviews/edit', {
			method: 'POST',
			body: {
				reviewId: props.review.id,
				rating: editRating.value,
				text: editText.value.trim(),
				locale: locale.value,
			},
		});
		isEditing.value = false;
		emit('updated', {
			...props.review,
			rating: editRating.value,
			text: editText.value.trim(),
			updatedAt: new Date().toISOString(),
		});
	} catch {
		// error handling can be added later
	} finally {
		isSaving.value = false;
	}
};

const handleDelete = async () => {
	const confirmed = await confirm({
		title: t('DeleteReview'),
		message: t('ConfirmDeleteReview'),
		confirmText: t('DeleteReview'),
		cancelText: t('CancelEdit'),
		confirmType: 'danger',
	});
	if (!confirmed) return;
	try {
		isDeleting.value = true;
		await $fetch('/api/reviews/delete', {
			method: 'POST',
			body: { reviewId: props.review.id },
		});
		emit('deleted');
	} catch {
		// error handling can be added later
	} finally {
		isDeleting.value = false;
	}
};

const formatReviewDate = (dateString: string, provider: string) => {
	if (provider === 'google_maps') {
		const now = Date.now();
		const diff = now - new Date(dateString).getTime();
		const days = Math.floor(diff / 86_400_000);
		const weeks = Math.floor(days / 7);
		const months = Math.floor(days / 30);
		const years = Math.floor(days / 365);
		const rtf = new Intl.RelativeTimeFormat(locale.value, { numeric: 'auto' });
		if (years > 0) return rtf.format(-years, 'year');
		if (months > 0) return rtf.format(-months, 'month');
		if (weeks > 0) return rtf.format(-weeks, 'week');
		if (days > 0) return rtf.format(-days, 'day');
		return rtf.format(0, 'day');
	}
	return new Date(dateString).toLocaleDateString(locale.value, {
		year: 'numeric',
		month: 'long',
		day: 'numeric',
	});
};

const clinic = computed(() => {
	const id = props.review.clinicId;
	return id && props.clinicInfo ? props.clinicInfo[id] : undefined;
});
</script>

<template>
	<article class="review-item" :class="{ 'is-own': review.isOwn }">
		<!-- Header -->
		<header class="review-header">
			<div class="author-info">
				<span class="author-name">
					{{ review.author?.name || t('Anonymous') }}
				</span>
				<span v-if="review.isOwn" class="own-badge">{{ t('YourReviewLabel') }}</span>
			</div>
			<div class="review-meta">
				<RatingStars v-if="review.rating && !isEditing" :rating="review.rating" />
				<time
					class="review-date"
					v-if="review.publishedAt"
					:datetime="review.publishedAt"
				>
					{{ formatReviewDate(review.publishedAt, review.provider) }}
				</time>
				<span
					class="review-provider"
					v-if="review.provider && review.provider !== 'docta_me'"
				>
					<ReviewProviderIcon :provider="review.provider" />
					{{ t(`Provider_${review.provider}`) }}
				</span>
				<NuxtLink
					v-if="clinic"
					class="review-clinic"
					:to="{
						name: 'clinics-clinicSlug',
						params: { clinicSlug: clinic.slug },
						query: getRegionalQuery(locale),
					}"
				>
					{{ clinic.name }}
				</NuxtLink>
			</div>
		</header>

		<!-- Edit mode -->
		<template v-if="isEditing">
			<div class="edit-form">
				<ReviewRatingInput v-model="editRating" />
				<el-input
					v-model="editText"
					type="textarea"
					:rows="4"
					:maxlength="5000"
					show-word-limit
				/>
				<div class="edit-actions">
					<el-button type="primary" size="small" :loading="isSaving" @click="saveEdit">
						{{ t('SaveReview') }}
					</el-button>
					<el-button size="small" @click="cancelEdit">
						{{ t('CancelEdit') }}
					</el-button>
				</div>
			</div>
		</template>

		<!-- View mode -->
		<template v-else>
			<!-- Text -->
			<ReviewText
				:text="review.text"
				:originalText="review.originalText"
				:originalLanguage="review.originalLanguage"
			/>

			<!-- Replies -->
			<div
				class="review-replies"
				v-if="review.replies && review.replies.length > 0"
			>
				<ReviewReply
					v-for="reply in review.replies"
					:key="reply.id"
					:reply="reply"
				/>
			</div>

			<!-- Own review actions -->
			<div v-if="review.isOwn" class="own-actions">
				<el-button size="small" @click="startEdit">
					{{ t('EditReview') }}
				</el-button>
				<el-button
					size="small"
					type="danger"
					plain
					:loading="isDeleting"
					@click="handleDelete"
				>
					{{ t('DeleteReview') }}
				</el-button>
			</div>
		</template>
	</article>
</template>

<style scoped>
.review-item {
	width: 100%;
	box-sizing: border-box;
	padding: var(--spacing-xl);
	border: var(--border-width-thin) solid var(--color-border-secondary);
	border-radius: var(--border-radius-xl);
	background: var(--color-bg-primary);
	box-shadow: var(--shadow-sm);
}

.review-item.is-own {
	border-color: var(--color-primary);
}

.review-header {
	margin-bottom: var(--spacing-lg);
}

.author-info {
	display: flex;
	align-items: center;
	gap: var(--spacing-sm);
	margin-bottom: var(--spacing-xs);
}

.author-name {
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-primary);
}

.own-badge {
	font-size: var(--font-size-sm);
	font-weight: var(--font-weight-medium);
	color: var(--color-primary);
	background: var(--color-primary-bg);
	padding: 0.1rem 0.5rem;
	border-radius: var(--border-radius-sm);
}

.review-meta {
	display: flex;
	align-items: center;
	gap: var(--spacing-md);
	font-size: var(--font-size-base);
	color: var(--color-text-muted);
}

.review-date {
	font-size: var(--font-size-base);
	color: var(--color-text-muted);
}

.review-provider {
	font-size: var(--font-size-sm);
	color: var(--color-primary);
	background: var(--color-primary-bg);
	padding: 0.2rem 0.5rem;
	border-radius: var(--border-radius-sm);
	display: inline-flex;
	align-items: center;
	gap: var(--spacing-xs);
}

.review-clinic {
	font-size: var(--font-size-base);
	color: var(--color-primary);
	text-decoration: none;
}

.review-clinic:hover {
	text-decoration: underline;
}

.review-replies {
	border-top: var(--border-width-thin) solid var(--color-border-secondary);
	padding-top: var(--spacing-lg);
	margin-top: var(--spacing-lg);
}

.own-actions {
	display: flex;
	gap: var(--spacing-sm);
	margin-top: var(--spacing-lg);
}

.edit-form {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
}

.edit-actions {
	display: flex;
	gap: var(--spacing-sm);
}
</style>
