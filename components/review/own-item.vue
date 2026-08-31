<script setup lang="ts">
import type { ReviewFormEntity } from '~/components/review/form.vue';
import reviewsI18n from '~/i18n/reviews';
import { combineI18nMessages } from '~/i18n/utils';
import type { Review } from '~/interfaces/review';

const THREE_MONTHS_MS = 90 * 24 * 60 * 60 * 1000;

const props = defineProps<{
	review: Review;
	clinicInfo?: Record<number, { name: string; slug: string }>;
	entityType?: 'doctor' | 'clinic';
	entityId?: number;
	entityName?: string;
	relatedEntities?: ReviewFormEntity[];
}>();

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([reviewsI18n]),
});

const isEditing = ref(false);
const editRating = ref(props.review.rating || 0);
const editText = ref(props.review.originalText || props.review.text || '');
const isSaving = ref(false);
const error = ref('');
const successMsg = ref('');
const showNewForm = ref(false);

const canAddAnother = computed(() => {
	const published = props.review.publishedAt;
	if (!published) return false;
	return Date.now() - new Date(published).getTime() > THREE_MONTHS_MS;
});

const startEdit = () => {
	editRating.value = props.review.rating || 0;
	editText.value = props.review.originalText || props.review.text || '';
	error.value = '';
	successMsg.value = '';
	isEditing.value = true;
};

const cancelEdit = () => {
	isEditing.value = false;
	error.value = '';
};

const saveEdit = async () => {
	error.value = '';
	if (!editRating.value) {
		error.value = t('RatingRequired');
		return;
	}
	if (!editText.value.trim()) {
		error.value = t('ReviewTextRequired');
		return;
	}

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
		successMsg.value = t('ReviewUpdated');
		props.review.rating = editRating.value;
		props.review.text = editText.value.trim();
		props.review.originalText = undefined;
	} catch (e: unknown) {
		const err = e as { data?: { statusMessage?: string } };
		error.value = err.data?.statusMessage || 'INTERNAL_ERROR';
	} finally {
		isSaving.value = false;
	}
};
</script>

<template>
	<div class="own-review">
		<div class="own-badge">{{ t('YourReviewLabel') }}</div>

		<!-- Display mode -->
		<template v-if="!isEditing">
			<ReviewItem :review="review" :clinicInfo="clinicInfo" />
			<div class="own-actions">
				<el-button size="small" @click="startEdit">{{
					t('EditReview')
				}}</el-button>
			</div>
			<el-alert
				v-if="successMsg"
				type="success"
				:title="successMsg"
				closable
				show-icon
				@close="successMsg = ''"
				style="margin-top: 8px"
			/>
		</template>

		<!-- Edit mode -->
		<template v-else>
			<el-form @submit.prevent="saveEdit" label-position="top">
				<el-form-item :label="t('YourRating')">
					<ReviewRatingInput v-model="editRating" />
				</el-form-item>
				<el-form-item :label="t('YourReview')">
					<el-input
						v-model="editText"
						type="textarea"
						:rows="4"
						:maxlength="5000"
						show-word-limit
					/>
				</el-form-item>
				<el-alert
					v-if="error"
					type="error"
					:title="error"
					:closable="false"
					show-icon
					style="margin-bottom: 8px"
				/>
				<div class="edit-actions">
					<el-button type="primary" native-type="submit" :loading="isSaving">
						{{ t('SaveReview') }}
					</el-button>
					<el-button @click="cancelEdit">{{ t('CancelEdit') }}</el-button>
				</div>
			</el-form>
		</template>

		<!-- Add another review (after 3 months) -->
		<template v-if="canAddAnother && entityId && !isEditing">
			<el-button
				v-if="!showNewForm"
				text
				type="primary"
				size="small"
				style="margin-top: 8px"
				@click="showNewForm = true"
			>
				{{ t('AddAnotherReview') }}
			</el-button>
			<ReviewForm
				v-else
				:entityType="entityType!"
				:entityId="entityId"
				:entityName="entityName || ''"
				:relatedEntities="relatedEntities"
				style="margin-top: 12px"
			/>
		</template>
	</div>
</template>

<style scoped>
.own-review {
	padding: var(--kit-spacing-lg);
	border: 2px solid var(--kit-color-primary);
	border-radius: var(--kit-border-radius-xl);
	background: var(--kit-color-primary-bg);
}

.own-badge {
	font-size: var(--kit-font-size-sm);
	font-weight: var(--kit-font-weight-semibold);
	color: var(--kit-color-primary);
	margin-bottom: var(--kit-spacing-sm);
}

.own-actions {
	margin-top: var(--kit-spacing-sm);
}

.edit-actions {
	display: flex;
	gap: var(--kit-spacing-sm);
}
</style>
