<script setup lang="ts">
import type { UserAdminListItem } from '~/server/api/users/admin-list';
import type { RecentRealUserReview } from '~/server/api/reviews/recent-from-real-users';

const props = defineProps<{
	users: UserAdminListItem[];
	recentReviews: RecentRealUserReview[];
}>();

const realOnly = ref(true);
const searchQuery = ref('');

const filteredUsers = computed(() => {
	const q = searchQuery.value.trim().toLowerCase();
	return props.users.filter((u) => {
		if (realOnly.value && u.isPhantom) return false;
		if (!q) return true;
		return (
			String(u.id).includes(q) ||
			u.email.toLowerCase().includes(q) ||
			u.name.toLowerCase().includes(q)
		);
	});
});

const formatDate = (iso: string | null) => {
	if (!iso) return '—';
	const d = new Date(iso);
	if (Number.isNaN(d.getTime())) return '—';
	return d.toLocaleDateString('ru-RU');
};

const formatDateTime = (iso: string | null) => {
	if (!iso) return '—';
	const d = new Date(iso);
	if (Number.isNaN(d.getTime())) return '—';
	return d.toLocaleString('ru-RU');
};

const reviewTarget = (r: RecentRealUserReview) => {
	if (r.clinicName) return `Клиника: ${r.clinicName}`;
	if (r.doctorName) return `Врач: ${r.doctorName}`;
	return '—';
};
</script>

<template>
	<div class="user-info">
		<div class="toolbar">
			<el-checkbox v-model="realOnly">Только реальные</el-checkbox>
			<el-input
				v-model="searchQuery"
				placeholder="Поиск по id, email или имени"
				clearable
				class="search-input"
			/>
			<span class="counter">
				Показано: {{ filteredUsers.length }} из {{ props.users.length }}
			</span>
		</div>

		<el-table :data="filteredUsers" stripe size="small" class="users-table">
			<el-table-column label="ID" prop="id" width="80" />
			<el-table-column label="Фото" width="64">
				<template #default="{ row }">
					<img
						v-if="row.photoUrl"
						:src="row.photoUrl"
						width="36"
						height="36"
						class="avatar"
					/>
				</template>
			</el-table-column>
			<el-table-column label="Имя" prop="name" min-width="180" />
			<el-table-column label="Email / провайдер" min-width="220">
				<template #default="{ row }">
					<span v-if="row.email">{{ row.email }}</span>
					<span v-else-if="row.primaryOauthProvider" class="muted">
						{{ row.primaryOauthProvider }}
					</span>
					<span v-else class="muted">—</span>
				</template>
			</el-table-column>
			<el-table-column label="Тип" width="110">
				<template #default="{ row }">
					<el-tag v-if="row.isPhantom" type="info" size="small">
						phantom
					</el-tag>
					<el-tag v-else type="success" size="small">реальный</el-tag>
				</template>
			</el-table-column>
			<el-table-column
				label="Отзывов"
				prop="reviewsCount"
				width="100"
				align="right"
			/>
			<el-table-column label="Последний отзыв" width="160">
				<template #default="{ row }">
					{{ formatDate(row.lastReviewAt) }}
				</template>
			</el-table-column>
			<el-table-column label="Создан" width="140">
				<template #default="{ row }">
					{{ formatDate(row.createdAt) }}
				</template>
			</el-table-column>
		</el-table>

		<div class="recent-reviews">
			<h3>Последние 10 отзывов от реальных пользователей</h3>

			<div v-if="!props.recentReviews.length" class="empty">
				Пока нет отзывов от реальных пользователей.
			</div>

			<div
				v-for="review in props.recentReviews"
				:key="review.id"
				class="review-card"
			>
				<div class="review-header">
					<img
						v-if="review.authorPhotoUrl"
						:src="review.authorPhotoUrl"
						width="36"
						height="36"
						class="avatar"
					/>
					<div class="review-author">
						<div class="author-name">
							{{ review.authorName || 'Без имени' }}
						</div>
						<div class="author-meta">
							id={{ review.userId }} · {{ review.provider }}
						</div>
					</div>
					<div class="review-meta-right">
						<div v-if="review.rating" class="rating">
							{{ review.rating }}★
						</div>
						<div class="date">{{ formatDateTime(review.publishedAt) }}</div>
					</div>
				</div>

				<div class="review-target">
					#{{ review.id }} · {{ reviewTarget(review) }}
					<span v-if="review.originalLanguage" class="muted">
						({{ review.originalLanguage }})
					</span>
				</div>

				<div v-if="review.originalText" class="review-text">
					{{ review.originalText }}
				</div>
				<div v-else class="review-text muted">(текст отсутствует)</div>
			</div>
		</div>
	</div>
</template>

<style scoped lang="less">
.user-info {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
}

.toolbar {
	display: flex;
	align-items: center;
	gap: var(--spacing-md);
	flex-wrap: wrap;
}

.search-input {
	max-width: 320px;
}

.counter {
	color: var(--color-text-secondary);
	font-size: 0.9em;
}

.users-table {
	width: 100%;
}

.avatar {
	border-radius: 50%;
	object-fit: cover;
}

.muted {
	color: var(--color-text-secondary);
}

.recent-reviews {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
	padding-top: var(--spacing-md);
	border-top: 1px solid var(--color-border-primary);

	h3 {
		margin: 0;
		color: var(--color-text-primary);
	}
}

.empty {
	color: var(--color-text-secondary);
	font-style: italic;
}

.review-card {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
	padding: var(--spacing-md);
	background: var(--color-surface-secondary);
	border: 1px solid var(--color-border-primary);
	border-radius: var(--border-radius-md);
}

.review-header {
	display: flex;
	align-items: center;
	gap: var(--spacing-sm);
}

.review-author {
	flex: 1;
	display: flex;
	flex-direction: column;
}

.author-name {
	font-weight: 600;
	color: var(--color-text-primary);
}

.author-meta {
	font-size: 0.85em;
	color: var(--color-text-secondary);
}

.review-meta-right {
	display: flex;
	flex-direction: column;
	align-items: flex-end;
	gap: 2px;
}

.rating {
	font-weight: 600;
	color: var(--color-text-primary);
}

.date {
	font-size: 0.85em;
	color: var(--color-text-secondary);
}

.review-target {
	font-size: 0.9em;
	color: var(--color-text-secondary);
}

.review-text {
	white-space: pre-wrap;
	color: var(--color-text-primary);
	line-height: 1.5;
}
</style>
