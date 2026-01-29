# Итерация 3: Верификация отзывов

[← К списку итераций](README.md) | [Следующая →](iteration-04-external-reviews.md)

---

## Статус: 🔴 Not Started

---

## Цель

Добавить возможность верификации отзывов через загрузку подтверждающих документов (чеки, назначения, справки) и отображение verified badge для подтвержденных отзывов.

## Зависимости

**Требуется перед началом:**

- ✅ **Итерация 2** - базовый функционал отзывов должен работать

**Блокирующие факторы:**

- Нет

---

## Задачи

### 1. API для загрузки файлов верификации

#### 1.1 Загрузка файла верификации

**Файл:** `server/api/reviews/[id]/upload-verification.post.ts`

```typescript
import { writeFile, mkdir } from 'fs/promises';
import { existsSync } from 'fs';
import path from 'path';

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

	// Проверка прав (только автор)
	if (review.user_id !== session.user.id) {
		throw createError({ statusCode: 403, message: 'Forbidden' });
	}

	// Проверка: уже есть файл верификации?
	const [existing] = await db.query(
		`SELECT id FROM review_verification_files WHERE review_id = ?`,
		[reviewId],
	);

	if (existing) {
		throw createError({
			statusCode: 400,
			message: 'Verification file already exists',
		});
	}

	// Получение файла из multipart/form-data
	const formData = await readMultipartFormData(event);
	const file = formData?.find((item) => item.name === 'file');

	if (!file) {
		throw createError({ statusCode: 400, message: 'File is required' });
	}

	// Валидация файла
	const allowedTypes = ['image/jpeg', 'image/png', 'application/pdf'];
	if (!allowedTypes.includes(file.type)) {
		throw createError({
			statusCode: 400,
			message: 'Invalid file type. Allowed: JPG, PNG, PDF',
		});
	}

	const maxSize = 5 * 1024 * 1024; // 5MB
	if (file.data.length > maxSize) {
		throw createError({
			statusCode: 400,
			message: 'File is too large (max 5MB)',
		});
	}

	// Сохранение файла
	const uploadDir = path.join(
		process.cwd(),
		'public',
		'uploads',
		'verifications',
	);
	if (!existsSync(uploadDir)) {
		await mkdir(uploadDir, { recursive: true });
	}

	const fileExt = file.type.split('/')[1];
	const fileName = `${reviewId}_${Date.now()}.${fileExt}`;
	const filePath = path.join(uploadDir, fileName);

	await writeFile(filePath, file.data);

	// Сохранение в БД
	await db.query(
		`INSERT INTO review_verification_files (
      review_id, file_path, file_name, file_type, file_size, verification_status
    ) VALUES (?, ?, ?, ?, ?, 'pending')`,
		[
			reviewId,
			`/uploads/verifications/${fileName}`,
			file.filename,
			file.type,
			file.data.length,
		],
	);

	// Лог модерации
	await db.query(
		`INSERT INTO review_moderation_logs (review_id, action, moderator_id) 
     VALUES (?, 'verification_uploaded', NULL)`,
		[reviewId],
	);

	return { success: true, filePath: `/uploads/verifications/${fileName}` };
});
```

#### 1.2 Получение файла верификации (для модераторов)

**Файл:** `server/api/reviews/[id]/verification-file.get.ts`

```typescript
export default defineEventHandler(async (event) => {
	const session = await requireUserSession(event);
	const reviewId = getRouterParam(event, 'id');

	// Проверка: пользователь - автор или модератор?
	const [review] = await db.query(`SELECT user_id FROM reviews WHERE id = ?`, [
		reviewId,
	]);

	if (!review) {
		throw createError({ statusCode: 404, message: 'Review not found' });
	}

	const isModerator = ['moderator', 'superadmin'].includes(session.user.role);
	const isAuthor = review.user_id === session.user.id;

	if (!isModerator && !isAuthor) {
		throw createError({ statusCode: 403, message: 'Forbidden' });
	}

	// Получение файла
	const [file] = await db.query(
		`SELECT * FROM review_verification_files WHERE review_id = ?`,
		[reviewId],
	);

	if (!file) {
		throw createError({
			statusCode: 404,
			message: 'Verification file not found',
		});
	}

	return { file };
});
```

### 2. Компоненты верификации

#### 2.1 Загрузка файла верификации

**Файл:** `components/review/verification-upload.vue`

```vue
<template>
	<div class="verification-upload">
		<el-alert type="info" :closable="false" title="Подтвердите визит">
			Загрузите документ, подтверждающий ваш визит (чек, направление, справка).
			Это повысит доверие к вашему отзыву.
		</el-alert>

		<el-upload
			ref="uploadRef"
			:auto-upload="false"
			:limit="1"
			:on-change="handleFileChange"
			:before-upload="beforeUpload"
			accept=".jpg,.jpeg,.png,.pdf"
			drag
		>
			<el-icon><upload-filled /></el-icon>
			<div class="el-upload__text">
				Перетащите файл сюда или <em>нажмите для выбора</em>
			</div>
			<template #tip>
				<div class="el-upload__tip">
					Форматы: JPG, PNG, PDF. Максимум 5 МБ.
				</div>
			</template>
		</el-upload>

		<el-button
			v-if="selectedFile"
			type="primary"
			:loading="uploading"
			@click="uploadFile"
		>
			Загрузить
		</el-button>
	</div>
</template>

<script setup lang="ts">
const props = defineProps<{
	reviewId: number;
}>();

const emit = defineEmits(['uploaded']);

const uploadRef = ref();
const selectedFile = ref(null);
const uploading = ref(false);

const handleFileChange = (file, fileList) => {
	selectedFile.value = file.raw;
};

const beforeUpload = (file) => {
	const allowedTypes = ['image/jpeg', 'image/png', 'application/pdf'];
	if (!allowedTypes.includes(file.type)) {
		ElMessage.error('Можно загружать только JPG, PNG или PDF файлы');
		return false;
	}

	const maxSize = 5 * 1024 * 1024; // 5MB
	if (file.size > maxSize) {
		ElMessage.error('Файл слишком большой (максимум 5 МБ)');
		return false;
	}

	return true;
};

const uploadFile = async () => {
	if (!selectedFile.value) {
		ElMessage.error('Выберите файл');
		return;
	}

	uploading.value = true;

	try {
		const formData = new FormData();
		formData.append('file', selectedFile.value);

		await $fetch(`/api/reviews/${props.reviewId}/upload-verification`, {
			method: 'POST',
			body: formData,
		});

		ElMessage.success('Файл загружен. Ожидайте проверки модератором.');
		emit('uploaded');
	} catch (error) {
		ElMessage.error(error.data?.message || 'Ошибка при загрузке файла');
	} finally {
		uploading.value = false;
	}
};
</script>
```

#### 2.2 Verified badge

**Файл:** `components/review/verification-badge.vue`

```vue
<template>
	<el-tag type="success" size="small" effect="dark">
		<el-icon><select /></el-icon>
		Подтвержден
	</el-tag>
</template>

<style scoped>
.el-tag {
	margin-left: 8px;
	vertical-align: middle;
}
</style>
```

#### 2.3 Обновление диалога создания отзыва

**Файл:** `components/review/create-dialog.vue` (обновить)

```vue
<!-- Добавить в конец формы, перед footer -->
<el-divider>Верификация (опционально)</el-divider>

<el-form-item>
  <el-checkbox v-model="showVerificationUpload">
    Я хочу подтвердить свой визит (повысит доверие к отзыву)
  </el-checkbox>
</el-form-item>

<VerificationUpload
	v-if="showVerificationUpload && createdReviewId"
	:review-id="createdReviewId"
	@uploaded="onVerificationUploaded"
/>
```

```typescript
// В скрипт добавить
const showVerificationUpload = ref(false);
const createdReviewId = ref(null);

const submit = async () => {
  // ... существующий код создания отзыва ...

  const { reviewId } = await $fetch('/api/reviews/create', { ... });
  createdReviewId.value = reviewId;

  // Если не нужна верификация - закрыть диалог
  if (!showVerificationUpload.value) {
    ElMessage.success('Отзыв отправлен на модерацию');
    visible.value = false;
    emit('created');
  }
};

const onVerificationUploaded = () => {
  visible.value = false;
  emit('created');
};
```

### 3. Модерация верификационных файлов (базовая версия)

#### 3.1 API для модерации верификации

**Файл:** `server/api/admin/reviews/[id]/verify.post.ts`

```typescript
export default defineEventHandler(async (event) => {
	const session = await requireUserSession(event);
	const reviewId = getRouterParam(event, 'id');
	const body = await readBody(event);

	// Проверка прав (только модераторы)
	if (!['moderator', 'superadmin'].includes(session.user.role)) {
		throw createError({ statusCode: 403, message: 'Forbidden' });
	}

	const { action, reason } = body; // action: 'approve' | 'reject'

	if (!['approve', 'reject'].includes(action)) {
		throw createError({ statusCode: 400, message: 'Invalid action' });
	}

	// Получение файла верификации
	const [file] = await db.query(
		`SELECT * FROM review_verification_files WHERE review_id = ?`,
		[reviewId],
	);

	if (!file) {
		throw createError({
			statusCode: 404,
			message: 'Verification file not found',
		});
	}

	// Обновление статуса верификации
	await db.query(
		`UPDATE review_verification_files 
     SET verification_status = ?,
         verified_at = NOW(),
         verified_by = ?,
         rejection_reason = ?
     WHERE review_id = ?`,
		[
			action === 'approve' ? 'approved' : 'rejected',
			session.user.id,
			reason || null,
			reviewId,
		],
	);

	// Если одобрено - обновить флаг в отзыве
	if (action === 'approve') {
		await db.query(`UPDATE reviews SET is_verified = TRUE WHERE id = ?`, [
			reviewId,
		]);
	}

	// Лог модерации
	await db.query(
		`INSERT INTO review_moderation_logs (review_id, action, moderator_id, comment) 
     VALUES (?, ?, ?, ?)`,
		[
			reviewId,
			action === 'approve' ? 'verified' : 'verification_rejected',
			session.user.id,
			reason || null,
		],
	);

	return { success: true };
});
```

#### 3.2 Компонент модерации верификации (админ)

**Файл:** `components/admin/verification-moderation.vue`

```vue
<template>
	<div class="verification-moderation">
		<h3>Модерация верификации</h3>

		<!-- Просмотр файла -->
		<div v-if="file" class="verification-file">
			<img
				v-if="file.file_type.startsWith('image/')"
				:src="file.file_path"
				alt="Verification file"
				style="max-width: 100%; max-height: 500px;"
			/>
			<iframe
				v-else-if="file.file_type === 'application/pdf'"
				:src="file.file_path"
				style="width: 100%; height: 500px;"
			/>
		</div>

		<!-- Действия -->
		<div class="verification-actions">
			<el-button type="success" @click="approve">
				Одобрить верификацию
			</el-button>
			<el-button type="danger" @click="showRejectDialog = true">
				Отклонить
			</el-button>
		</div>

		<!-- Диалог отклонения -->
		<el-dialog v-model="showRejectDialog" title="Причина отклонения">
			<el-input
				v-model="rejectReason"
				type="textarea"
				:rows="3"
				placeholder="Укажите причину отклонения..."
			/>
			<template #footer>
				<el-button @click="showRejectDialog = false">Отмена</el-button>
				<el-button type="danger" @click="reject">Отклонить</el-button>
			</template>
		</el-dialog>
	</div>
</template>

<script setup lang="ts">
const props = defineProps<{
	reviewId: number;
}>();

const emit = defineEmits(['moderated']);

const file = ref(null);
const showRejectDialog = ref(false);
const rejectReason = ref('');

const loadFile = async () => {
	const data = await $fetch(`/api/reviews/${props.reviewId}/verification-file`);
	file.value = data.file;
};

const approve = async () => {
	try {
		await $fetch(`/api/admin/reviews/${props.reviewId}/verify`, {
			method: 'POST',
			body: { action: 'approve' },
		});

		ElMessage.success('Верификация одобрена');
		emit('moderated');
	} catch (error) {
		ElMessage.error('Ошибка при одобрении');
	}
};

const reject = async () => {
	try {
		await $fetch(`/api/admin/reviews/${props.reviewId}/verify`, {
			method: 'POST',
			body: { action: 'reject', reason: rejectReason.value },
		});

		ElMessage.success('Верификация отклонена');
		showRejectDialog.value = false;
		emit('moderated');
	} catch (error) {
		ElMessage.error('Ошибка при отклонении');
	}
};

onMounted(() => {
	loadFile();
});
</script>
```

### 4. Обновление компонента карточки отзыва

**Файл:** `components/review/item.vue` (обновить)

```vue
<!-- Добавить verified badge в имя автора -->
<div class="review-author-name">
  {{ review.author_name || review.external_author_name }}
  <ReviewVerificationBadge v-if="review.is_verified" />
  <ReviewSourceBadge :type="review.review_type" :source="review.external_source" />
</div>
```

### 5. Обновление фильтрации

**Файл:** `components/review/list.vue` (обновить)

```vue
<!-- Добавить в фильтры -->
<el-select v-model="filterType" placeholder="Тип">
  <el-option label="Все" value="" />
  <el-option label="Внутренние" value="internal" />
  <el-option label="Внешние" value="external" />
  <el-option label="Подтвержденные" value="verified" /> <!-- Новый фильтр -->
</el-select>
```

---

## Критерии приемки (Acceptance Criteria)

- [ ] **AC-1:** Пользователь может загрузить файл верификации к своему отзыву
- [ ] **AC-2:** Файлы сохраняются локально в `/public/uploads/verifications/`
- [ ] **AC-3:** Поддерживаются форматы: JPG, PNG, PDF (максимум 5 МБ)
- [ ] **AC-4:** Модератор может просмотреть файл верификации
- [ ] **AC-5:** Модератор может одобрить верификацию (отзыв получает is_verified = TRUE)
- [ ] **AC-6:** Модератор может отклонить верификацию с указанием причины
- [ ] **AC-7:** Verified badge отображается на подтвержденных отзывах
- [ ] **AC-8:** Фильтр "Подтвержденные" работает корректно
- [ ] **AC-9:** Логи модерации сохраняются в `review_moderation_logs`
- [ ] **AC-10:** Только автор и модераторы могут просматривать файлы верификации

---

## Как проверить

1. Создать отзыв с загрузкой файла верификации
2. Проверить, что файл сохранен в `/public/uploads/verifications/`
3. Зайти в админ панель как модератор
4. Просмотреть файл верификации
5. Одобрить верификацию
6. Проверить, что на отзыве появился verified badge
7. Проверить фильтр "Подтвержденные"

---

## Оценка времени

**Ожидаемое время:** 2 дня  
**Сложность:** Средняя

---

**Назад:** [← К списку итераций](README.md)  
**Далее:** [Итерация 4: Внешние отзывы →](iteration-04-external-reviews.md)
