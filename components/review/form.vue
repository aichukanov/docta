<script setup lang="ts">
import { QuestionFilled } from '@element-plus/icons-vue';
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

const relatedHint = computed(() =>
	props.entityType === 'clinic'
		? t('ReviewDoctorHint')
		: t('ReviewClinicHint'),
);

const handleSubmit = async () => {
	error.value = '';
	if (!rating.value) { error.value = t('RatingRequired'); return; }

	try {
		isSubmitting.value = true;
		const response = await $fetch<{ data?: { id?: number } }>('/api/reviews/create', {
			method: 'POST',
			body: {
				entityType: props.entityType,
				entityId: props.entityId,
				relatedEntityId: selectedRelatedId.value || undefined,
				rating: rating.value,
				text: reviewText.value.trim(),
				locale: locale.value,
			},
		});
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
		visible.value = false;
		emit('submitted', review);
	} catch (e: unknown) {
		const err = e as { data?: { statusMessage?: string; data?: { code?: string } } };
		const code = err.data?.data?.code || err.data?.statusMessage || 'INTERNAL_ERROR';
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
	<el-dialog
		v-model="visible"
		:title="t('WriteReview')"
		width="600px"
		destroy-on-close
	>
		<ReviewLoginPrompt v-if="!user" />

		<el-form
			v-else
			@submit.prevent="handleSubmit"
			label-position="top"
		>
			<!-- Primary entity (read-only) -->
			<el-form-item
				:label="entityType === 'clinic' ? t('ReviewClinic') : t('ReviewDoctor')"
			>
				<span class="entity-name">{{ entityName }}</span>
			</el-form-item>

			<!-- Related entity selector -->
			<el-form-item v-if="relatedEntities && relatedEntities.length > 0">
				<template #label>
					{{ entityType === 'clinic' ? t('ReviewDoctor') : t('ReviewClinic') }}
					<el-tooltip :content="relatedHint" placement="top">
						<el-icon class="hint-icon"><QuestionFilled /></el-icon>
					</el-tooltip>
				</template>
				<el-select
					v-model="selectedRelatedId"
					clearable
					:placeholder="entityType === 'clinic' ? t('ReviewSelectDoctor') : t('ReviewSelectClinic')"
				>
					<el-option
						v-for="entity in relatedEntities"
						:key="entity.id"
						:value="entity.id"
						:label="entity.name"
					/>
				</el-select>
			</el-form-item>

			<!-- Rating -->
			<el-form-item :label="t('YourRating')">
				<ReviewRatingInput v-model="rating" />
			</el-form-item>

			<!-- Text -->
			<el-form-item :label="t('YourReview')">
				<el-input
					v-model="reviewText"
					type="textarea"
					:rows="4"
					:maxlength="5000"
					show-word-limit
					:placeholder="t('ReviewPlaceholder')"
				/>
			</el-form-item>

			<el-alert
				v-if="error"
				type="error"
				:title="error"
				:closable="false"
				show-icon
				style="margin-bottom: 16px"
			/>
			<el-button type="primary" native-type="submit" :loading="isSubmitting">
				{{ t('SubmitReview') }}
			</el-button>
		</el-form>
	</el-dialog>
</template>

<style scoped>
.entity-name {
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-primary);
}

.hint-icon {
	margin-left: 4px;
	color: var(--color-text-light);
	cursor: help;
}
</style>
