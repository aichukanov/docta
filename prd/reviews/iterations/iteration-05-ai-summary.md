# Итерация 5: AI Summary отзывов

[← К списку итераций](README.md) | [Следующая →](iteration-06-moderation.md)

---

## Статус: 🔴 Not Started

---

## Цель

Реализовать AI-анализ всех отзывов (внутренних + внешних) с генерацией краткого summary через Playwright утилиту, которая запускается по требованию для массового обновления AI-анализа.

## Зависимости

**Требуется перед началом:**

- ✅ **Итерация 2** - базовый функционал отзывов должен работать
- ✅ **OpenAI API ключи** - для интеграции с GPT-4
- ✅ **E2E testing setup** - Playwright должен быть настроен (`tests/utilities/`)

**Блокирующие факторы:**

- Наличие API ключей OpenAI

---

## Задачи

### 1. Интеграция с OpenAI API

#### 1.1 Конфигурация

**Файл:** `.env`

```bash
OPENAI_API_KEY=sk-proj-...
OPENAI_MODEL=gpt-4o-mini  # или gpt-3.5-turbo для экономии
```

**Файл:** `server/utils/openai.ts`

```typescript
import OpenAI from 'openai';

export const openai = new OpenAI({
	apiKey: process.env.OPENAI_API_KEY,
});

export const OPENAI_MODEL = process.env.OPENAI_MODEL || 'gpt-4o-mini';
```

#### 1.2 Генерация промпта

**Файл:** `server/utils/ai-summary-prompt.ts`

```typescript
export function buildAISummaryPrompt(
	reviews: any[],
	locale: string = 'ru',
): string {
	const reviewsText = reviews
		.map((r, index) => {
			return `Отзыв ${index + 1}:
Оценка: ${r.rating}/5
${
	r.criteria_professionalism
		? `Профессионализм: ${r.criteria_professionalism}/5`
		: ''
}
${r.criteria_attitude ? `Отношение: ${r.criteria_attitude}/5` : ''}
${r.criteria_quality ? `Качество: ${r.criteria_quality}/5` : ''}
${
	r.criteria_price_quality ? `Цена/Качество: ${r.criteria_price_quality}/5` : ''
}
Текст: ${r.text || '(нет текста)'}
---`;
		})
		.join('\n');

	const prompts = {
		ru: `Ты - аналитик медицинских отзывов. Проанализируй следующие отзывы о враче/клинике и создай краткое резюме.

${reviewsText}

Верни результат в формате JSON:
{
  "sentiment": "positive" | "neutral" | "negative",
  "positives": ["пункт 1", "пункт 2", ...],  // 3-5 ключевых положительных моментов
  "negatives": ["пункт 1", ...],            // 0-5 ключевых проблем
  "recommendations": "краткие рекомендации для потенциальных пациентов"
}

Правила:
- Sentiment определяй по среднему рейтингу и тональности отзывов
- Positives - конкретные сильные стороны (профессионализм, отношение, качество)
- Negatives - упомянутые проблемы (если есть)
- Recommendations - 2-3 предложения о том, кому и когда стоит обращаться
- Будь объективным и конкретным`,

		en: `You are a medical review analyst. Analyze the following reviews about a doctor/clinic and create a brief summary.

${reviewsText}

Return the result in JSON format:
{
  "sentiment": "positive" | "neutral" | "negative",
  "positives": ["point 1", "point 2", ...],  // 3-5 key positive points
  "negatives": ["point 1", ...],            // 0-5 key issues
  "recommendations": "brief recommendations for potential patients"
}

Rules:
- Determine sentiment based on average rating and review tone
- Positives - specific strengths (professionalism, attitude, quality)
- Negatives - mentioned issues (if any)
- Recommendations - 2-3 sentences about who and when should visit
- Be objective and specific`,

		sr: `Ti si analitičar medicinskih recenzija. Analiziraj sledeće recenzije o lekaru/klinici i napravi kratak rezime.

${reviewsText}

Vrati rezultat u JSON formatu:
{
  "sentiment": "positive" | "neutral" | "negative",
  "positives": ["tačka 1", "tačka 2", ...],  // 3-5 ključnih pozitivnih momenata
  "negatives": ["tačka 1", ...],            // 0-5 ključnih problema
  "recommendations": "kratke preporuke za potencijalne pacijente"
}

Pravila:
- Sentiment odredi na osnovu prosečne ocene i tona recenzija
- Positives - konkretne jake strane (profesionalnost, odnos, kvalitet)
- Negatives - spomenuti problemi (ako postoje)
- Recommendations - 2-3 rečenice o tome kome i kada se obratiti
- Budi objektivan i konkretan`,
	};

	return prompts[locale] || prompts['en'];
}
```

#### 1.3 API для генерации AI Summary

**Файл:** `server/api/reviews/generate-ai-summary.post.ts`

```typescript
import { openai, OPENAI_MODEL } from '~/server/utils/openai';
import { buildAISummaryPrompt } from '~/server/utils/ai-summary-prompt';

export default defineEventHandler(async (event) => {
	const body = await readBody(event);
	const { targetType, targetId, language = 'ru', model } = body;

	// Валидация
	if (!['doctor', 'clinic'].includes(targetType)) {
		throw createError({ statusCode: 400, message: 'Invalid targetType' });
	}

	// Получение всех одобренных отзывов
	const reviews = await db.query(
		`SELECT * FROM reviews 
     WHERE target_type = ? 
       AND target_id = ? 
       AND status = 'approved' 
       AND deleted_at IS NULL
     ORDER BY created_at DESC`,
		[targetType, targetId],
	);

	if (reviews.length < 3) {
		throw createError({
			statusCode: 400,
			message: 'Need at least 3 reviews to generate AI summary',
		});
	}

	// Построение промпта
	const prompt = buildAISummaryPrompt(reviews, language);

	// Вызов OpenAI API с выбранной моделью
	try {
		const response = await openai.chat.completions.create({
			model: model || OPENAI_MODEL, // Модель из параметров или env
			messages: [
				{
					role: 'system',
					content:
						'You are a helpful assistant that analyzes medical reviews and provides structured summaries in JSON format.',
				},
				{
					role: 'user',
					content: prompt,
				},
			],
			temperature: 0.7,
			response_format: { type: 'json_object' },
		});

		const result = JSON.parse(response.choices[0].message.content);

		// Сохранение в БД
		await db.query(
			`INSERT INTO review_ai_summaries (
        target_type, target_id, language,
        sentiment, positives, negatives, recommendations,
        reviews_count, generated_at
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())
      ON DUPLICATE KEY UPDATE
        sentiment = VALUES(sentiment),
        positives = VALUES(positives),
        negatives = VALUES(negatives),
        recommendations = VALUES(recommendations),
        reviews_count = VALUES(reviews_count),
        regenerated_at = NOW()`,
			[
				targetType,
				targetId,
				language,
				result.sentiment,
				JSON.stringify(result.positives),
				JSON.stringify(result.negatives),
				result.recommendations,
				reviews.length,
			],
		);

		return {
			summary: result,
			reviewsCount: reviews.length,
			generatedAt: new Date(),
		};
	} catch (error) {
		console.error('OpenAI API error:', error);
		throw createError({
			statusCode: 500,
			message: 'Failed to generate AI summary',
		});
	}
});
```

#### 1.4 API для получения AI Summary

**Файл:** `server/api/reviews/ai-summary.get.ts`

```typescript
export default defineEventHandler(async (event) => {
	const query = getQuery(event);
	const { targetType, targetId, language = 'ru' } = query;

	// Валидация
	if (!['doctor', 'clinic'].includes(targetType as string)) {
		throw createError({ statusCode: 400, message: 'Invalid targetType' });
	}

	// Получение AI Summary из БД
	const [summary] = await db.query(
		`SELECT * FROM review_ai_summaries 
     WHERE target_type = ? 
       AND target_id = ? 
       AND language = ?`,
		[targetType, targetId, language],
	);

	if (!summary) {
		return null; // AI Summary не сгенерирован
	}

	// Парсинг JSON полей
	summary.positives = JSON.parse(summary.positives);
	summary.negatives = JSON.parse(summary.negatives);

	return {
		summary,
		reviewsCount: summary.reviews_count,
		generatedAt: summary.regenerated_at || summary.generated_at,
	};
});
```

### 2. Frontend компоненты

#### 2.1 Компонент AI Summary

**Файл:** `components/review/ai-summary.vue`

```vue
<template>
	<div v-if="summary" class="ai-summary">
		<div class="ai-summary-header">
			<div class="ai-summary-title">
				<el-icon><star /></el-icon>
				<h3>AI изучил {{ reviewsCount }} отзывов и выяснил следующее</h3>
			</div>
			<el-tag :type="sentimentType" size="large">
				{{ sentimentLabel }}
			</el-tag>
		</div>

		<el-divider />

		<!-- Положительные моменты -->
		<div v-if="summary.positives?.length > 0" class="ai-summary-section">
			<h4 class="positive-title">
				<el-icon color="green"><check /></el-icon>
				Сильные стороны
			</h4>
			<ul class="ai-summary-list positive">
				<li v-for="(item, index) in summary.positives" :key="index">
					{{ item }}
				</li>
			</ul>
		</div>

		<!-- Проблемы (если есть) -->
		<div v-if="summary.negatives?.length > 0" class="ai-summary-section">
			<h4 class="negative-title">
				<el-icon color="red"><close /></el-icon>
				Упомянутые проблемы
			</h4>
			<ul class="ai-summary-list negative">
				<li v-for="(item, index) in summary.negatives" :key="index">
					{{ item }}
				</li>
			</ul>
		</div>

		<!-- Рекомендации -->
		<div class="ai-summary-section">
			<h4 class="recommendations-title">
				<el-icon><info-filled /></el-icon>
				Рекомендации
			</h4>
			<p class="ai-summary-recommendations">
				{{ summary.recommendations }}
			</p>
		</div>

		<el-divider />

		<div class="ai-summary-footer">
			<span class="ai-summary-meta">
				AI анализ на основе {{ reviewsCount }} отзывов
			</span>
			<el-button size="small" :loading="regenerating" @click="regenerate">
				Обновить анализ
			</el-button>
		</div>
	</div>

	<div v-else-if="loading" class="ai-summary-loading">
		<el-skeleton :rows="5" animated />
	</div>

	<el-alert
		v-else-if="error"
		type="info"
		:closable="false"
		title="AI анализ недоступен"
		description="Недостаточно отзывов для генерации AI анализа (минимум 3 отзыва)"
	/>
</template>

<script setup lang="ts">
const props = defineProps<{
	targetType: 'doctor' | 'clinic';
	targetId: number;
}>();

const { locale } = useI18n();

const summary = ref(null);
const reviewsCount = ref(0);
const loading = ref(true);
const regenerating = ref(false);
const error = ref(false);

const sentimentType = computed(() => {
	const types = {
		positive: 'success',
		neutral: 'info',
		negative: 'warning',
	};
	return types[summary.value?.sentiment] || 'info';
});

const sentimentLabel = computed(() => {
	const labels = {
		positive: 'Положительные отзывы',
		neutral: 'Смешанные отзывы',
		negative: 'Есть негативные отзывы',
	};
	return labels[summary.value?.sentiment] || 'Нейтрально';
});

const loadSummary = async () => {
	loading.value = true;
	error.value = false;

	try {
		const data = await $fetch('/api/reviews/ai-summary', {
			params: {
				targetType: props.targetType,
				targetId: props.targetId,
				language: locale.value,
			},
		});

		if (data) {
			summary.value = data.summary;
			reviewsCount.value = data.reviewsCount;
		} else {
			error.value = true;
		}
	} catch (err) {
		error.value = true;
	} finally {
		loading.value = false;
	}
};

const regenerate = async () => {
	regenerating.value = true;

	try {
		const data = await $fetch('/api/reviews/generate-ai-summary', {
			method: 'POST',
			body: {
				targetType: props.targetType,
				targetId: props.targetId,
				language: locale.value,
			},
		});

		summary.value = data.summary;
		reviewsCount.value = data.reviewsCount;

		ElMessage.success('AI анализ обновлен');
	} catch (err) {
		ElMessage.error('Ошибка при обновлении AI анализа');
	} finally {
		regenerating.value = false;
	}
};

onMounted(() => {
	loadSummary();
});
</script>

<style scoped>
.ai-summary {
	background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	color: white;
	padding: 24px;
	border-radius: 12px;
	margin-bottom: 24px;
}

.ai-summary-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 16px;
}

.ai-summary-title {
	display: flex;
	align-items: center;
	gap: 12px;
}

.ai-summary-title h3 {
	margin: 0;
	font-size: 20px;
	font-weight: 600;
}

.ai-summary-section {
	margin: 16px 0;
}

.ai-summary-section h4 {
	display: flex;
	align-items: center;
	gap: 8px;
	margin-bottom: 12px;
	font-size: 16px;
}

.ai-summary-list {
	list-style: none;
	padding: 0;
	margin: 0;
}

.ai-summary-list li {
	padding: 8px 0;
	padding-left: 24px;
	position: relative;
}

.ai-summary-list li::before {
	content: '✓';
	position: absolute;
	left: 0;
	font-weight: bold;
}

.ai-summary-list.negative li::before {
	content: '⚠';
}

.ai-summary-recommendations {
	line-height: 1.6;
	margin: 0;
	padding: 12px;
	background: rgba(255, 255, 255, 0.1);
	border-radius: 8px;
}

.ai-summary-footer {
	display: flex;
	justify-content: space-between;
	align-items: center;
	font-size: 14px;
	opacity: 0.9;
}

.ai-summary-meta {
	font-style: italic;
}
</style>
```

### 3. Playwright утилита для массовой генерации

**ВАЖНО:** Это НЕ тест функционала, а утилита для запуска команды!

#### 3.1 Playwright утилита

**Файл:** `tests/utilities/ai-summary-generation.ts`

```typescript
import { chromium } from '@playwright/test';

/**
 * Утилита для массовой генерации AI Summary для всех врачей и клиник
 *
 * ЭТО НЕ ТЕСТ! Это утилита для удобного запуска команды генерации AI Summary.
 * Использует Playwright API для HTTP запросов.
 *
 * Запуск:
 *   node tests/utilities/ai-summary-generation.ts
 * или:
 *   npm run utils:ai-summary
 *
 * Что делает:
 * 1. Получает список всех врачей и клиник с отзывами
 * 2. Для каждого вызывает API генерации AI Summary
 * 3. Обновляет БД (таблица review_ai_summaries)
 */

// Конфигурация через переменные окружения
const BASE_URL = process.env.BASE_URL || 'http://localhost:3000';
const AI_MODEL = process.env.AI_MODEL || 'gpt-4o-mini'; // gpt-4, gpt-3.5-turbo
const LANGUAGES = (process.env.LANGUAGES || 'ru,en,sr').split(',');
const MIN_REVIEWS = parseInt(process.env.MIN_REVIEWS || '3');
const RATE_LIMIT_DELAY = parseInt(process.env.RATE_LIMIT_DELAY || '1000'); // мс

async function generateAISummaries() {
	console.log('=== AI Summary Generation Utility ===');
	console.log(`Base URL: ${BASE_URL}`);
	console.log(`AI Model: ${AI_MODEL}`);
	console.log(`Languages: ${LANGUAGES.join(', ')}`);
	console.log(`Min reviews: ${MIN_REVIEWS}`);
	console.log('');

	const browser = await chromium.launch();
	const context = await browser.newContext({ baseURL: BASE_URL });

	try {
		// Генерация для врачей
		console.log('📋 Processing doctors...');
		await processDoctors(context);

		// Генерация для клиник
		console.log('\n📋 Processing clinics...');
		await processClinics(context);

		console.log('\n✅ AI Summary generation completed!');
	} catch (error) {
		console.error('\n❌ Error:', error.message);
		process.exit(1);
	} finally {
		await browser.close();
	}
}

async function processDoctors(context) {
	const response = await context.request.post(
		'/api/admin/doctors/with-reviews',
		{
			data: { minReviews: MIN_REVIEWS },
		},
	);

	if (!response.ok()) {
		throw new Error(`Failed to fetch doctors: ${response.status()}`);
	}

	const { doctors } = await response.json();
	console.log(`Found ${doctors.length} doctors with ${MIN_REVIEWS}+ reviews`);

	let successCount = 0;
	let failCount = 0;

	for (const doctor of doctors) {
		for (const lang of LANGUAGES) {
			try {
				process.stdout.write(
					`  → Doctor ${doctor.id} (${doctor.name}) [${lang}]... `,
				);

				const response = await context.request.post(
					'/api/reviews/generate-ai-summary',
					{
						data: {
							targetType: 'doctor',
							targetId: doctor.id,
							language: lang,
							model: AI_MODEL,
						},
					},
				);

				if (response.ok()) {
					const result = await response.json();
					console.log(`✓ (${result.reviewsCount} reviews)`);
					successCount++;
				} else {
					console.log(`✗ Failed (${response.status()})`);
					failCount++;
				}

				await new Promise((resolve) => setTimeout(resolve, RATE_LIMIT_DELAY));
			} catch (error) {
				console.log(`✗ Error: ${error.message}`);
				failCount++;
			}
		}
	}

	console.log(`\nDoctors: ${successCount} success, ${failCount} failed`);
}

async function processClinics(context) {
	const response = await context.request.post(
		'/api/admin/clinics/with-reviews',
		{
			data: { minReviews: MIN_REVIEWS },
		},
	);

	if (!response.ok()) {
		throw new Error(`Failed to fetch clinics: ${response.status()}`);
	}

	const { clinics } = await response.json();
	console.log(`Found ${clinics.length} clinics with ${MIN_REVIEWS}+ reviews`);

	let successCount = 0;
	let failCount = 0;

	for (const clinic of clinics) {
		for (const lang of LANGUAGES) {
			try {
				process.stdout.write(
					`  → Clinic ${clinic.id} (${clinic.name}) [${lang}]... `,
				);

				const response = await context.request.post(
					'/api/reviews/generate-ai-summary',
					{
						data: {
							targetType: 'clinic',
							targetId: clinic.id,
							language: lang,
							model: AI_MODEL,
						},
					},
				);

				if (response.ok()) {
					const result = await response.json();
					console.log(`✓ (${result.reviewsCount} reviews)`);
					successCount++;
				} else {
					console.log(`✗ Failed (${response.status()})`);
					failCount++;
				}

				await new Promise((resolve) => setTimeout(resolve, RATE_LIMIT_DELAY));
			} catch (error) {
				console.log(`✗ Error: ${error.message}`);
				failCount++;
			}
		}
	}

	console.log(`\nClinics: ${successCount} success, ${failCount} failed`);
}

// Запуск
generateAISummaries();
```

#### 3.2 Добавление npm скрипта

**Файл:** `package.json`

```json
{
	"scripts": {
		"utils:ai-summary": "node tests/utilities/ai-summary-generation.ts",
		"utils:ai-summary:prod": "BASE_URL=https://docta.me node tests/utilities/ai-summary-generation.ts",
		"utils:ai-summary:gpt4": "AI_MODEL=gpt-4 node tests/utilities/ai-summary-generation.ts"
	}
}
```

#### 3.3 Вспомогательные API endpoints

**Файл:** `server/api/admin/doctors/with-reviews.post.ts`

```typescript
export default defineEventHandler(async (event) => {
	const body = await readBody(event);
	const { minReviews = 3 } = body;

	const doctors = await db.query(
		`SELECT DISTINCT d.id, d.name, COUNT(r.id) as reviews_count
     FROM doctors d
     JOIN reviews r ON r.target_type = 'doctor' AND r.target_id = d.id
     WHERE r.status = 'approved' AND r.deleted_at IS NULL
     GROUP BY d.id, d.name
     HAVING reviews_count >= ?
     ORDER BY reviews_count DESC`,
		[minReviews],
	);

	return { doctors };
});
```

**Файл:** `server/api/admin/clinics/with-reviews.post.ts`

```typescript
export default defineEventHandler(async (event) => {
	const body = await readBody(event);
	const { minReviews = 3 } = body;

	const clinics = await db.query(
		`SELECT DISTINCT c.id, c.name, COUNT(r.id) as reviews_count
     FROM clinics c
     JOIN reviews r ON r.target_type = 'clinic' AND r.target_id = c.id
     WHERE r.status = 'approved' AND r.deleted_at IS NULL
     GROUP BY c.id, c.name
     HAVING reviews_count >= ?
     ORDER BY reviews_count DESC`,
		[minReviews],
	);

	return { clinics };
});
```

### 4. Интеграция в секцию отзывов

**Файл:** `components/doctor/reviews-section.vue` (обновить)

```vue
<!-- Добавить AI Summary перед списком отзывов -->
<ReviewAiSummary :target-type="'doctor'" :target-id="doctorId" />
```

---

## Критерии приемки (Acceptance Criteria)

- [ ] **AC-1:** Интеграция с OpenAI API работает корректно
- [ ] **AC-2:** AI Summary генерируется на основе всех одобренных отзывов (внутренних + внешних)
- [ ] **AC-3:** AI Summary содержит: sentiment, positives (3-5 пунктов), negatives (0-5 пунктов), recommendations
- [ ] **AC-4:** AI Summary сохраняется в БД и кэшируется
- [ ] **AC-5:** AI Summary отображается на страницах врачей и клиник
- [ ] **AC-6:** AI Summary локализован (ru, en, sr)
- [ ] **AC-7:** Пользователь может обновить AI Summary вручную (кнопка "Обновить анализ")
- [ ] **AC-8:** AI Summary не генерируется, если отзывов < 3
- [ ] **AC-9:** Ошибки OpenAI API обрабатываются корректно
- [ ] **AC-10:** Playwright утилита `tests/utilities/ai-summary-generation.ts` успешно генерирует AI Summary для всех врачей/клиник
- [ ] **AC-11:** В утилите можно выбрать модель AI через env (gpt-4, gpt-4o-mini, gpt-3.5-turbo)
- [ ] **AC-12:** Утилита показывает прогресс генерации и статистику (успешно/ошибки)
- [ ] **AC-13:** API endpoints для получения врачей/клиник с отзывами работают
- [ ] **AC-14:** Утилита находится в `tests/utilities/`, а НЕ в `tests/e2e/`

---

## Как проверить

### 1. Ручная проверка через UI

1. Создать минимум 3 отзыва для врача/клиники
2. Перейти на страницу врача/клиники
3. Проверить, что AI Summary отображается (или кнопка "Сгенерировать AI анализ")
4. Проверить корректность sentiment, positives, negatives, recommendations
5. Нажать "Обновить анализ" и проверить регенерацию
6. Переключить язык и проверить локализацию
7. Проверить, что AI Summary кэшируется в БД

### 2. Запуск Playwright утилиты

```bash
# Локальное окружение
npm run utils:ai-summary

# Продакшн
npm run utils:ai-summary:prod

# С GPT-4
npm run utils:ai-summary:gpt4

# С кастомной конфигурацией
AI_MODEL=gpt-4 LANGUAGES=ru,en MIN_REVIEWS=5 node tests/utilities/ai-summary-generation.ts
```

### 3. Изменение модели AI

Через переменные окружения:

```bash
export AI_MODEL=gpt-4
export LANGUAGES=ru,en,sr
export MIN_REVIEWS=3
export RATE_LIMIT_DELAY=2000

npm run utils:ai-summary
```

### 4. Проверка результатов в БД

```sql
-- Проверка сгенерированных AI Summary
SELECT * FROM review_ai_summaries
WHERE target_type = 'doctor'
ORDER BY generated_at DESC
LIMIT 10;

-- Статистика по языкам
SELECT language, COUNT(*) as count
FROM review_ai_summaries
GROUP BY language;
```

---

## Оценка времени

**Ожидаемое время:** 3 дня  
**Сложность:** Высокая

---

**Назад:** [← К списку итераций](README.md)  
**Далее:** [Итерация 6: Модерация →](iteration-06-moderation.md)
