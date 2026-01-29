# Итерация 2: Базовый функционал отзывов

[← К списку итераций](README.md) | [Следующая →](iteration-03-verification.md)

---

## Статус: 🔴 Not Started

---

## Цель

Реализовать полный цикл работы с внутренними отзывами: создание, редактирование, отображение, рейтинговую систему, сортировку и фильтрацию.

## Зависимости

**Требуется перед началом:**

- ✅ **Итерация 1** - база данных должна быть готова

**Блокирующие факторы:**

- Нет

---

## Задачи

### 1. API Endpoints

#### 1.1 Получение списка отзывов

**Файл:** `server/api/reviews/list.post.ts`

```typescript
export default defineEventHandler(async (event) => {
	const body = await readBody(event);
	const {
		targetType,
		targetId,
		page = 1,
		limit = 10,
		sortBy = 'date',
		sortOrder = 'desc',
		filters,
	} = body;

	// Валидация
	if (!['doctor', 'clinic'].includes(targetType)) {
		throw createError({ statusCode: 400, message: 'Invalid targetType' });
	}

	const offset = (page - 1) * limit;

	// Построение SQL запроса
	let query = `
    SELECT 
      r.*,
      u.name as author_name,
      u.photo_url as author_photo
    FROM reviews r
    LEFT JOIN users u ON r.user_id = u.id
    WHERE r.target_type = ? 
      AND r.target_id = ?
      AND r.status = 'approved'
      AND r.deleted_at IS NULL
  `;

	const params = [targetType, targetId];

	// Фильтры
	if (filters?.type) {
		query += ` AND r.review_type = ?`;
		params.push(filters.type);
	}

	if (filters?.rating) {
		query += ` AND r.rating = ?`;
		params.push(filters.rating);
	}

	if (filters?.verified) {
		query += ` AND r.is_verified = 1`;
	}

	// Сортировка
	if (sortBy === 'date') {
		query += ` ORDER BY r.created_at ${sortOrder === 'desc' ? 'DESC' : 'ASC'}`;
	} else if (sortBy === 'rating') {
		query += ` ORDER BY r.rating ${
			sortOrder === 'desc' ? 'DESC' : 'ASC'
		}, r.created_at DESC`;
	}

	query += ` LIMIT ? OFFSET ?`;
	params.push(limit, offset);

	// Выполнение запроса
	const reviews = await db.query(query, params);

	// Подсчет общего количества
	const countQuery = `SELECT COUNT(*) as total FROM reviews r WHERE ...`;
	const [{ total }] = await db.query(countQuery, [targetType, targetId]);

	return {
		reviews,
		pagination: {
			page,
			limit,
			total,
			totalPages: Math.ceil(total / limit),
		},
	};
});
```

#### 1.2 Создание отзыва

**Файл:** `server/api/reviews/create.post.ts`

```typescript
export default defineEventHandler(async (event) => {
	const session = await requireUserSession(event);
	const body = await readBody(event);

	const { targetType, targetId, rating, text, criteriaRatings } = body;

	// Валидация
	if (!['doctor', 'clinic'].includes(targetType)) {
		throw createError({ statusCode: 400, message: 'Invalid targetType' });
	}

	if (!rating || rating < 1 || rating > 5) {
		throw createError({
			statusCode: 400,
			message: 'Rating must be between 1 and 5',
		});
	}

	if (text && text.length < 10) {
		throw createError({
			statusCode: 400,
			message: 'Review text must be at least 10 characters',
		});
	}

	// Проверка: пользователь уже оставлял отзыв?
	const existingReview = await db.query(
		`SELECT id FROM reviews 
     WHERE user_id = ? AND target_type = ? AND target_id = ? AND deleted_at IS NULL`,
		[session.user.id, targetType, targetId],
	);

	if (existingReview.length > 0) {
		throw createError({
			statusCode: 400,
			message: 'You already reviewed this entity',
		});
	}

	// Rate limiting (опционально - через Redis или простая проверка времени)
	const recentReviews = await db.query(
		`SELECT id FROM reviews 
     WHERE user_id = ? AND created_at > DATE_SUB(NOW(), INTERVAL 1 HOUR)`,
		[session.user.id],
	);

	if (recentReviews.length > 0) {
		throw createError({
			statusCode: 429,
			message: 'Please wait before creating another review',
		});
	}

	// Создание отзыва
	const result = await db.query(
		`INSERT INTO reviews (
      target_type, target_id, user_id, review_type,
      rating, text, language, status,
      criteria_professionalism, criteria_attitude, criteria_quality, criteria_price_quality
    ) VALUES (?, ?, ?, 'internal', ?, ?, ?, 'pending', ?, ?, ?, ?)`,
		[
			targetType,
			targetId,
			session.user.id,
			rating,
			text || null,
			session.locale || 'ru',
			criteriaRatings?.professionalism || null,
			criteriaRatings?.attitude || null,
			criteriaRatings?.quality || null,
			criteriaRatings?.priceQuality || null,
		],
	);

	const reviewId = result.insertId;

	// Лог модерации
	await db.query(
		`INSERT INTO review_moderation_logs (review_id, action, moderator_id) 
     VALUES (?, 'created', NULL)`,
		[reviewId],
	);

	return { success: true, reviewId };
});
```

#### 1.3 Редактирование отзыва

**Файл:** `server/api/reviews/[id].put.ts`

```typescript
export default defineEventHandler(async (event) => {
	const session = await requireUserSession(event);
	const reviewId = getRouterParam(event, 'id');
	const body = await readBody(event);

	const { rating, text, criteriaRatings } = body;

	// Проверка существования отзыва
	const [review] = await db.query(
		`SELECT * FROM reviews WHERE id = ? AND deleted_at IS NULL`,
		[reviewId],
	);

	if (!review) {
		throw createError({ statusCode: 404, message: 'Review not found' });
	}

	// Проверка прав (только автор)
	if (review.user_id !== session.user.id) {
		throw createError({
			statusCode: 403,
			message: 'You can only edit your own reviews',
		});
	}

	// Проверка времени (можно редактировать только в течение 7 дней)
	const createdAt = new Date(review.created_at);
	const now = new Date();
	const daysDiff = (now - createdAt) / (1000 * 60 * 60 * 24);

	if (daysDiff > 7) {
		throw createError({
			statusCode: 403,
			message: 'You can only edit reviews within 7 days',
		});
	}

	// Обновление отзыва
	await db.query(
		`UPDATE reviews SET
      rating = ?,
      text = ?,
      criteria_professionalism = ?,
      criteria_attitude = ?,
      criteria_quality = ?,
      criteria_price_quality = ?,
      status = 'pending',
      updated_at = NOW()
     WHERE id = ?`,
		[
			rating,
			text || null,
			criteriaRatings?.professionalism || null,
			criteriaRatings?.attitude || null,
			criteriaRatings?.quality || null,
			criteriaRatings?.priceQuality || null,
			reviewId,
		],
	);

	// Лог модерации
	await db.query(
		`INSERT INTO review_moderation_logs (review_id, action, moderator_id) 
     VALUES (?, 'edited', NULL)`,
		[reviewId],
	);

	return { success: true };
});
```

#### 1.4 Удаление отзыва

**Файл:** `server/api/reviews/[id].delete.ts`

```typescript
export default defineEventHandler(async (event) => {
	const session = await requireUserSession(event);
	const reviewId = getRouterParam(event, 'id');

	// Проверка существования отзыва
	const [review] = await db.query(
		`SELECT * FROM reviews WHERE id = ? AND deleted_at IS NULL`,
		[reviewId],
	);

	if (!review) {
		throw createError({ statusCode: 404, message: 'Review not found' });
	}

	// Проверка прав (только автор или админ)
	if (
		review.user_id !== session.user.id &&
		session.user.role !== 'superadmin'
	) {
		throw createError({
			statusCode: 403,
			message: 'You can only delete your own reviews',
		});
	}

	// Soft delete
	await db.query(`UPDATE reviews SET deleted_at = NOW() WHERE id = ?`, [
		reviewId,
	]);

	// Лог модерации
	await db.query(
		`INSERT INTO review_moderation_logs (review_id, action, moderator_id) 
     VALUES (?, 'deleted', ?)`,
		[reviewId, session.user.id],
	);

	// Обновление кэшированного рейтинга
	await updateRatingCache(review.target_type, review.target_id);

	return { success: true };
});
```

#### 1.5 Получение статистики рейтингов

**Файл:** `server/api/reviews/rating-stats.get.ts`

```typescript
export default defineEventHandler(async (event) => {
	const query = getQuery(event);
	const { targetType, targetId } = query;

	// Валидация
	if (!['doctor', 'clinic'].includes(targetType as string)) {
		throw createError({ statusCode: 400, message: 'Invalid targetType' });
	}

	// Статистика
	const [stats] = await db.query(
		`SELECT 
      AVG(rating) as average_rating,
      COUNT(*) as reviews_count,
      SUM(CASE WHEN rating = 5 THEN 1 ELSE 0 END) as rating_5,
      SUM(CASE WHEN rating = 4 THEN 1 ELSE 0 END) as rating_4,
      SUM(CASE WHEN rating = 3 THEN 1 ELSE 0 END) as rating_3,
      SUM(CASE WHEN rating = 2 THEN 1 ELSE 0 END) as rating_2,
      SUM(CASE WHEN rating = 1 THEN 1 ELSE 0 END) as rating_1,
      AVG(criteria_professionalism) as avg_professionalism,
      AVG(criteria_attitude) as avg_attitude,
      AVG(criteria_quality) as avg_quality,
      AVG(criteria_price_quality) as avg_price_quality
     FROM reviews
     WHERE target_type = ? 
       AND target_id = ?
       AND status = 'approved'
       AND deleted_at IS NULL`,
		[targetType, targetId],
	);

	return {
		averageRating: stats.average_rating
			? parseFloat(stats.average_rating).toFixed(1)
			: null,
		totalReviews: stats.reviews_count,
		distribution: {
			5: stats.rating_5,
			4: stats.rating_4,
			3: stats.rating_3,
			2: stats.rating_2,
			1: stats.rating_1,
		},
		criteriaAverages: {
			professionalism: stats.avg_professionalism
				? parseFloat(stats.avg_professionalism).toFixed(1)
				: null,
			attitude: stats.avg_attitude
				? parseFloat(stats.avg_attitude).toFixed(1)
				: null,
			quality: stats.avg_quality
				? parseFloat(stats.avg_quality).toFixed(1)
				: null,
			priceQuality: stats.avg_price_quality
				? parseFloat(stats.avg_price_quality).toFixed(1)
				: null,
		},
	};
});
```

#### 1.6 Мои отзывы

**Файл:** `server/api/reviews/my-reviews.get.ts`

```typescript
export default defineEventHandler(async (event) => {
	const session = await requireUserSession(event);

	const reviews = await db.query(
		`SELECT 
      r.*,
      CASE 
        WHEN r.target_type = 'doctor' THEN d.name
        WHEN r.target_type = 'clinic' THEN c.name
      END as target_name
     FROM reviews r
     LEFT JOIN doctors d ON r.target_type = 'doctor' AND r.target_id = d.id
     LEFT JOIN clinics c ON r.target_type = 'clinic' AND r.target_id = c.id
     WHERE r.user_id = ? AND r.deleted_at IS NULL
     ORDER BY r.created_at DESC`,
		[session.user.id],
	);

	return { reviews };
});
```

### 2. Frontend компоненты

#### 2.1 Компонент списка отзывов

**Файл:** `components/review/list.vue`

```vue
<template>
	<div class="reviews-list">
		<!-- Фильтры и сортировка -->
		<div class="reviews-controls">
			<el-select v-model="sortBy" placeholder="Сортировка">
				<el-option label="По дате (новые)" value="date-desc" />
				<el-option label="По дате (старые)" value="date-asc" />
				<el-option label="По рейтингу (высокие)" value="rating-desc" />
				<el-option label="По рейтингу (низкие)" value="rating-asc" />
			</el-select>

			<el-select v-model="filterType" placeholder="Тип">
				<el-option label="Все" value="" />
				<el-option label="Внутренние" value="internal" />
				<el-option label="Внешние" value="external" />
				<el-option label="Подтвержденные" value="verified" />
			</el-select>

			<el-select v-model="filterRating" placeholder="Оценка">
				<el-option label="Все" value="" />
				<el-option label="5 звезд" :value="5" />
				<el-option label="4 звезды" :value="4" />
				<el-option label="3 звезды" :value="3" />
				<el-option label="2 звезды" :value="2" />
				<el-option label="1 звезда" :value="1" />
			</el-select>
		</div>

		<!-- Список отзывов -->
		<div v-if="reviews.length > 0" class="reviews-items">
			<ReviewItem v-for="review in reviews" :key="review.id" :review="review" />
		</div>

		<el-empty v-else description="Нет отзывов" />

		<!-- Пагинация -->
		<el-pagination
			v-if="pagination.totalPages > 1"
			v-model:current-page="currentPage"
			:page-size="pagination.limit"
			:total="pagination.total"
			layout="prev, pager, next"
			@current-change="loadReviews"
		/>
	</div>
</template>

<script setup lang="ts">
const props = defineProps<{
	targetType: 'doctor' | 'clinic';
	targetId: number;
}>();

const reviews = ref([]);
const pagination = ref({});
const currentPage = ref(1);
const sortBy = ref('date-desc');
const filterType = ref('');
const filterRating = ref('');

const loadReviews = async () => {
	const [sort, order] = sortBy.value.split('-');

	const { data } = await $fetch('/api/reviews/list', {
		method: 'POST',
		body: {
			targetType: props.targetType,
			targetId: props.targetId,
			page: currentPage.value,
			sortBy: sort,
			sortOrder: order,
			filters: {
				type: filterType.value || undefined,
				rating: filterRating.value || undefined,
				verified: filterType.value === 'verified' || undefined,
			},
		},
	});

	reviews.value = data.reviews;
	pagination.value = data.pagination;
};

watch([sortBy, filterType, filterRating], () => {
	currentPage.value = 1;
	loadReviews();
});

onMounted(() => {
	loadReviews();
});
</script>
```

#### 2.2 Компонент карточки отзыва

**Файл:** `components/review/item.vue`

```vue
<template>
	<div class="review-item">
		<!-- Автор -->
		<div class="review-author">
			<el-avatar :src="review.author_photo || '/default-avatar.png'" />
			<div class="review-author-info">
				<div class="review-author-name">
					{{ review.author_name || review.external_author_name }}
					<ReviewVerificationBadge v-if="review.is_verified" />
					<ReviewSourceBadge
						:type="review.review_type"
						:source="review.external_source"
					/>
				</div>
				<div class="review-date">
					{{ formatDate(review.created_at) }}
				</div>
			</div>
		</div>

		<!-- Рейтинг -->
		<div class="review-rating">
			<el-rate v-model="review.rating" disabled />
			<span class="review-rating-text">{{ review.rating }}/5</span>
		</div>

		<!-- Критерии (если есть) -->
		<div v-if="hasCriteria" class="review-criteria">
			<div v-if="review.criteria_professionalism" class="review-criterion">
				<span>Профессионализм:</span>
				<el-rate
					v-model="review.criteria_professionalism"
					disabled
					size="small"
				/>
			</div>
			<!-- ... остальные критерии -->
		</div>

		<!-- Текст отзыва -->
		<div v-if="review.text" class="review-text">
			{{ review.text }}
		</div>

		<!-- Внешний источник (если внешний отзыв) -->
		<div
			v-if="review.review_type === 'external' && review.external_source_url"
			class="review-source"
		>
			<a :href="review.external_source_url" target="_blank" rel="noopener">
				Смотреть оригинал на {{ review.external_source }}
			</a>
		</div>
	</div>
</template>

<script setup lang="ts">
defineProps<{
	review: any;
}>();

const hasCriteria = computed(() => {
	return (
		review.criteria_professionalism ||
		review.criteria_attitude ||
		review.criteria_quality ||
		review.criteria_price_quality
	);
});

const formatDate = (date: string) => {
	return new Date(date).toLocaleDateString('ru-RU', {
		year: 'numeric',
		month: 'long',
		day: 'numeric',
	});
};
</script>
```

#### 2.3 Диалог создания отзыва

**Файл:** `components/review/create-dialog.vue`

```vue
<template>
	<el-dialog v-model="visible" title="Написать отзыв" width="600px">
		<el-form :model="form" label-position="top">
			<!-- Общая оценка -->
			<el-form-item label="Общая оценка" required>
				<el-rate v-model="form.rating" :texts="ratingTexts" show-text />
			</el-form-item>

			<!-- Дополнительные оценки -->
			<el-divider>Дополнительные оценки (опционально)</el-divider>

			<el-form-item label="Профессионализм">
				<el-rate v-model="form.criteriaRatings.professionalism" />
			</el-form-item>

			<el-form-item label="Отношение к пациентам">
				<el-rate v-model="form.criteriaRatings.attitude" />
			</el-form-item>

			<el-form-item label="Качество обслуживания">
				<el-rate v-model="form.criteriaRatings.quality" />
			</el-form-item>

			<el-form-item label="Соотношение цена/качество">
				<el-rate v-model="form.criteriaRatings.priceQuality" />
			</el-form-item>

			<!-- Текст отзыва -->
			<el-form-item label="Ваш отзыв (опционально)">
				<el-input
					v-model="form.text"
					type="textarea"
					:rows="5"
					placeholder="Расскажите о своем опыте посещения..."
				/>
				<span v-if="form.text" class="char-count">
					{{ form.text.length }} символов
				</span>
			</el-form-item>
		</el-form>

		<template #footer>
			<el-button @click="visible = false">Отмена</el-button>
			<el-button type="primary" :loading="loading" @click="submit">
				Отправить
			</el-button>
		</template>
	</el-dialog>
</template>

<script setup lang="ts">
const props = defineProps<{
	targetType: 'doctor' | 'clinic';
	targetId: number;
}>();

const emit = defineEmits(['created']);

const visible = ref(false);
const loading = ref(false);

const form = reactive({
	rating: 5,
	text: '',
	criteriaRatings: {
		professionalism: 0,
		attitude: 0,
		quality: 0,
		priceQuality: 0,
	},
});

const ratingTexts = ['Ужасно', 'Плохо', 'Нормально', 'Хорошо', 'Отлично'];

const submit = async () => {
	if (!form.rating) {
		ElMessage.error('Пожалуйста, поставьте оценку');
		return;
	}

	if (form.text && form.text.length < 10) {
		ElMessage.error('Отзыв должен содержать минимум 10 символов');
		return;
	}

	loading.value = true;

	try {
		await $fetch('/api/reviews/create', {
			method: 'POST',
			body: {
				targetType: props.targetType,
				targetId: props.targetId,
				rating: form.rating,
				text: form.text || null,
				criteriaRatings: form.criteriaRatings,
			},
		});

		ElMessage.success('Отзыв отправлен на модерацию');
		visible.value = false;
		emit('created');
	} catch (error) {
		ElMessage.error(error.data?.message || 'Ошибка при создании отзыва');
	} finally {
		loading.value = false;
	}
};

defineExpose({ visible });
</script>
```

#### 2.4 Карточка с итоговой статистикой

**Файл:** `components/review/summary-card.vue`

```vue
<template>
	<div class="review-summary-card">
		<!-- Средний рейтинг -->
		<div class="summary-rating">
			<div class="summary-rating-number">{{
				stats.averageRating || 'N/A'
			}}</div>
			<el-rate v-model="ratingValue" disabled />
			<div class="summary-reviews-count">
				{{ stats.totalReviews }} {{ reviewsWord }}
			</div>
		</div>

		<!-- Распределение по звездам -->
		<div class="summary-distribution">
			<div v-for="star in [5, 4, 3, 2, 1]" :key="star" class="distribution-row">
				<span class="distribution-star">{{ star }} ★</span>
				<el-progress
					:percentage="getPercentage(star)"
					:show-text="false"
					:stroke-width="8"
				/>
				<span class="distribution-count">{{
					stats.distribution[star] || 0
				}}</span>
			</div>
		</div>

		<!-- Критерии (если есть) -->
		<div v-if="hasCriteriaAverages" class="summary-criteria">
			<el-divider>Средние оценки по критериям</el-divider>
			<div v-if="stats.criteriaAverages.professionalism" class="criterion-row">
				<span>Профессионализм</span>
				<el-rate
					:model-value="parseFloat(stats.criteriaAverages.professionalism)"
					disabled
					size="small"
				/>
				<span>{{ stats.criteriaAverages.professionalism }}</span>
			</div>
			<!-- ... остальные критерии -->
		</div>
	</div>
</template>

<script setup lang="ts">
const props = defineProps<{
	targetType: 'doctor' | 'clinic';
	targetId: number;
}>();

const stats = ref({});
const ratingValue = ref(0);

const loadStats = async () => {
	const data = await $fetch(`/api/reviews/rating-stats`, {
		params: {
			targetType: props.targetType,
			targetId: props.targetId,
		},
	});

	stats.value = data;
	ratingValue.value = parseFloat(data.averageRating || 0);
};

const getPercentage = (star: number) => {
	const count = stats.value.distribution?.[star] || 0;
	const total = stats.value.totalReviews || 1;
	return Math.round((count / total) * 100);
};

const reviewsWord = computed(() => {
	const count = stats.value.totalReviews || 0;
	if (count % 10 === 1 && count % 100 !== 11) return 'отзыв';
	if ([2, 3, 4].includes(count % 10) && ![12, 13, 14].includes(count % 100))
		return 'отзыва';
	return 'отзывов';
});

const hasCriteriaAverages = computed(() => {
	return (
		stats.value.criteriaAverages?.professionalism ||
		stats.value.criteriaAverages?.attitude ||
		stats.value.criteriaAverages?.quality ||
		stats.value.criteriaAverages?.priceQuality
	);
});

onMounted(() => {
	loadStats();
});
</script>
```

### 3. Интеграция в страницы врачей и клиник

#### 3.1 Секция отзывов на странице врача

**Файл:** `components/doctor/reviews-section.vue`

```vue
<template>
	<div class="doctor-reviews-section">
		<h2>Отзывы пациентов</h2>

		<!-- Сводка рейтинга -->
		<ReviewSummaryCard :target-type="'doctor'" :target-id="doctorId" />

		<!-- Кнопка создания отзыва (если авторизован) -->
		<div v-if="isAuthenticated" class="review-create-button">
			<el-button type="primary" @click="openCreateDialog">
				Написать отзыв
			</el-button>
		</div>

		<!-- Список отзывов -->
		<ReviewList :target-type="'doctor'" :target-id="doctorId" />

		<!-- Диалог создания -->
		<ReviewCreateDialog
			ref="createDialog"
			:target-type="'doctor'"
			:target-id="doctorId"
			@created="onReviewCreated"
		/>
	</div>
</template>

<script setup lang="ts">
const props = defineProps<{
	doctorId: number;
}>();

const { status } = useAuth();
const isAuthenticated = computed(() => status.value === 'authenticated');

const createDialog = ref();

const openCreateDialog = () => {
	createDialog.value.visible = true;
};

const onReviewCreated = () => {
	// Перезагрузить список отзывов
	location.reload(); // Или лучше использовать event bus
};
</script>
```

### 4. Страница "Мои отзывы"

**Файл:** `pages/profile/my-reviews.vue`

```vue
<template>
	<div class="my-reviews-page">
		<h1>Мои отзывы</h1>

		<!-- Табы по статусам -->
		<el-tabs v-model="activeTab">
			<el-tab-pane label="Все" name="all" />
			<el-tab-pane label="На модерации" name="pending" />
			<el-tab-pane label="Одобренные" name="approved" />
			<el-tab-pane label="Отклоненные" name="rejected" />
		</el-tabs>

		<!-- Список моих отзывов -->
		<div v-if="filteredReviews.length > 0" class="my-reviews-list">
			<div
				v-for="review in filteredReviews"
				:key="review.id"
				class="my-review-item"
			>
				<div class="review-target">
					<strong>{{
						review.target_type === 'doctor' ? 'Врач:' : 'Клиника:'
					}}</strong>
					{{ review.target_name }}
				</div>

				<ReviewItem :review="review" />

				<div class="review-actions">
					<el-tag :type="getStatusType(review.status)">
						{{ getStatusText(review.status) }}
					</el-tag>

					<div class="review-buttons">
						<el-button
							v-if="canEdit(review)"
							size="small"
							@click="editReview(review)"
						>
							Редактировать
						</el-button>
						<el-button
							size="small"
							type="danger"
							@click="deleteReview(review.id)"
						>
							Удалить
						</el-button>
					</div>
				</div>

				<div
					v-if="review.status === 'rejected' && review.rejection_reason"
					class="rejection-reason"
				>
					<el-alert type="error" :closable="false">
						Причина отклонения: {{ review.rejection_reason }}
					</el-alert>
				</div>
			</div>
		</div>

		<el-empty v-else description="У вас пока нет отзывов" />
	</div>
</template>

<script setup lang="ts">
const activeTab = ref('all');
const reviews = ref([]);

const loadMyReviews = async () => {
	const data = await $fetch('/api/reviews/my-reviews');
	reviews.value = data.reviews;
};

const filteredReviews = computed(() => {
	if (activeTab.value === 'all') return reviews.value;
	return reviews.value.filter((r) => r.status === activeTab.value);
});

const canEdit = (review) => {
	const createdAt = new Date(review.created_at);
	const now = new Date();
	const daysDiff = (now - createdAt) / (1000 * 60 * 60 * 24);
	return daysDiff <= 7;
};

const deleteReview = async (id: number) => {
	if (!confirm('Вы уверены, что хотите удалить отзыв?')) return;

	try {
		await $fetch(`/api/reviews/${id}`, { method: 'DELETE' });
		ElMessage.success('Отзыв удален');
		loadMyReviews();
	} catch (error) {
		ElMessage.error('Ошибка при удалении отзыва');
	}
};

onMounted(() => {
	loadMyReviews();
});
</script>
```

---

## Критерии приемки (Acceptance Criteria)

- [ ] **AC-1:** API endpoints созданы и работают корректно
- [ ] **AC-2:** Пользователь может создать отзыв с оценкой и текстом
- [ ] **AC-3:** Пользователь может добавить дополнительные оценки по критериям
- [ ] **AC-4:** Пользователь может редактировать отзыв в течение 7 дней
- [ ] **AC-5:** Пользователь может удалить свой отзыв
- [ ] **AC-6:** Отзывы отображаются на страницах врачей и клиник
- [ ] **AC-7:** Средний рейтинг и распределение рассчитываются корректно
- [ ] **AC-8:** Сортировка отзывов работает (по дате, по рейтингу)
- [ ] **AC-9:** Фильтрация отзывов работает (по типу, по оценке)
- [ ] **AC-10:** Страница "Мои отзывы" отображает все отзывы пользователя
- [ ] **AC-11:** Пользователь не может оставить более одного отзыва на врача/клинику
- [ ] **AC-12:** Rate limiting работает (не более 1 отзыва в час)
- [ ] **AC-13:** Новые отзывы имеют статус "pending" и требуют модерации

---

## Как проверить

1. Создать тестового пользователя
2. Перейти на страницу врача или клиники
3. Нажать "Написать отзыв"
4. Заполнить форму и отправить
5. Проверить, что отзыв появился в "Мои отзывы" со статусом "На модерации"
6. Проверить редактирование и удаление отзыва
7. Проверить отображение статистики рейтингов
8. Проверить сортировку и фильтрацию

---

## Оценка времени

**Ожидаемое время:** 3 дня  
**Сложность:** Средняя

---

**Назад:** [← К списку итераций](README.md)  
**Далее:** [Итерация 3: Верификация отзывов →](iteration-03-verification.md)
