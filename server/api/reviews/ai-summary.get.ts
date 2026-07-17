import { executeQuery } from '~/server/common/db-mysql';
import type { ReviewAiSummary } from '~/interfaces/review';

const VALID_LOCALES = ['en', 'ru', 'sr', 'sr-cyrl', 'de', 'tr'];

type AiSummaryEntityType = 'doctor' | 'clinic';

function parseJsonColumn(value: unknown): string[] {
	if (Array.isArray(value)) return value;
	if (typeof value === 'string') {
		try {
			const parsed = JSON.parse(value);
			return Array.isArray(parsed) ? parsed : [];
		} catch {
			return [];
		}
	}
	return [];
}

/**
 * Кэшированный AI-обзор отзывов сущности.
 * GET /api/reviews/ai-summary?entityType=doctor|clinic&entityId=N&locale=ru
 *
 * Только чтение кэша из review_ai_summaries (или null). Генерация — ручной
 * workflow без API-ключа: см. docs/import/AI_SUMMARY_WORKFLOW.md.
 */
export default defineEventHandler(
	async (event): Promise<{ summary: ReviewAiSummary | null }> => {
		const query = getQuery(event);
		const entityType = String(query.entityType || '') as AiSummaryEntityType;
		const entityId = parseInt(String(query.entityId || ''), 10);
		const locale = VALID_LOCALES.includes(String(query.locale))
			? String(query.locale)
			: 'en';

		if (!['doctor', 'clinic'].includes(entityType) || !entityId || entityId <= 0) {
			return { summary: null };
		}

		const rows = await executeQuery<any>(
			`SELECT sentiment, positives, negatives, recommendations, reviews_count,
				generated_at, regenerated_at
			FROM review_ai_summaries
			WHERE entity_type = ? AND entity_id = ? AND language = ?`,
			[entityType, entityId, locale],
		);
		const cached = rows[0] || null;

		if (!cached) return { summary: null };

		return {
			summary: {
				sentiment: cached.sentiment,
				positives: parseJsonColumn(cached.positives),
				negatives: parseJsonColumn(cached.negatives),
				recommendations: cached.recommendations || null,
				reviewsCount: cached.reviews_count,
				generatedAt: cached.regenerated_at || cached.generated_at,
			},
		};
	},
);
