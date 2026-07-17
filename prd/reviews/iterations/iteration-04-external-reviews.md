# Итерация 4: Внешние отзывы

[← К списку итераций](README.md) | [Следующая →](iteration-05-ai-summary.md)

---

## Статус: 🟢 Done (2026-03-20)

> Реализовано: импорт отзывов Google Maps / Telegram / Facebook через
> phantom-пользователей, переводы на 6 локалей, иконки источников
> (`components/review-provider-icon.vue`). Workflow:
> `docs/import/REVIEWS_IMPORT.md`, `data/review-import-configs/`.

---

## Цель

Добавить возможность импорта внешних отзывов (Facebook, Google Maps, и др.) суперадмином для агрегации всех отзывов на платформе.

## Зависимости

**Требуется перед началом:**

- ✅ **Итерация 2** - базовый функционал отзывов должен работать

**Блокирующие факторы:**

- Нет

---

## Задачи

### 1. API для внешних отзывов (только суперадмин)

#### 1.1 Создание внешнего отзыва

**Файл:** `server/api/admin/reviews/external/create.post.ts`

```typescript
export default defineEventHandler(async (event) => {
	const session = await requireUserSession(event);

	// Проверка прав (только суперадмин)
	if (session.user.role !== 'superadmin') {
		throw createError({
			statusCode: 403,
			message: 'Only superadmin can create external reviews',
		});
	}

	const body = await readBody(event);
	const {
		targetType,
		targetId,
		source,
		sourceUrl,
		authorName,
		rating,
		text,
		reviewDate,
		language,
	} = body;

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

	const allowedSources = ['facebook', 'google_maps', 'booking', 'other'];
	if (!allowedSources.includes(source)) {
		throw createError({ statusCode: 400, message: 'Invalid source' });
	}

	if (!authorName || !text) {
		throw createError({
			statusCode: 400,
			message: 'Author name and text are required',
		});
	}

	// Проверка существования цели
	const tableName = targetType === 'doctor' ? 'doctors' : 'clinics';
	const [target] = await db.query(`SELECT id FROM ${tableName} WHERE id = ?`, [
		targetId,
	]);

	if (!target) {
		throw createError({ statusCode: 404, message: `${targetType} not found` });
	}

	// Создание внешнего отзыва
	const result = await db.query(
		`INSERT INTO reviews (
      target_type, target_id, review_type, status,
      external_source, external_source_url, external_author_name, external_review_date,
      rating, text, language
    ) VALUES (?, ?, 'external', 'approved', ?, ?, ?, ?, ?, ?, ?)`,
		[
			targetType,
			targetId,
			source,
			sourceUrl || null,
			authorName,
			reviewDate || new Date().toISOString().split('T')[0],
			rating,
			text,
			language || 'en',
		],
	);

	const reviewId = result.insertId;

	// Лог модерации
	await db.query(
		`INSERT INTO review_moderation_logs (review_id, action, moderator_id) 
     VALUES (?, 'created', ?)`,
		[reviewId, session.user.id],
	);

	// Обновление кэшированного рейтинга
	await updateRatingCache(targetType, targetId);

	return { success: true, reviewId };
});
```

#### 1.2 Массовый импорт внешних отзывов

**Файл:** `server/api/admin/reviews/external/bulk-import.post.ts`

```typescript
export default defineEventHandler(async (event) => {
	const session = await requireUserSession(event);

	// Проверка прав (только суперадмин)
	if (session.user.role !== 'superadmin') {
		throw createError({
			statusCode: 403,
			message: 'Only superadmin can import external reviews',
		});
	}

	const body = await readBody(event);
	const { reviews } = body; // Массив отзывов

	if (!Array.isArray(reviews) || reviews.length === 0) {
		throw createError({
			statusCode: 400,
			message: 'Reviews array is required',
		});
	}

	const results = {
		success: 0,
		failed: 0,
		errors: [],
	};

	for (const review of reviews) {
		try {
			// Валидация
			if (!['doctor', 'clinic'].includes(review.targetType)) {
				throw new Error('Invalid targetType');
			}

			if (!review.rating || review.rating < 1 || review.rating > 5) {
				throw new Error('Invalid rating');
			}

			// Создание отзыва
			await db.query(
				`INSERT INTO reviews (
          target_type, target_id, review_type, status,
          external_source, external_source_url, external_author_name, external_review_date,
          rating, text, language
        ) VALUES (?, ?, 'external', 'approved', ?, ?, ?, ?, ?, ?, ?)`,
				[
					review.targetType,
					review.targetId,
					review.source,
					review.sourceUrl || null,
					review.authorName,
					review.reviewDate || new Date().toISOString().split('T')[0],
					review.rating,
					review.text,
					review.language || 'en',
				],
			);

			results.success++;
		} catch (error) {
			results.failed++;
			results.errors.push({
				review,
				error: error.message,
			});
		}
	}

	// Обновление кэшированных рейтингов для всех затронутых врачей/клиник
	const uniqueTargets = [
		...new Set(reviews.map((r) => `${r.targetType}:${r.targetId}`)),
	];
	for (const target of uniqueTargets) {
		const [targetType, targetId] = target.split(':');
		await updateRatingCache(targetType, parseInt(targetId));
	}

	return results;
});
```

#### 1.3 Список внешних отзывов (для управления)

**Файл:** `server/api/admin/reviews/external/list.get.ts`

```typescript
export default defineEventHandler(async (event) => {
	const session = await requireUserSession(event);

	// Проверка прав (только суперадмин)
	if (session.user.role !== 'superadmin') {
		throw createError({ statusCode: 403, message: 'Forbidden' });
	}

	const query = getQuery(event);
	const { page = 1, limit = 20, source, targetType } = query;

	const offset = (parseInt(page) - 1) * parseInt(limit);

	let sqlQuery = `
    SELECT 
      r.*,
      CASE 
        WHEN r.target_type = 'doctor' THEN d.name
        WHEN r.target_type = 'clinic' THEN c.name
      END as target_name
    FROM reviews r
    LEFT JOIN doctors d ON r.target_type = 'doctor' AND r.target_id = d.id
    LEFT JOIN clinics c ON r.target_type = 'clinic' AND r.target_id = c.id
    WHERE r.review_type = 'external'
  `;

	const params = [];

	if (source) {
		sqlQuery += ` AND r.external_source = ?`;
		params.push(source);
	}

	if (targetType) {
		sqlQuery += ` AND r.target_type = ?`;
		params.push(targetType);
	}

	sqlQuery += ` ORDER BY r.created_at DESC LIMIT ? OFFSET ?`;
	params.push(parseInt(limit), offset);

	const reviews = await db.query(sqlQuery, params);

	// Подсчет общего количества
	let countQuery = `SELECT COUNT(*) as total FROM reviews WHERE review_type = 'external'`;
	const countParams = [];

	if (source) {
		countQuery += ` AND external_source = ?`;
		countParams.push(source);
	}

	if (targetType) {
		countQuery += ` AND target_type = ?`;
		countParams.push(targetType);
	}

	const [{ total }] = await db.query(countQuery, countParams);

	return {
		reviews,
		pagination: {
			page: parseInt(page),
			limit: parseInt(limit),
			total,
			totalPages: Math.ceil(total / parseInt(limit)),
		},
	};
});
```

### 2. Frontend компоненты для админ панели

#### 2.1 Форма создания внешнего отзыва

**Файл:** `components/admin/external-review-form.vue`

```vue
<template>
	<el-form :model="form" label-position="top" :rules="rules" ref="formRef">
		<!-- Тип и ID -->
		<el-row :gutter="16">
			<el-col :span="12">
				<el-form-item label="Тип" prop="targetType">
					<el-select v-model="form.targetType" placeholder="Выберите тип">
						<el-option label="Врач" value="doctor" />
						<el-option label="Клиника" value="clinic" />
					</el-select>
				</el-form-item>
			</el-col>
			<el-col :span="12">
				<el-form-item label="ID врача/клиники" prop="targetId">
					<el-input-number v-model="form.targetId" :min="1" />
				</el-form-item>
			</el-col>
		</el-row>

		<!-- Источник -->
		<el-row :gutter="16">
			<el-col :span="12">
				<el-form-item label="Источник" prop="source">
					<el-select v-model="form.source" placeholder="Выберите источник">
						<el-option label="Facebook" value="facebook" />
						<el-option label="Google Maps" value="google_maps" />
						<el-option label="Booking.com" value="booking" />
						<el-option label="Другой" value="other" />
					</el-select>
				</el-form-item>
			</el-col>
			<el-col :span="12">
				<el-form-item label="URL источника (опционально)" prop="sourceUrl">
					<el-input v-model="form.sourceUrl" placeholder="https://..." />
				</el-form-item>
			</el-col>
		</el-row>

		<!-- Автор и дата -->
		<el-row :gutter="16">
			<el-col :span="12">
				<el-form-item label="Имя автора" prop="authorName">
					<el-input v-model="form.authorName" placeholder="John Doe" />
				</el-form-item>
			</el-col>
			<el-col :span="12">
				<el-form-item label="Дата отзыва" prop="reviewDate">
					<el-date-picker
						v-model="form.reviewDate"
						type="date"
						placeholder="Выберите дату"
						value-format="YYYY-MM-DD"
					/>
				</el-form-item>
			</el-col>
		</el-row>

		<!-- Оценка и язык -->
		<el-row :gutter="16">
			<el-col :span="12">
				<el-form-item label="Оценка" prop="rating">
					<el-rate
						v-model="form.rating"
						:texts="['Ужасно', 'Плохо', 'Нормально', 'Хорошо', 'Отлично']"
						show-text
					/>
				</el-form-item>
			</el-col>
			<el-col :span="12">
				<el-form-item label="Язык" prop="language">
					<el-select v-model="form.language" placeholder="Выберите язык">
						<el-option label="Русский" value="ru" />
						<el-option label="English" value="en" />
						<el-option label="Srpski" value="sr" />
						<el-option label="Türkçe" value="tr" />
						<el-option label="Deutsch" value="de" />
					</el-select>
				</el-form-item>
			</el-col>
		</el-row>

		<!-- Текст отзыва -->
		<el-form-item label="Текст отзыва" prop="text">
			<el-input
				v-model="form.text"
				type="textarea"
				:rows="5"
				placeholder="Введите текст отзыва..."
			/>
		</el-form-item>

		<!-- Кнопки -->
		<el-form-item>
			<el-button type="primary" :loading="loading" @click="submit">
				Создать внешний отзыв
			</el-button>
			<el-button @click="reset">Очистить</el-button>
		</el-form-item>
	</el-form>
</template>

<script setup lang="ts">
const emit = defineEmits(['created']);

const formRef = ref();
const loading = ref(false);

const form = reactive({
	targetType: 'doctor',
	targetId: null,
	source: 'facebook',
	sourceUrl: '',
	authorName: '',
	reviewDate: new Date().toISOString().split('T')[0],
	rating: 5,
	text: '',
	language: 'en',
});

const rules = {
	targetType: [{ required: true, message: 'Выберите тип' }],
	targetId: [{ required: true, message: 'Введите ID' }],
	source: [{ required: true, message: 'Выберите источник' }],
	authorName: [{ required: true, message: 'Введите имя автора' }],
	rating: [{ required: true, message: 'Поставьте оценку' }],
	text: [{ required: true, message: 'Введите текст отзыва' }],
};

const submit = async () => {
	await formRef.value?.validate(async (valid) => {
		if (!valid) return;

		loading.value = true;

		try {
			await $fetch('/api/admin/reviews/external/create', {
				method: 'POST',
				body: form,
			});

			ElMessage.success('Внешний отзыв создан');
			reset();
			emit('created');
		} catch (error) {
			ElMessage.error(error.data?.message || 'Ошибка при создании отзыва');
		} finally {
			loading.value = false;
		}
	});
};

const reset = () => {
	formRef.value?.resetFields();
};
</script>
```

#### 2.2 Массовый импорт через JSON

**Файл:** `components/admin/bulk-import-reviews.vue`

```vue
<template>
	<div class="bulk-import">
		<el-alert type="info" :closable="false" title="Массовый импорт">
			Загрузите JSON файл с массивом отзывов. Формат:
			<pre style="margin-top: 10px;">
[
  {
    "targetType": "doctor",
    "targetId": 1,
    "source": "google_maps",
    "sourceUrl": "https://...",
    "authorName": "John Doe",
    "reviewDate": "2026-01-15",
    "rating": 5,
    "text": "Great doctor!",
    "language": "en"
  },
  ...
]
      </pre>
		</el-alert>

		<el-upload
			ref="uploadRef"
			:auto-upload="false"
			:limit="1"
			:on-change="handleFileChange"
			accept=".json"
			drag
		>
			<el-icon><upload-filled /></el-icon>
			<div class="el-upload__text">
				Перетащите JSON файл сюда или <em>нажмите для выбора</em>
			</div>
		</el-upload>

		<el-button
			v-if="reviews.length > 0"
			type="primary"
			:loading="importing"
			@click="importReviews"
		>
			Импортировать {{ reviews.length }} отзывов
		</el-button>

		<!-- Результаты импорта -->
		<div v-if="importResults" class="import-results">
			<el-alert
				:type="importResults.failed === 0 ? 'success' : 'warning'"
				:closable="false"
			>
				Успешно: {{ importResults.success }} | Ошибки:
				{{ importResults.failed }}
			</el-alert>

			<div v-if="importResults.errors.length > 0" class="import-errors">
				<h4>Ошибки:</h4>
				<ul>
					<li v-for="(error, index) in importResults.errors" :key="index">
						{{ error.error }} - {{ JSON.stringify(error.review) }}
					</li>
				</ul>
			</div>
		</div>
	</div>
</template>

<script setup lang="ts">
const emit = defineEmits(['imported']);

const uploadRef = ref();
const reviews = ref([]);
const importing = ref(false);
const importResults = ref(null);

const handleFileChange = (file) => {
	const reader = new FileReader();

	reader.onload = (e) => {
		try {
			const data = JSON.parse(e.target.result as string);

			if (!Array.isArray(data)) {
				ElMessage.error('JSON файл должен содержать массив отзывов');
				return;
			}

			reviews.value = data;
			ElMessage.success(`Загружено ${data.length} отзывов`);
		} catch (error) {
			ElMessage.error('Ошибка при парсинге JSON файла');
		}
	};

	reader.readAsText(file.raw);
};

const importReviews = async () => {
	importing.value = true;

	try {
		const results = await $fetch('/api/admin/reviews/external/bulk-import', {
			method: 'POST',
			body: { reviews: reviews.value },
		});

		importResults.value = results;

		if (results.failed === 0) {
			ElMessage.success(`Все ${results.success} отзывов импортированы`);
		} else {
			ElMessage.warning(
				`Импортировано ${results.success} из ${reviews.value.length}`,
			);
		}

		emit('imported', results);
	} catch (error) {
		ElMessage.error('Ошибка при импорте отзывов');
	} finally {
		importing.value = false;
	}
};
</script>
```

#### 2.3 Список внешних отзывов

**Файл:** `components/admin/external-reviews-list.vue`

```vue
<template>
	<div class="external-reviews-list">
		<h3>Внешние отзывы</h3>

		<!-- Фильтры -->
		<div class="filters">
			<el-select v-model="filterSource" placeholder="Источник" clearable>
				<el-option label="Facebook" value="facebook" />
				<el-option label="Google Maps" value="google_maps" />
				<el-option label="Booking" value="booking" />
				<el-option label="Другой" value="other" />
			</el-select>

			<el-select v-model="filterTargetType" placeholder="Тип" clearable>
				<el-option label="Врачи" value="doctor" />
				<el-option label="Клиники" value="clinic" />
			</el-select>

			<el-button @click="loadReviews">Применить</el-button>
		</div>

		<!-- Таблица -->
		<el-table :data="reviews" stripe>
			<el-table-column prop="id" label="ID" width="80" />
			<el-table-column prop="target_type" label="Тип" width="100" />
			<el-table-column prop="target_name" label="Врач/Клиника" />
			<el-table-column prop="external_source" label="Источник" width="120" />
			<el-table-column prop="external_author_name" label="Автор" />
			<el-table-column prop="rating" label="Оценка" width="100">
				<template #default="{ row }">
					<el-rate v-model="row.rating" disabled size="small" />
				</template>
			</el-table-column>
			<el-table-column prop="external_review_date" label="Дата" width="120" />
		</el-table>

		<!-- Пагинация -->
		<el-pagination
			v-if="pagination.totalPages > 1"
			v-model:current-page="currentPage"
			:page-size="pagination.limit"
			:total="pagination.total"
			layout="prev, pager, next, total"
			@current-change="loadReviews"
		/>
	</div>
</template>

<script setup lang="ts">
const reviews = ref([]);
const pagination = ref({});
const currentPage = ref(1);
const filterSource = ref('');
const filterTargetType = ref('');

const loadReviews = async () => {
	const data = await $fetch('/api/admin/reviews/external/list', {
		params: {
			page: currentPage.value,
			source: filterSource.value || undefined,
			targetType: filterTargetType.value || undefined,
		},
	});

	reviews.value = data.reviews;
	pagination.value = data.pagination;
};

onMounted(() => {
	loadReviews();
});
</script>
```

### 3. Компонент badge источника

**Файл:** `components/review/source-badge.vue`

```vue
<template>
	<el-tag
		v-if="type === 'external'"
		:type="tagType"
		size="small"
		effect="plain"
	>
		{{ sourceLabel }}
	</el-tag>
</template>

<script setup lang="ts">
const props = defineProps<{
	type: 'internal' | 'external';
	source?: string;
}>();

const sourceLabel = computed(() => {
	if (props.type !== 'external') return '';

	const labels = {
		facebook: 'Facebook',
		google_maps: 'Google Maps',
		booking: 'Booking.com',
		other: 'Внешний',
	};

	return labels[props.source] || 'Внешний';
});

const tagType = computed(() => {
	return 'info';
});
</script>

<style scoped>
.el-tag {
	margin-left: 8px;
	vertical-align: middle;
}
</style>
```

### 4. Страница админ панели для внешних отзывов

**Файл:** `pages/admin/external-reviews.vue`

```vue
<template>
	<div class="admin-external-reviews">
		<h1>Управление внешними отзывами</h1>

		<el-tabs v-model="activeTab">
			<el-tab-pane label="Создать" name="create">
				<AdminExternalReviewForm @created="onCreated" />
			</el-tab-pane>

			<el-tab-pane label="Массовый импорт" name="bulk">
				<AdminBulkImportReviews @imported="onImported" />
			</el-tab-pane>

			<el-tab-pane label="Список" name="list">
				<AdminExternalReviewsList ref="listRef" />
			</el-tab-pane>
		</el-tabs>
	</div>
</template>

<script setup lang="ts">
const activeTab = ref('create');
const listRef = ref();

const onCreated = () => {
	activeTab.value = 'list';
	listRef.value?.loadReviews();
};

const onImported = () => {
	activeTab.value = 'list';
	listRef.value?.loadReviews();
};
</script>
```

---

## Критерии приемки (Acceptance Criteria)

- [ ] **AC-1:** Суперадмин может создать внешний отзыв вручную
- [ ] **AC-2:** Внешний отзыв сохраняется с полями: source, sourceUrl, authorName, reviewDate
- [ ] **AC-3:** Внешние отзывы имеют статус "approved" по умолчанию
- [ ] **AC-4:** Суперадмин может импортировать массив отзывов через JSON
- [ ] **AC-5:** Массовый импорт показывает результаты (успешно/ошибки)
- [ ] **AC-6:** Внешние отзывы участвуют в расчете среднего рейтинга
- [ ] **AC-7:** Source badge отображается на внешних отзывах
- [ ] **AC-8:** Фильтр "Внешние" работает корректно
- [ ] **AC-9:** Суперадмин может просматривать список всех внешних отзывов
- [ ] **AC-10:** Обычные пользователи НЕ могут создавать внешние отзывы

---

## Как проверить

1. Зайти в админ панель как суперадмин
2. Перейти в "Управление внешними отзывами"
3. Создать внешний отзыв вручную
4. Проверить, что отзыв появился на странице врача/клиники с source badge
5. Подготовить JSON файл с массивом отзывов
6. Импортировать JSON через массовый импорт
7. Проверить результаты импорта
8. Проверить, что рейтинг обновился

---

## Оценка времени

**Ожидаемое время:** 2 дня  
**Сложность:** Средняя

---

**Назад:** [← К списку итераций](README.md)  
**Далее:** [Итерация 5: AI Summary →](iteration-05-ai-summary.md)
