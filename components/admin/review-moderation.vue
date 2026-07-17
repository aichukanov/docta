<script setup lang="ts">
import type {
	ModerationReviewItem,
	ModerationStats,
	ModerationVerificationItem,
} from '~/server/api/admin/reviews/queue.get';

type QueueType = 'reviews' | 'verifications';
type QueueStatus = 'pending' | 'approved' | 'rejected';

const activeType = ref<QueueType>('reviews');
const status = ref<QueueStatus>('pending');
const page = ref(1);
const isLoading = ref(false);

const stats = ref<ModerationStats | null>(null);
const reviews = ref<ModerationReviewItem[]>([]);
const verifications = ref<ModerationVerificationItem[]>([]);
const total = ref(0);
const pageSize = ref(20);

// Диалог отклонения (отзыв: причина обязательна; верификация: опциональна)
const rejectDialogVisible = ref(false);
const rejectReason = ref('');
const rejectTarget = ref<{ type: QueueType; reviewId: number } | null>(null);
const isSubmitting = ref(false);

async function loadQueue() {
	isLoading.value = true;
	try {
		const data: any = await $fetch('/api/admin/reviews/queue', {
			params: {
				type: activeType.value,
				status: status.value,
				page: page.value,
			},
		});
		stats.value = data.stats;
		reviews.value = data.reviews || [];
		verifications.value = data.verifications || [];
		total.value = data.pagination?.total || 0;
		pageSize.value = data.pagination?.pageSize || 20;
	} catch (error) {
		console.error('Failed to load moderation queue:', error);
		ElMessage.error('Ошибка загрузки очереди модерации');
	} finally {
		isLoading.value = false;
	}
}

watch([activeType, status], () => {
	page.value = 1;
	loadQueue();
});
watch(page, loadQueue);
onMounted(loadQueue);

async function moderate(reviewId: number, action: 'approve' | 'reject', reason?: string) {
	isSubmitting.value = true;
	try {
		await $fetch('/api/admin/reviews/moderate', {
			method: 'POST',
			body: { reviewId, action, reason },
		});
		ElMessage.success(action === 'approve' ? 'Отзыв одобрен' : 'Отзыв отклонён');
		rejectDialogVisible.value = false;
		await loadQueue();
	} catch (error) {
		console.error('Failed to moderate review:', error);
		ElMessage.error('Ошибка модерации');
	} finally {
		isSubmitting.value = false;
	}
}

async function verify(reviewId: number, action: 'approve' | 'reject', reason?: string) {
	isSubmitting.value = true;
	try {
		await $fetch('/api/admin/reviews/verify', {
			method: 'POST',
			body: { reviewId, action, reason },
		});
		ElMessage.success(
			action === 'approve' ? 'Верификация одобрена' : 'Верификация отклонена',
		);
		rejectDialogVisible.value = false;
		await loadQueue();
	} catch (error) {
		console.error('Failed to moderate verification:', error);
		ElMessage.error('Ошибка модерации верификации');
	} finally {
		isSubmitting.value = false;
	}
}

function openRejectDialog(type: QueueType, reviewId: number) {
	rejectTarget.value = { type, reviewId };
	rejectReason.value = '';
	rejectDialogVisible.value = true;
}

function submitReject() {
	if (!rejectTarget.value) return;
	const { type, reviewId } = rejectTarget.value;
	if (type === 'reviews') {
		if (!rejectReason.value.trim()) {
			ElMessage.error('Укажите причину отклонения');
			return;
		}
		moderate(reviewId, 'reject', rejectReason.value.trim());
	} else {
		verify(reviewId, 'reject', rejectReason.value.trim() || undefined);
	}
}

const statusTagType = (s: string) =>
	s === 'approved' ? 'success' : s === 'rejected' ? 'danger' : 'warning';

const statusLabel = (s: string) =>
	s === 'approved' ? 'Одобрен' : s === 'rejected' ? 'Отклонён' : 'Ожидает';

function formatDate(date: string | null) {
	return date ? new Date(date).toLocaleString('ru-RU') : '—';
}
</script>

<template>
	<div class="review-moderation">
		<!-- Статистика -->
		<div v-if="stats" class="stats-row">
			<div class="stat-item">
				<div class="stat-value">{{ stats.pendingReviews }}</div>
				<div class="stat-label">Отзывы на модерации</div>
			</div>
			<div class="stat-item">
				<div class="stat-value">{{ stats.pendingVerifications }}</div>
				<div class="stat-label">Верификация ожидает</div>
			</div>
			<div class="stat-item">
				<div class="stat-value">{{ stats.approvedReviews }}</div>
				<div class="stat-label">Одобрено</div>
			</div>
			<div class="stat-item">
				<div class="stat-value">{{ stats.rejectedReviews }}</div>
				<div class="stat-label">Отклонено</div>
			</div>
			<div class="stat-item">
				<div class="stat-value">{{ stats.verifiedReviews }}</div>
				<div class="stat-label">Верифицировано</div>
			</div>
		</div>

		<div class="queue-controls">
			<el-radio-group v-model="activeType">
				<el-radio-button value="reviews">Отзывы</el-radio-button>
				<el-radio-button value="verifications">Верификация</el-radio-button>
			</el-radio-group>

			<el-radio-group v-model="status">
				<el-radio-button value="pending">Ожидают</el-radio-button>
				<el-radio-button value="approved">Одобренные</el-radio-button>
				<el-radio-button value="rejected">Отклонённые</el-radio-button>
			</el-radio-group>
		</div>

		<div v-if="isLoading" class="queue-loading">Загрузка...</div>

		<!-- Отзывы -->
		<template v-else-if="activeType === 'reviews'">
			<el-empty v-if="reviews.length === 0" description="Нет отзывов" />
			<div v-else class="queue-list">
				<el-card v-for="review in reviews" :key="review.id" shadow="never">
					<div class="item-header">
						<div>
							<strong>{{
								review.targetType === 'doctor' ? 'Врач' : 'Клиника'
							}}:</strong>
							<a
								v-if="review.targetSlug"
								:href="`/${review.targetType}s/${review.targetSlug}`"
								target="_blank"
								class="target-link"
							>
								{{ review.targetName }}
							</a>
							<span v-else>{{ review.targetName }}</span>
						</div>
						<el-tag :type="statusTagType(review.status)" size="small">
							{{ statusLabel(review.status) }}
						</el-tag>
					</div>

					<div class="item-meta">
						<span
							>Автор: {{ review.authorName || 'Аноним' }}
							<template v-if="review.authorEmail"
								>({{ review.authorEmail }})</template
							></span
						>
						<span>Дата: {{ formatDate(review.publishedAt) }}</span>
						<span v-if="review.rating">Оценка: {{ review.rating }}★</span>
						<el-tag v-if="review.isVerified" type="success" size="small"
							>Верифицирован</el-tag
						>
					</div>

					<p v-if="review.text" class="item-text">{{ review.text }}</p>
					<p v-else class="item-text item-text-empty">(без текста)</p>

					<p v-if="review.rejectionReason" class="rejection-reason">
						Причина отклонения: {{ review.rejectionReason }}
					</p>

					<div class="item-actions">
						<el-button
							v-if="review.status !== 'approved'"
							type="success"
							size="small"
							:loading="isSubmitting"
							@click="moderate(review.id, 'approve')"
						>
							Одобрить
						</el-button>
						<el-button
							v-if="review.status !== 'rejected'"
							type="danger"
							size="small"
							plain
							@click="openRejectDialog('reviews', review.id)"
						>
							Отклонить
						</el-button>
					</div>
				</el-card>
			</div>
		</template>

		<!-- Верификация -->
		<template v-else>
			<el-empty
				v-if="verifications.length === 0"
				description="Нет файлов верификации"
			/>
			<div v-else class="queue-list">
				<el-card v-for="file in verifications" :key="file.reviewId" shadow="never">
					<div class="item-header">
						<div>
							<strong>{{ file.targetName }}</strong>
							— отзыв #{{ file.reviewId }}
						</div>
						<el-tag :type="statusTagType(file.status)" size="small">
							{{ statusLabel(file.status) }}
						</el-tag>
					</div>

					<div class="item-meta">
						<span>Автор: {{ file.authorName || 'Аноним' }}</span>
						<span>Загружен: {{ formatDate(file.uploadedAt) }}</span>
						<span v-if="file.rating">Оценка отзыва: {{ file.rating }}★</span>
						<span v-if="file.fileName">Файл: {{ file.fileName }}</span>
					</div>

					<p v-if="file.text" class="item-text">{{ file.text }}</p>

					<div class="verification-preview">
						<img
							:src="`/api/reviews/verification-file?reviewId=${file.reviewId}`"
							alt="Файл верификации"
							loading="lazy"
						/>
					</div>

					<p v-if="file.rejectionReason" class="rejection-reason">
						Причина отклонения: {{ file.rejectionReason }}
					</p>

					<div class="item-actions">
						<el-button
							v-if="file.status !== 'approved'"
							type="success"
							size="small"
							:loading="isSubmitting"
							@click="verify(file.reviewId, 'approve')"
						>
							Одобрить верификацию
						</el-button>
						<el-button
							v-if="file.status !== 'rejected'"
							type="danger"
							size="small"
							plain
							@click="openRejectDialog('verifications', file.reviewId)"
						>
							Отклонить
						</el-button>
					</div>
				</el-card>
			</div>
		</template>

		<el-pagination
			v-if="total > pageSize"
			v-model:current-page="page"
			:page-size="pageSize"
			:total="total"
			layout="prev, pager, next, total"
			class="queue-pagination"
		/>

		<!-- Диалог отклонения -->
		<el-dialog v-model="rejectDialogVisible" title="Причина отклонения" width="480px">
			<el-input
				v-model="rejectReason"
				type="textarea"
				:rows="3"
				:placeholder="
					rejectTarget?.type === 'reviews'
						? 'Причина обязательна — автор увидит её у своего отзыва'
						: 'Необязательно'
				"
			/>
			<template #footer>
				<el-button @click="rejectDialogVisible = false">Отмена</el-button>
				<el-button type="danger" :loading="isSubmitting" @click="submitReject">
					Отклонить
				</el-button>
			</template>
		</el-dialog>
	</div>
</template>

<style scoped>
.review-moderation {
	display: flex;
	flex-direction: column;
	gap: 16px;
	padding: 8px 0;
}

.stats-row {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
	gap: 12px;
}

.stat-item {
	text-align: center;
	padding: 12px;
	background: var(--color-bg-secondary);
	border-radius: 8px;
}

.stat-value {
	font-size: 24px;
	font-weight: 700;
	color: var(--color-primary);
}

.stat-label {
	font-size: 13px;
	color: var(--color-text-muted);
	margin-top: 4px;
}

.queue-controls {
	display: flex;
	flex-wrap: wrap;
	gap: 12px;
	justify-content: space-between;
}

.queue-loading {
	padding: 24px;
	text-align: center;
	color: var(--color-text-muted);
}

.queue-list {
	display: flex;
	flex-direction: column;
	gap: 12px;
}

.item-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	gap: 8px;
	margin-bottom: 8px;
}

.target-link {
	color: var(--color-primary);
	margin-left: 4px;
}

.item-meta {
	display: flex;
	flex-wrap: wrap;
	gap: 12px;
	font-size: 13px;
	color: var(--color-text-muted);
	margin-bottom: 8px;
}

.item-text {
	margin: 0 0 8px;
	padding: 10px 12px;
	background: var(--color-bg-secondary);
	border-radius: 6px;
	line-height: 1.5;
	white-space: pre-wrap;
}

.item-text-empty {
	color: var(--color-text-muted);
}

.rejection-reason {
	margin: 0 0 8px;
	font-size: 13px;
	color: var(--color-danger-dark);
}

.verification-preview {
	margin-bottom: 8px;
	border: 1px solid var(--color-border-secondary);
	border-radius: 6px;
	overflow: hidden;
	max-width: 480px;
}

.verification-preview img {
	display: block;
	width: 100%;
	max-height: 400px;
	object-fit: contain;
	background: var(--color-bg-secondary);
}

.item-actions {
	display: flex;
	gap: 8px;
	justify-content: flex-end;
}

.queue-pagination {
	justify-content: center;
}
</style>
