<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import RatingStars from '~/components/rating-stars.vue';
import ReviewProviderIcon from '~/components/review-provider-icon.vue';
import reviewsI18n from '~/i18n/reviews';
import { combineI18nMessages } from '~/i18n/utils';
import { getReviewDateFormat } from '~/common/date-format';
import type { Review } from '~/interfaces/review';

const props = defineProps<{
	review: Review;
	clinicInfo?: Record<number, { name: string; slug: string }>;
}>();

const emit = defineEmits<{
	updated: [review: Review];
	deleted: [];
}>();

// Слияние на уровне модуля, а не в setup: словарь отзывов константный, а этот
// компонент рендерится на каждый отзыв страницы. Ссылка общая для экземпляров.
const messages = combineI18nMessages([reviewsI18n]);

const { t, locale } = useI18n({ useScope: 'local', messages });

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

// Отклонённый файл верификации заменён новым — отзыв снова в очереди проверки
const onVerificationReuploaded = () => {
	emit('updated', { ...props.review, verificationStatus: 'pending' });
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
				<span v-if="review.isOwn" class="own-badge">{{
					t('YourReviewLabel')
				}}</span>
				<ReviewVerifiedBadge v-if="review.isVerified" />
			</div>
			<div class="review-meta">
				<RatingStars
					v-if="review.rating && !isEditing"
					:rating="review.rating"
				/>
				<time
					class="review-date"
					v-if="review.publishedAt"
					:datetime="review.publishedAt"
				>
					<LocalizedDate
						:value="review.publishedAt"
						:format="getReviewDateFormat(review.provider)"
					/>
				</time>
				<span
					class="review-provider"
					v-if="review.provider && review.provider !== 'docta_me'"
				>
					<ReviewProviderIcon :provider="review.provider" />
					<span class="provider-name">{{
						t(`Provider_${review.provider}`)
					}}</span>
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
					<el-button
						type="primary"
						size="small"
						:loading="isSaving"
						@click="saveEdit"
					>
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
			<!-- Уведомления автору о модерации/верификации -->
			<el-alert
				v-if="review.isOwn && review.status === 'rejected'"
				type="warning"
				:closable="false"
				show-icon
				class="own-status-alert"
				:title="t('ReviewRejectedNotice')"
				:description="review.rejectionReason || undefined"
			/>
			<div
				v-else-if="review.isOwn && review.verificationStatus === 'pending'"
				class="verification-status-note"
			>
				{{ t('VerificationPendingNotice') }}
			</div>
			<div
				v-else-if="review.isOwn && review.verificationStatus === 'rejected'"
				class="verification-rejected"
			>
				<el-alert
					type="info"
					:closable="false"
					show-icon
					class="own-status-alert"
					:title="t('VerificationRejectedNotice')"
				/>
				<ReviewVerificationUpload
					:review-id="review.id"
					@uploaded="onVerificationReuploaded"
				/>
			</div>

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
	padding: var(--kit-spacing-xl);
	border: var(--kit-border-width-thin) solid var(--kit-color-border-secondary);
	border-radius: var(--kit-border-radius-xl);
	background: var(--kit-color-bg-primary);
	box-shadow: var(--kit-shadow-sm);
}

.review-item.is-own {
	border-color: var(--kit-color-primary);
}

.review-header {
	margin-bottom: var(--kit-spacing-lg);
}

.author-info {
	display: flex;
	align-items: center;
	gap: var(--kit-spacing-sm);
	margin-bottom: var(--kit-spacing-xs);
}

.author-name {
	font-weight: var(--kit-font-weight-semibold);
	color: var(--kit-color-text-primary);
}

.own-badge {
	font-size: var(--kit-font-size-sm);
	font-weight: var(--kit-font-weight-medium);
	color: var(--kit-color-primary);
	background: var(--kit-color-primary-bg);
	padding: 2px var(--kit-spacing-sm);
	border-radius: var(--kit-border-radius-sm);
}

.review-meta {
	display: flex;
	align-items: center;
	flex-wrap: wrap;
	gap: var(--kit-spacing-md);
	font-size: var(--kit-font-size-base);
	color: var(--kit-color-text-muted);
}

.review-date {
	font-size: var(--kit-font-size-base);
	color: var(--kit-color-text-muted);
}

.review-provider {
	font-size: var(--kit-font-size-sm);
	color: var(--kit-color-primary);
	background: var(--kit-color-primary-bg);
	padding: var(--kit-spacing-xs) var(--kit-spacing-sm);
	border-radius: var(--kit-border-radius-sm);
	display: inline-flex;
	align-items: center;
	gap: var(--kit-spacing-xs);
}

.review-clinic {
	font-size: var(--kit-font-size-base);
	color: var(--kit-color-primary);
	text-decoration: none;
}

.review-clinic:hover {
	text-decoration: underline;
}

@media (max-width: 640px) {
	.provider-name {
		display: none;
	}
}

.review-replies {
	border-top: var(--kit-border-width-thin) solid
		var(--kit-color-border-secondary);
	padding-top: var(--kit-spacing-lg);
	margin-top: var(--kit-spacing-lg);
}

.own-actions {
	display: flex;
	gap: var(--kit-spacing-sm);
	margin-top: var(--kit-spacing-lg);
}

.own-status-alert {
	margin-bottom: var(--kit-spacing-md);
}

.verification-status-note {
	font-size: var(--kit-font-size-sm);
	color: var(--kit-color-text-muted);
	margin-bottom: var(--kit-spacing-md);
}

.verification-rejected {
	margin-bottom: var(--kit-spacing-md);
}

.verification-rejected .own-status-alert {
	margin-bottom: var(--kit-spacing-sm);
}

.edit-form {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-md);
}

.edit-actions {
	display: flex;
	gap: var(--kit-spacing-sm);
}
</style>
