<script setup lang="ts">
import type { ClinicData } from '~/interfaces/clinic';
import type { DoctorData } from '~/interfaces/doctor';
import type {
	ReviewAdminDetails,
	ReplyAdminData,
} from '~/server/api/reviews/admin-details';

interface ReviewListItem {
	id: number;
	label: string;
}

interface UserListItem {
	id: number;
	email: string;
	name: string;
}

const props = withDefaults(
	defineProps<{
		reviews: ReviewListItem[];
		clinics: ClinicData[];
		doctors: DoctorData[];
		users: UserListItem[];
		editable?: boolean;
	}>(),
	{ editable: false },
);

const emit = defineEmits<{
	(e: 'updated'): void;
}>();

const reviewId = ref<number | null>(null);
const reviewModel = ref<ReviewAdminDetails | null>(null);
const originalReview = ref<ReviewAdminDetails | null>(null);
const isLoading = ref(false);

const reviewOptions = computed(() =>
	props.reviews.map((r) => ({ label: r.label, value: r.id })),
);

const clinicOptions = computed(() =>
	props.clinics.map((c) => ({ label: c.name, value: c.id })),
);

const doctorOptions = computed(() =>
	props.doctors.map((d) => ({ label: d.name, value: d.id })),
);

const userOptions = computed(() =>
	props.users.map((u) => ({
		label: `id="${u.id}" | ${u.email || 'phantom'} | ${u.name}`,
		value: u.id,
	})),
);

const fieldModified = (field: keyof ReviewAdminDetails) =>
	originalReview.value?.[field] !== reviewModel.value?.[field];

const userIdModified = computed(() => fieldModified('userId'));
const clinicIdModified = computed(() => fieldModified('clinicId'));
const doctorIdModified = computed(() => fieldModified('doctorId'));
const medicalServiceIdModified = computed(() =>
	fieldModified('medicalServiceId'),
);
const ratingModified = computed(() => fieldModified('rating'));
const originalLanguageModified = computed(() =>
	fieldModified('originalLanguage'),
);
const originalTextModified = computed(() => fieldModified('originalText'));
const textSrModified = computed(() => fieldModified('text_sr'));
const textSrCyrlModified = computed(() => fieldModified('text_sr_cyrl'));
const textEnModified = computed(() => fieldModified('text_en'));
const textRuModified = computed(() => fieldModified('text_ru'));
const textDeModified = computed(() => fieldModified('text_de'));
const textTrModified = computed(() => fieldModified('text_tr'));

const repliesModified = computed(() => {
	if (!originalReview.value || !reviewModel.value) return false;
	return (
		JSON.stringify(originalReview.value.replies) !==
		JSON.stringify(reviewModel.value.replies)
	);
});

const hasChanges = computed(
	() =>
		userIdModified.value ||
		clinicIdModified.value ||
		doctorIdModified.value ||
		medicalServiceIdModified.value ||
		ratingModified.value ||
		originalLanguageModified.value ||
		originalTextModified.value ||
		textSrModified.value ||
		textSrCyrlModified.value ||
		textEnModified.value ||
		textRuModified.value ||
		textDeModified.value ||
		textTrModified.value ||
		repliesModified.value,
);

const originalReplyFor = (responderType: 'clinic' | 'doctor') =>
	originalReview.value?.replies.find((r) => r.responderType === responderType);

const loadReviewDetails = async (id: number) => {
	isLoading.value = true;
	try {
		const data = await $fetch<ReviewAdminDetails | null>(
			'/api/reviews/admin-details',
			{ method: 'POST', body: { reviewId: id } },
		);
		if (data) {
			originalReview.value = JSON.parse(JSON.stringify(data));
			reviewModel.value = data;
		}
	} catch (e) {
		console.error('Failed to load review details:', e);
	} finally {
		isLoading.value = false;
	}
};

const saveChanges = async () => {
	if (!reviewModel.value || !hasChanges.value) return;
	if (!confirm('Сохранить изменения в отзыве?')) return;

	await $fetch('/api/reviews/update', {
		method: 'POST',
		body: reviewModel.value,
	});

	emit('updated');
	alert('Отзыв обновлён');

	if (reviewId.value) await loadReviewDetails(reviewId.value);
};

watch(reviewId, async (newId) => {
	if (newId) {
		await loadReviewDetails(newId);
	} else {
		reviewModel.value = null;
		originalReview.value = null;
	}
});
</script>

<template>
	<div>
		<FilterableSelect
			:items="reviewOptions"
			v-model:value="reviewId"
			placeholder="Выберите отзыв"
			placeholderSearch="Поиск по автору, клинике, ID..."
		/>

		<div v-if="isLoading" class="loading">Загрузка...</div>

		<div v-else-if="reviewModel" class="review-info">
			<!-- Мета-информация (только чтение) -->
			<div class="meta-section">
				<span class="meta-item">
					<strong>Источник:</strong> {{ reviewModel.provider }}
				</span>
				<span v-if="reviewModel.providerReviewId" class="meta-item">
					<strong>ID у источника:</strong> {{ reviewModel.providerReviewId }}
				</span>
				<span class="meta-item">
					<strong>Лайков:</strong> {{ reviewModel.likesCount }}
				</span>
				<span v-if="reviewModel.publishedAt" class="meta-item">
					<strong>Опубликован:</strong>
					{{ reviewModel.publishedAt.slice(0, 10) }}
				</span>
				<span v-if="reviewModel.authorPhotoUrl" class="meta-item">
					<img
						:src="reviewModel.authorPhotoUrl"
						width="36"
						height="36"
						class="author-photo"
					/>
					{{ reviewModel.authorName }}
				</span>
			</div>

			<!-- Оценка -->
			<div class="association-section" :class="{ modified: ratingModified }">
				<label class="section-label">Оценка (1–5)</label>
				<el-input-number
					v-model="reviewModel.rating"
					:min="1"
					:max="5"
					:disabled="!editable"
					controls-position="right"
				/>
				<el-button
					v-if="ratingModified"
					size="small"
					@click="reviewModel.rating = originalReview?.rating ?? null"
				>
					↺
				</el-button>
			</div>

			<!-- Привязка: пользователь -->
			<div
				class="association-section"
				:class="{ modified: userIdModified }"
			>
				<label class="section-label">Автор (пользователь)</label>
				<el-select
					v-model="reviewModel.userId"
					filterable
					clearable
					placeholder="Не привязан"
					:disabled="!editable"
					class="wide-select"
				>
					<el-option
						v-for="u in userOptions"
						:key="u.value"
						:label="u.label"
						:value="u.value"
					/>
				</el-select>
			</div>

			<!-- Привязка: клиника -->
			<div
				class="association-section"
				:class="{ modified: clinicIdModified }"
			>
				<label class="section-label">Клиника</label>
				<el-select
					v-model="reviewModel.clinicId"
					filterable
					clearable
					placeholder="Не привязана"
					:disabled="!editable"
					class="wide-select"
				>
					<el-option
						v-for="c in clinicOptions"
						:key="c.value"
						:label="c.label"
						:value="c.value"
					/>
				</el-select>
			</div>

			<!-- Привязка: врач -->
			<div
				class="association-section"
				:class="{ modified: doctorIdModified }"
			>
				<label class="section-label">Врач</label>
				<el-select
					v-model="reviewModel.doctorId"
					filterable
					clearable
					placeholder="Не привязан"
					:disabled="!editable"
					class="wide-select"
				>
					<el-option
						v-for="d in doctorOptions"
						:key="d.value"
						:label="d.label"
						:value="d.value"
					/>
				</el-select>
			</div>

			<!-- Привязка: услуга (редко меняется) -->
			<div
				class="association-section"
				:class="{ modified: medicalServiceIdModified }"
			>
				<label class="section-label">ID услуги</label>
				<el-input-number
					v-model="reviewModel.medicalServiceId"
					:min="0"
					:disabled="!editable"
					controls-position="right"
					placeholder="null"
				/>
				<el-button
					v-if="medicalServiceIdModified"
					size="small"
					@click="
						reviewModel.medicalServiceId =
							originalReview?.medicalServiceId ?? null
					"
				>
					↺
				</el-button>
			</div>

			<!-- Оригинальный текст -->
			<AdminFieldGroup title="Оригинал">
				<AdminEditableField
					label="Язык оригинала (bs, me, ru, en...)"
					v-model:value="reviewModel.originalLanguage"
					:modified="originalLanguageModified"
					:readonly="!editable"
					@reset="
						reviewModel.originalLanguage =
							originalReview?.originalLanguage || ''
					"
				/>
				<AdminEditableField
					label="Текст оригинала"
					type="textarea"
					v-model:value="reviewModel.originalText"
					:modified="originalTextModified"
					:readonly="!editable"
					@reset="
						reviewModel.originalText = originalReview?.originalText || ''
					"
				/>
			</AdminFieldGroup>

			<!-- Переводы -->
			<AdminFieldGroup title="Переводы">
				<AdminEditableField
					label="SR (латиница)"
					type="textarea"
					v-model:value="reviewModel.text_sr"
					:modified="textSrModified"
					:readonly="!editable"
					@reset="reviewModel.text_sr = originalReview?.text_sr || ''"
				/>
				<AdminEditableField
					label="SR (кириллица)"
					type="textarea"
					v-model:value="reviewModel.text_sr_cyrl"
					:modified="textSrCyrlModified"
					:readonly="!editable"
					:translate-from="reviewModel.text_sr"
					@reset="
						reviewModel.text_sr_cyrl = originalReview?.text_sr_cyrl || ''
					"
				/>
				<AdminEditableField
					label="EN"
					type="textarea"
					v-model:value="reviewModel.text_en"
					:modified="textEnModified"
					:readonly="!editable"
					@reset="reviewModel.text_en = originalReview?.text_en || ''"
				/>
				<AdminEditableField
					label="RU"
					type="textarea"
					v-model:value="reviewModel.text_ru"
					:modified="textRuModified"
					:readonly="!editable"
					@reset="reviewModel.text_ru = originalReview?.text_ru || ''"
				/>
				<AdminEditableField
					label="DE"
					type="textarea"
					v-model:value="reviewModel.text_de"
					:modified="textDeModified"
					:readonly="!editable"
					@reset="reviewModel.text_de = originalReview?.text_de || ''"
				/>
				<AdminEditableField
					label="TR"
					type="textarea"
					v-model:value="reviewModel.text_tr"
					:modified="textTrModified"
					:readonly="!editable"
					@reset="reviewModel.text_tr = originalReview?.text_tr || ''"
				/>
			</AdminFieldGroup>

			<!-- Ответы на отзыв -->
			<template v-if="reviewModel.replies.length">
				<AdminFieldGroup
					v-for="(reply, idx) in reviewModel.replies"
					:key="reply.id"
					:title="reply.responderType === 'clinic' ? 'Ответ клиники' : 'Ответ врача'"
				>
					<div class="reply-meta">
						<span><strong>Источник:</strong> {{ reply.provider }}</span>
						<span><strong>Лайков:</strong> {{ reply.likesCount }}</span>
					</div>
					<AdminEditableField
						label="Язык оригинала"
						v-model:value="reviewModel.replies[idx].originalLanguage"
						:modified="reply.originalLanguage !== originalReplyFor(reply.responderType)?.originalLanguage"
						:readonly="!editable"
						@reset="reviewModel.replies[idx].originalLanguage = originalReplyFor(reply.responderType)?.originalLanguage || ''"
					/>
					<AdminEditableField
						label="Текст оригинала"
						type="textarea"
						v-model:value="reviewModel.replies[idx].originalText"
						:modified="reply.originalText !== originalReplyFor(reply.responderType)?.originalText"
						:readonly="!editable"
						@reset="reviewModel.replies[idx].originalText = originalReplyFor(reply.responderType)?.originalText || ''"
					/>
					<AdminEditableField
						label="SR (латиница)"
						type="textarea"
						v-model:value="reviewModel.replies[idx].text_sr"
						:modified="reply.text_sr !== originalReplyFor(reply.responderType)?.text_sr"
						:readonly="!editable"
						@reset="reviewModel.replies[idx].text_sr = originalReplyFor(reply.responderType)?.text_sr || ''"
					/>
					<AdminEditableField
						label="SR (кириллица)"
						type="textarea"
						v-model:value="reviewModel.replies[idx].text_sr_cyrl"
						:modified="reply.text_sr_cyrl !== originalReplyFor(reply.responderType)?.text_sr_cyrl"
						:readonly="!editable"
						:translate-from="reply.text_sr"
						@reset="reviewModel.replies[idx].text_sr_cyrl = originalReplyFor(reply.responderType)?.text_sr_cyrl || ''"
					/>
					<AdminEditableField
						label="EN"
						type="textarea"
						v-model:value="reviewModel.replies[idx].text_en"
						:modified="reply.text_en !== originalReplyFor(reply.responderType)?.text_en"
						:readonly="!editable"
						@reset="reviewModel.replies[idx].text_en = originalReplyFor(reply.responderType)?.text_en || ''"
					/>
					<AdminEditableField
						label="RU"
						type="textarea"
						v-model:value="reviewModel.replies[idx].text_ru"
						:modified="reply.text_ru !== originalReplyFor(reply.responderType)?.text_ru"
						:readonly="!editable"
						@reset="reviewModel.replies[idx].text_ru = originalReplyFor(reply.responderType)?.text_ru || ''"
					/>
					<AdminEditableField
						label="DE"
						type="textarea"
						v-model:value="reviewModel.replies[idx].text_de"
						:modified="reply.text_de !== originalReplyFor(reply.responderType)?.text_de"
						:readonly="!editable"
						@reset="reviewModel.replies[idx].text_de = originalReplyFor(reply.responderType)?.text_de || ''"
					/>
					<AdminEditableField
						label="TR"
						type="textarea"
						v-model:value="reviewModel.replies[idx].text_tr"
						:modified="reply.text_tr !== originalReplyFor(reply.responderType)?.text_tr"
						:readonly="!editable"
						@reset="reviewModel.replies[idx].text_tr = originalReplyFor(reply.responderType)?.text_tr || ''"
					/>
				</AdminFieldGroup>
			</template>
			<div v-else class="no-replies">Ответов на этот отзыв нет</div>

			<div v-if="editable" class="button-group">
				<el-button
					type="primary"
					@click="saveChanges"
					:disabled="!hasChanges"
				>
					Сохранить изменения
				</el-button>
			</div>
		</div>
	</div>
</template>

<style scoped lang="less">
.review-info {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
	margin-top: var(--spacing-lg);
	border-top: 1px solid var(--color-border-primary);
	padding-top: var(--spacing-lg);
}

.loading {
	padding: var(--spacing-lg);
	color: var(--color-text-secondary);
}

.meta-section {
	display: flex;
	flex-wrap: wrap;
	gap: var(--spacing-md);
	padding: var(--spacing-md);
	background: var(--color-surface-secondary);
	border-radius: var(--border-radius-md);
	border: 1px solid var(--color-border-primary);
	font-size: 0.9em;
	color: var(--color-text-secondary);
}

.meta-item {
	display: flex;
	align-items: center;
	gap: var(--spacing-xs);
}

.author-photo {
	border-radius: 50%;
	object-fit: cover;
}

.association-section {
	display: flex;
	align-items: center;
	gap: var(--spacing-sm);
	padding: var(--spacing-md);
	background: var(--color-surface-secondary);
	border-radius: var(--border-radius-md);
	border: 1px solid var(--color-border-primary);

	&.modified {
		border-color: var(--color-warning);
	}

	.section-label {
		font-weight: 500;
		color: var(--color-text-primary);
		font-size: 0.9em;
		min-width: 180px;
	}

	.wide-select {
		flex: 1;
	}
}

.reply-meta {
	display: flex;
	gap: var(--spacing-md);
	font-size: 0.85em;
	color: var(--color-text-secondary);
}

.no-reply,
.no-replies {
	color: var(--color-text-secondary);
	font-size: 0.9em;
}

.button-group {
	display: flex;
	gap: var(--spacing-md);
}
</style>
