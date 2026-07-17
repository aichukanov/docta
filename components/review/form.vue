<script setup lang="ts">
import reviewsI18n from '~/i18n/reviews';
import { combineI18nMessages } from '~/i18n/utils';
import type { Review } from '~/interfaces/review';

export interface ReviewFormEntity {
	id: number;
	name: string;
}

const props = defineProps<{
	entityType: 'doctor' | 'clinic';
	entityId: number;
	entityName: string;
	relatedEntities?: ReviewFormEntity[];
}>();

const visible = defineModel<boolean>({ default: false });

const emit = defineEmits<{
	submitted: [review: Review];
}>();

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([reviewsI18n]),
});

const userStore = useUserStore();
const { user } = storeToRefs(userStore);

const rating = ref(0);
const reviewText = ref('');
const selectedRelatedId = ref<number | undefined>(undefined);
const isSubmitting = ref(false);
const error = ref('');

// Шаг 2 (опционально): подтверждение визита документом
const step = ref<'form' | 'verification'>('form');
const createdReviewId = ref<number | null>(null);

const dialogTitle = computed(() =>
	step.value === 'verification' ? t('VerificationTitle') : t('WriteReview'),
);

const closeDialog = () => {
	visible.value = false;
	step.value = 'form';
	createdReviewId.value = null;
};

const onVerificationUploaded = () => {
	ElMessage.success(t('VerificationUploaded'));
	closeDialog();
};

watch(visible, (isOpen) => {
	if (!isOpen) {
		step.value = 'form';
		createdReviewId.value = null;
	}
});

const relatedHint = computed(() =>
	props.entityType === 'clinic' ? t('ReviewDoctorHint') : t('ReviewClinicHint'),
);

const handleSubmit = async () => {
	error.value = '';
	if (!rating.value) {
		error.value = t('RatingRequired');
		return;
	}

	try {
		isSubmitting.value = true;
		const response = await $fetch<{ data?: { id?: number } }>(
			'/api/reviews/create',
			{
				method: 'POST',
				body: {
					entityType: props.entityType,
					entityId: props.entityId,
					relatedEntityId: selectedRelatedId.value || undefined,
					rating: rating.value,
					text: reviewText.value.trim(),
					locale: locale.value,
				},
			},
		);
		const review: Review = {
			id: response?.data?.id || 0,
			provider: 'docta_me',
			rating: rating.value,
			text: reviewText.value.trim(),
			originalLanguage: locale.value,
			likesCount: 0,
			publishedAt: new Date().toISOString(),
			updatedAt: new Date().toISOString(),
			isOwn: true,
			author: {
				name: user.value?.name || t('Anonymous'),
			},
		};
		emit('submitted', review);
		// Отзыв создан — предлагаем опционально подтвердить визит документом
		if (review.id) {
			createdReviewId.value = review.id;
			step.value = 'verification';
		} else {
			closeDialog();
		}
	} catch (e: unknown) {
		const err = e as {
			data?: { statusMessage?: string; data?: { code?: string } };
		};
		const code =
			err.data?.data?.code || err.data?.statusMessage || 'INTERNAL_ERROR';
		const errorMessages: Record<string, string> = {
			REVIEW_DUPLICATE: t('ReviewDuplicate'),
			REVIEW_INVALID_RATING: t('RatingRequired'),
		};
		error.value = errorMessages[code] || code;
	} finally {
		isSubmitting.value = false;
	}
};
</script>

<template>
	<AppDialog v-model="visible" :title="dialogTitle" width="560px">
		<ReviewLoginPrompt v-if="!user" />

		<!-- Шаг 2: опциональная верификация визита -->
		<div
			v-else-if="step === 'verification' && createdReviewId"
			class="verification-step"
		>
			<p class="verification-hint">{{ t('VerificationHint') }}</p>
			<ReviewVerificationUpload
				:reviewId="createdReviewId"
				@uploaded="onVerificationUploaded"
			/>
			<el-button text class="skip-button" @click="closeDialog">
				{{ t('VerificationSkip') }}
			</el-button>
		</div>

		<form v-else class="review-form" @submit.prevent="handleSubmit">
			<!-- Primary entity (read-only) -->
			<div class="form-field">
				<label class="form-label">
					{{ entityType === 'clinic' ? t('ReviewClinic') : t('ReviewDoctor') }}
				</label>
				<span class="entity-name">{{ entityName }}</span>
			</div>

			<!-- Related entity selector -->
			<div
				v-if="relatedEntities && relatedEntities.length > 0"
				class="form-field"
			>
				<label class="form-label">
					{{ entityType === 'clinic' ? t('ReviewDoctor') : t('ReviewClinic') }}
				</label>
				<el-select
					v-model="selectedRelatedId"
					clearable
					:placeholder="
						entityType === 'clinic'
							? t('ReviewSelectDoctor')
							: t('ReviewSelectClinic')
					"
				>
					<el-option
						v-for="entity in relatedEntities"
						:key="entity.id"
						:value="entity.id"
						:label="entity.name"
					/>
				</el-select>
			</div>

			<!-- Rating -->
			<div class="form-field">
				<label class="form-label">{{ t('YourRating') }}</label>
				<ReviewRatingInput v-model="rating" />
			</div>

			<!-- Text -->
			<div class="form-field">
				<label class="form-label">{{ t('YourReview') }}</label>
				<el-input
					v-model="reviewText"
					type="textarea"
					:rows="4"
					:maxlength="5000"
					show-word-limit
					:placeholder="t('ReviewPlaceholder')"
				/>
			</div>

			<el-alert
				v-if="error"
				type="error"
				:title="error"
				:closable="false"
				show-icon
			/>
			<el-button type="primary" native-type="submit" :loading="isSubmitting">
				{{ t('SubmitReview') }}
			</el-button>
		</form>
	</AppDialog>
</template>

<style scoped>
.review-form {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
}

.verification-step {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
}

.verification-hint {
	margin: 0;
	color: var(--color-text-secondary);
	line-height: 1.6;
}

.skip-button {
	align-self: flex-start;
}

.form-field {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xs);
}

.form-label {
	font-size: var(--font-size-sm);
	font-weight: var(--font-weight-medium);
	color: var(--color-text-secondary);
}

.entity-name {
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-primary);
}
</style>
