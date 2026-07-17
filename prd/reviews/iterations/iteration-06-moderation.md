# Итерация 6: Модерация и управление отзывами

[← К списку итераций](README.md)

---

## Статус: 🟢 Done (2026-06-12)

> Реализовано с отступлениями (см. PROGRESS.md): ПОСТ-модерация (pending
> виден публично, rejected скрывается, автор видит причину); модерация —
> суб-таб «Модерация» в табе «Отзывы» админки (`pages/admin/index.vue` +
> `components/admin/review-moderation.vue`), не отдельная страница; роль —
> `is_admin`; очереди жалоб нет (механизм repоrts отсутствует в продукте).
> API: `GET /api/admin/reviews/queue`, `POST /api/admin/reviews/moderate`,
> `POST /api/admin/reviews/verify`. Код-примеры ниже — исходный псевдокод PRD.

---

## Цель

Создать полноценную админ панель для модерации отзывов, верификационных файлов и управления контентом с логированием всех действий модераторов.

## Зависимости

**Требуется перед началом:**

- ✅ **Итерация 2** - базовый функционал отзывов
- ✅ **Итерация 3** - верификация отзывов
- ✅ **Итерация 4** - внешние отзывы
- ✅ **permissions** - система ролей (модератор, суперадмин)

**Блокирующие факторы:**

- Нет

---

## Задачи

### 1. API для модерации

#### 1.1 Список отзывов на модерации

**Файл:** `server/api/admin/reviews/pending.get.ts`

```typescript
export default defineEventHandler(async (event) => {
	const session = await requireUserSession(event);

	// Проверка прав (только модераторы и суперадмины)
	if (!['moderator', 'superadmin'].includes(session.user.role)) {
		throw createError({ statusCode: 403, message: 'Forbidden' });
	}

	const query = getQuery(event);
	const { page = 1, limit = 20, type = 'pending' } = query; // type: pending | verification

	const offset = (parseInt(page) - 1) * parseInt(limit);

	if (type === 'pending') {
		// Отзывы на модерации (текст)
		const reviews = await db.query(
			`SELECT 
        r.*,
        u.name as author_name,
        u.email as author_email,
        CASE 
          WHEN r.target_type = 'doctor' THEN d.name
          WHEN r.target_type = 'clinic' THEN c.name
        END as target_name
       FROM reviews r
       LEFT JOIN users u ON r.user_id = u.id
       LEFT JOIN doctors d ON r.target_type = 'doctor' AND r.target_id = d.id
       LEFT JOIN clinics c ON r.target_type = 'clinic' AND r.target_id = c.id
       WHERE r.status = 'pending' AND r.deleted_at IS NULL
       ORDER BY r.created_at ASC
       LIMIT ? OFFSET ?`,
			[parseInt(limit), offset],
		);

		const [{ total }] = await db.query(
			`SELECT COUNT(*) as total FROM reviews 
       WHERE status = 'pending' AND deleted_at IS NULL`,
		);

		return {
			reviews,
			pagination: {
				page: parseInt(page),
				limit: parseInt(limit),
				total,
				totalPages: Math.ceil(total / parseInt(limit)),
			},
		};
	} else if (type === 'verification') {
		// Файлы верификации на проверке
		const files = await db.query(
			`SELECT 
        vf.*,
        r.target_type,
        r.target_id,
        r.rating,
        r.text,
        u.name as author_name,
        CASE 
          WHEN r.target_type = 'doctor' THEN d.name
          WHEN r.target_type = 'clinic' THEN c.name
        END as target_name
       FROM review_verification_files vf
       JOIN reviews r ON vf.review_id = r.id
       LEFT JOIN users u ON r.user_id = u.id
       LEFT JOIN doctors d ON r.target_type = 'doctor' AND r.target_id = d.id
       LEFT JOIN clinics c ON r.target_type = 'clinic' AND r.target_id = c.id
       WHERE vf.verification_status = 'pending'
       ORDER BY vf.uploaded_at ASC
       LIMIT ? OFFSET ?`,
			[parseInt(limit), offset],
		);

		const [{ total }] = await db.query(
			`SELECT COUNT(*) as total FROM review_verification_files 
       WHERE verification_status = 'pending'`,
		);

		return {
			files,
			pagination: {
				page: parseInt(page),
				limit: parseInt(limit),
				total,
				totalPages: Math.ceil(total / parseInt(limit)),
			},
		};
	}
});
```

#### 1.2 Модерация отзыва

**Файл:** `server/api/admin/reviews/[id]/moderate.post.ts`

```typescript
export default defineEventHandler(async (event) => {
	const session = await requireUserSession(event);
	const reviewId = getRouterParam(event, 'id');
	const body = await readBody(event);

	// Проверка прав
	if (!['moderator', 'superadmin'].includes(session.user.role)) {
		throw createError({ statusCode: 403, message: 'Forbidden' });
	}

	const { action, reason } = body; // action: 'approve' | 'reject'

	if (!['approve', 'reject'].includes(action)) {
		throw createError({ statusCode: 400, message: 'Invalid action' });
	}

	// Проверка существования отзыва
	const [review] = await db.query(
		`SELECT * FROM reviews WHERE id = ? AND deleted_at IS NULL`,
		[reviewId],
	);

	if (!review) {
		throw createError({ statusCode: 404, message: 'Review not found' });
	}

	// Обновление статуса
	await db.query(
		`UPDATE reviews 
     SET status = ?,
         moderated_at = NOW(),
         moderated_by = ?,
         rejection_reason = ?
     WHERE id = ?`,
		[
			action === 'approve' ? 'approved' : 'rejected',
			session.user.id,
			action === 'reject' ? reason : null,
			reviewId,
		],
	);

	// Лог модерации
	await db.query(
		`INSERT INTO review_moderation_logs (review_id, action, moderator_id, comment) 
     VALUES (?, ?, ?, ?)`,
		[
			reviewId,
			action === 'approve' ? 'approved' : 'rejected',
			session.user.id,
			reason || null,
		],
	);

	// Если одобрено - обновить кэшированный рейтинг
	if (action === 'approve') {
		await updateRatingCache(review.target_type, review.target_id);
	}

	return { success: true };
});
```

#### 1.3 Статистика модерации

**Файл:** `server/api/admin/reviews/moderation-stats.get.ts`

```typescript
export default defineEventHandler(async (event) => {
	const session = await requireUserSession(event);

	// Проверка прав
	if (!['moderator', 'superadmin'].includes(session.user.role)) {
		throw createError({ statusCode: 403, message: 'Forbidden' });
	}

	// Общая статистика
	const [stats] = await db.query(`
    SELECT 
      COUNT(*) as total_reviews,
      SUM(CASE WHEN status = 'pending' THEN 1 ELSE 0 END) as pending_reviews,
      SUM(CASE WHEN status = 'approved' THEN 1 ELSE 0 END) as approved_reviews,
      SUM(CASE WHEN status = 'rejected' THEN 1 ELSE 0 END) as rejected_reviews,
      SUM(CASE WHEN is_verified = TRUE THEN 1 ELSE 0 END) as verified_reviews
    FROM reviews
    WHERE deleted_at IS NULL
  `);

	// Статистика верификации
	const [verificationStats] = await db.query(`
    SELECT 
      COUNT(*) as total_files,
      SUM(CASE WHEN verification_status = 'pending' THEN 1 ELSE 0 END) as pending_files,
      SUM(CASE WHEN verification_status = 'approved' THEN 1 ELSE 0 END) as approved_files,
      SUM(CASE WHEN verification_status = 'rejected' THEN 1 ELSE 0 END) as rejected_files
    FROM review_verification_files
  `);

	// Топ модераторов (по количеству одобренных отзывов)
	const topModerators = await db.query(`
    SELECT 
      u.name as moderator_name,
      COUNT(*) as moderated_count
    FROM review_moderation_logs ml
    JOIN users u ON ml.moderator_id = u.id
    WHERE ml.action IN ('approved', 'rejected')
      AND ml.created_at > DATE_SUB(NOW(), INTERVAL 30 DAY)
    GROUP BY ml.moderator_id, u.name
    ORDER BY moderated_count DESC
    LIMIT 10
  `);

	// Средний рейтинг за последние 7 дней
	const [avgRating] = await db.query(`
    SELECT AVG(rating) as avg_rating
    FROM reviews
    WHERE created_at > DATE_SUB(NOW(), INTERVAL 7 DAY)
      AND status = 'approved'
      AND deleted_at IS NULL
  `);

	return {
		reviews: stats,
		verification: verificationStats,
		topModerators,
		averageRating: avgRating.avg_rating
			? parseFloat(avgRating.avg_rating).toFixed(1)
			: null,
	};
});
```

### 2. Frontend компоненты админ панели

#### 2.1 Страница модерации отзывов

**Файл:** `pages/admin/reviews/moderation.vue`

```vue
<template>
	<div class="admin-moderation">
		<h1>Модерация отзывов</h1>

		<!-- Статистика -->
		<div class="moderation-stats">
			<el-card>
				<template #header>Статистика</template>
				<div v-if="stats" class="stats-grid">
					<div class="stat-item">
						<div class="stat-value">{{
							stats.reviews?.pending_reviews || 0
						}}</div>
						<div class="stat-label">На модерации</div>
					</div>
					<div class="stat-item">
						<div class="stat-value">{{
							stats.verification?.pending_files || 0
						}}</div>
						<div class="stat-label">Верификация ожидает</div>
					</div>
					<div class="stat-item">
						<div class="stat-value">{{
							stats.reviews?.approved_reviews || 0
						}}</div>
						<div class="stat-label">Одобрено</div>
					</div>
					<div class="stat-item">
						<div class="stat-value">{{
							stats.reviews?.rejected_reviews || 0
						}}</div>
						<div class="stat-label">Отклонено</div>
					</div>
				</div>
			</el-card>
		</div>

		<!-- Табы -->
		<el-tabs v-model="activeTab" @tab-change="loadItems">
			<el-tab-pane label="Отзывы на модерации" name="pending">
				<div v-if="reviews.length > 0" class="moderation-list">
					<el-card
						v-for="review in reviews"
						:key="review.id"
						class="review-card"
					>
						<!-- Информация об отзыве -->
						<div class="review-info">
							<div class="review-target">
								<strong
									>{{
										review.target_type === 'doctor' ? 'Врач' : 'Клиника'
									}}:</strong
								>
								{{ review.target_name }} (ID: {{ review.target_id }})
							</div>
							<div class="review-author">
								<strong>Автор:</strong> {{ review.author_name }} ({{
									review.author_email
								}})
							</div>
							<div class="review-date">
								<strong>Дата:</strong> {{ formatDate(review.created_at) }}
							</div>
						</div>

						<!-- Контент отзыва -->
						<div class="review-content">
							<div class="review-rating">
								<strong>Оценка:</strong>
								<el-rate v-model="review.rating" disabled />
								{{ review.rating }}/5
							</div>

							<div v-if="review.text" class="review-text">
								<strong>Текст:</strong>
								<p>{{ review.text }}</p>
							</div>

							<!-- Критерии -->
							<div v-if="hasCriteria(review)" class="review-criteria">
								<strong>Дополнительные оценки:</strong>
								<div v-if="review.criteria_professionalism">
									Профессионализм:
									<el-rate
										v-model="review.criteria_professionalism"
										disabled
										size="small"
									/>
								</div>
								<div v-if="review.criteria_attitude">
									Отношение:
									<el-rate
										v-model="review.criteria_attitude"
										disabled
										size="small"
									/>
								</div>
								<div v-if="review.criteria_quality">
									Качество:
									<el-rate
										v-model="review.criteria_quality"
										disabled
										size="small"
									/>
								</div>
								<div v-if="review.criteria_price_quality">
									Цена/качество:
									<el-rate
										v-model="review.criteria_price_quality"
										disabled
										size="small"
									/>
								</div>
							</div>
						</div>

						<!-- Действия -->
						<div class="review-actions">
							<el-button
								type="success"
								@click="moderateReview(review.id, 'approve')"
							>
								Одобрить
							</el-button>
							<el-button type="danger" @click="openRejectDialog(review.id)">
								Отклонить
							</el-button>
						</div>
					</el-card>
				</div>

				<el-empty v-else description="Нет отзывов на модерации" />
			</el-tab-pane>

			<el-tab-pane label="Верификация" name="verification">
				<div v-if="verificationFiles.length > 0" class="moderation-list">
					<el-card
						v-for="file in verificationFiles"
						:key="file.id"
						class="verification-card"
					>
						<!-- Информация об отзыве -->
						<div class="review-info">
							<div class="review-target">
								<strong
									>{{
										file.target_type === 'doctor' ? 'Врач' : 'Клиника'
									}}:</strong
								>
								{{ file.target_name }} (ID: {{ file.target_id }})
							</div>
							<div class="review-author">
								<strong>Автор:</strong> {{ file.author_name }}
							</div>
							<div class="review-rating">
								<strong>Оценка отзыва:</strong>
								<el-rate :model-value="file.rating" disabled size="small" />
							</div>
						</div>

						<!-- Файл верификации -->
						<div class="verification-file">
							<strong>Файл верификации:</strong>
							<div class="file-preview">
								<img
									v-if="file.file_type.startsWith('image/')"
									:src="file.file_path"
									alt="Verification"
									style="max-width: 100%; max-height: 400px;"
								/>
								<iframe
									v-else-if="file.file_type === 'application/pdf'"
									:src="file.file_path"
									style="width: 100%; height: 400px;"
								/>
							</div>
						</div>

						<!-- Действия -->
						<div class="verification-actions">
							<el-button
								type="success"
								@click="verifyFile(file.review_id, 'approve')"
							>
								Одобрить верификацию
							</el-button>
							<el-button
								type="danger"
								@click="openVerifyRejectDialog(file.review_id)"
							>
								Отклонить
							</el-button>
						</div>
					</el-card>
				</div>

				<el-empty v-else description="Нет файлов на проверке" />
			</el-tab-pane>
		</el-tabs>

		<!-- Пагинация -->
		<el-pagination
			v-if="pagination.totalPages > 1"
			v-model:current-page="currentPage"
			:page-size="pagination.limit"
			:total="pagination.total"
			layout="prev, pager, next, total"
			@current-change="loadItems"
		/>

		<!-- Диалог отклонения отзыва -->
		<el-dialog v-model="showRejectDialog" title="Причина отклонения">
			<el-input
				v-model="rejectReason"
				type="textarea"
				:rows="3"
				placeholder="Укажите причину отклонения..."
			/>
			<template #footer>
				<el-button @click="showRejectDialog = false">Отмена</el-button>
				<el-button type="danger" @click="rejectReview">Отклонить</el-button>
			</template>
		</el-dialog>

		<!-- Диалог отклонения верификации -->
		<el-dialog
			v-model="showVerifyRejectDialog"
			title="Причина отклонения верификации"
		>
			<el-input
				v-model="verifyRejectReason"
				type="textarea"
				:rows="3"
				placeholder="Укажите причину отклонения..."
			/>
			<template #footer>
				<el-button @click="showVerifyRejectDialog = false">Отмена</el-button>
				<el-button type="danger" @click="rejectVerification"
					>Отклонить</el-button
				>
			</template>
		</el-dialog>
	</div>
</template>

<script setup lang="ts">
definePageMeta({
	middleware: ['auth', 'moderator'], // Требуется роль модератора
});

const activeTab = ref('pending');
const currentPage = ref(1);
const reviews = ref([]);
const verificationFiles = ref([]);
const pagination = ref({});
const stats = ref(null);

const showRejectDialog = ref(false);
const rejectReason = ref('');
const currentReviewId = ref(null);

const showVerifyRejectDialog = ref(false);
const verifyRejectReason = ref('');
const currentVerifyId = ref(null);

// Загрузка статистики
const loadStats = async () => {
	const data = await $fetch('/api/admin/reviews/moderation-stats');
	stats.value = data;
};

// Загрузка элементов
const loadItems = async () => {
	const data = await $fetch('/api/admin/reviews/pending', {
		params: {
			page: currentPage.value,
			type: activeTab.value,
		},
	});

	if (activeTab.value === 'pending') {
		reviews.value = data.reviews;
	} else {
		verificationFiles.value = data.files;
	}

	pagination.value = data.pagination;
};

// Модерация отзыва
const moderateReview = async (
	reviewId: number,
	action: 'approve' | 'reject',
) => {
	try {
		await $fetch(`/api/admin/reviews/${reviewId}/moderate`, {
			method: 'POST',
			body: { action },
		});

		ElMessage.success(
			action === 'approve' ? 'Отзыв одобрен' : 'Отзыв отклонен',
		);
		loadItems();
		loadStats();
	} catch (error) {
		ElMessage.error('Ошибка при модерации');
	}
};

const openRejectDialog = (reviewId: number) => {
	currentReviewId.value = reviewId;
	rejectReason.value = '';
	showRejectDialog.value = true;
};

const rejectReview = async () => {
	if (!rejectReason.value) {
		ElMessage.error('Укажите причину отклонения');
		return;
	}

	try {
		await $fetch(`/api/admin/reviews/${currentReviewId.value}/moderate`, {
			method: 'POST',
			body: {
				action: 'reject',
				reason: rejectReason.value,
			},
		});

		ElMessage.success('Отзыв отклонен');
		showRejectDialog.value = false;
		loadItems();
		loadStats();
	} catch (error) {
		ElMessage.error('Ошибка при отклонении');
	}
};

// Верификация файла
const verifyFile = async (reviewId: number, action: 'approve' | 'reject') => {
	try {
		await $fetch(`/api/admin/reviews/${reviewId}/verify`, {
			method: 'POST',
			body: { action },
		});

		ElMessage.success(
			action === 'approve' ? 'Верификация одобрена' : 'Верификация отклонена',
		);
		loadItems();
		loadStats();
	} catch (error) {
		ElMessage.error('Ошибка при верификации');
	}
};

const openVerifyRejectDialog = (reviewId: number) => {
	currentVerifyId.value = reviewId;
	verifyRejectReason.value = '';
	showVerifyRejectDialog.value = true;
};

const rejectVerification = async () => {
	if (!verifyRejectReason.value) {
		ElMessage.error('Укажите причину отклонения');
		return;
	}

	try {
		await $fetch(`/api/admin/reviews/${currentVerifyId.value}/verify`, {
			method: 'POST',
			body: {
				action: 'reject',
				reason: verifyRejectReason.value,
			},
		});

		ElMessage.success('Верификация отклонена');
		showVerifyRejectDialog.value = false;
		loadItems();
		loadStats();
	} catch (error) {
		ElMessage.error('Ошибка при отклонении');
	}
};

// Helpers
const hasCriteria = (review: any) => {
	return (
		review.criteria_professionalism ||
		review.criteria_attitude ||
		review.criteria_quality ||
		review.criteria_price_quality
	);
};

const formatDate = (date: string) => {
	return new Date(date).toLocaleString('ru-RU');
};

// Watchers
watch(activeTab, () => {
	currentPage.value = 1;
	loadItems();
});

onMounted(() => {
	loadStats();
	loadItems();
});
</script>

<style scoped>
.moderation-stats {
	margin-bottom: 24px;
}

.stats-grid {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	gap: 16px;
}

.stat-item {
	text-align: center;
}

.stat-value {
	font-size: 32px;
	font-weight: bold;
	color: var(--el-color-primary);
}

.stat-label {
	font-size: 14px;
	color: var(--el-text-color-secondary);
	margin-top: 4px;
}

.moderation-list {
	display: flex;
	flex-direction: column;
	gap: 16px;
}

.review-card,
.verification-card {
	padding: 16px;
}

.review-info {
	margin-bottom: 16px;
	padding-bottom: 16px;
	border-bottom: 1px solid var(--el-border-color);
}

.review-info > div {
	margin-bottom: 8px;
}

.review-content {
	margin-bottom: 16px;
}

.review-content > div {
	margin-bottom: 12px;
}

.review-text p {
	margin: 8px 0 0 0;
	padding: 12px;
	background: var(--el-fill-color-light);
	border-radius: 4px;
	line-height: 1.6;
}

.review-actions,
.verification-actions {
	display: flex;
	gap: 8px;
	justify-content: flex-end;
}

.file-preview {
	margin-top: 12px;
	border: 1px solid var(--el-border-color);
	border-radius: 4px;
	overflow: hidden;
}
</style>
```

---

## Критерии приемки (Acceptance Criteria)

- [ ] **AC-1:** Модераторы могут видеть список отзывов на модерации
- [ ] **AC-2:** Модераторы могут одобрить отзыв (статус "approved")
- [ ] **AC-3:** Модераторы могут отклонить отзыв с указанием причины (статус "rejected")
- [ ] **AC-4:** Модераторы могут просматривать файлы верификации
- [ ] **AC-5:** Модераторы могут одобрить/отклонить верификацию
- [ ] **AC-6:** Все действия модераторов логируются в `review_moderation_logs`
- [ ] **AC-7:** Статистика модерации отображается (на модерации, одобрено, отклонено)
- [ ] **AC-8:** Пагинация работает корректно
- [ ] **AC-9:** Только модераторы и суперадмины имеют доступ к панели модерации
- [ ] **AC-10:** При одобрении отзыва обновляется кэшированный рейтинг
- [ ] **AC-11:** Отклоненные отзывы не отображаются публично
- [ ] **AC-12:** Пользователи видят причину отклонения своих отзывов

---

## Как проверить

1. Зайти в систему как модератор
2. Перейти в "Модерация отзывов"
3. Проверить отображение статистики
4. Открыть таб "Отзывы на модерации"
5. Одобрить несколько отзывов
6. Отклонить отзыв с указанием причины
7. Открыть таб "Верификация"
8. Одобрить/отклонить файлы верификации
9. Проверить, что логи модерации сохранены
10. Проверить, что отклоненные отзывы не отображаются публично

---

## Оценка времени

**Ожидаемое время:** 2 дня  
**Сложность:** Средняя

---

**Назад:** [← К списку итераций](README.md)  
**В начало:** [← К оглавлению PRD](../index.md)
