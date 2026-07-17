<script setup lang="ts">
import reviewsI18n from '~/i18n/reviews';
import { combineI18nMessages } from '~/i18n/utils';
import type { ReviewAiSummary } from '~/interfaces/review';

const props = defineProps<{
	entityType: 'doctor' | 'clinic';
	entityId: number;
}>();

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([reviewsI18n]),
});

// Кэш читается быстро, но блок не критичен для SEO/SSR — грузим на клиенте.
// params реактивные: при клиентском переходе между сущностями компонент
// переиспользуется без remount, и сводка обязана перезапрашиваться
const { data } = useFetch<{ summary: ReviewAiSummary | null }>(
	'/api/reviews/ai-summary',
	{
		params: {
			entityType: computed(() => props.entityType),
			entityId: computed(() => props.entityId),
			locale,
		},
		server: false,
		lazy: true,
	},
);

const summary = computed(() => data.value?.summary || null);

const sentimentClass = computed(() => `sentiment-${summary.value?.sentiment}`);

const sentimentLabel = computed(() => {
	const labels: Record<string, string> = {
		positive: t('AiSentimentPositive'),
		neutral: t('AiSentimentNeutral'),
		negative: t('AiSentimentNegative'),
	};
	return labels[summary.value?.sentiment || ''] || '';
});
</script>

<template>
	<section v-if="summary" class="ai-summary" aria-labelledby="ai-summary-title">
		<header class="ai-summary-header">
			<h2 id="ai-summary-title" class="ai-summary-title">
				<IconLightbulb :size="18" />
				{{ t('AiSummaryTitle') }}
			</h2>
			<span class="sentiment-badge" :class="sentimentClass">
				{{ sentimentLabel }}
			</span>
		</header>

		<div v-if="summary.positives.length > 0" class="ai-summary-section">
			<h3 class="section-title">{{ t('AiSummaryPositives') }}</h3>
			<ul class="ai-summary-list">
				<li v-for="(item, index) in summary.positives" :key="index">
					{{ item }}
				</li>
			</ul>
		</div>

		<div v-if="summary.negatives.length > 0" class="ai-summary-section">
			<h3 class="section-title">{{ t('AiSummaryNegatives') }}</h3>
			<ul class="ai-summary-list negatives">
				<li v-for="(item, index) in summary.negatives" :key="index">
					{{ item }}
				</li>
			</ul>
		</div>

		<p v-if="summary.recommendations" class="ai-summary-recommendations">
			{{ summary.recommendations }}
		</p>

		<footer class="ai-summary-footer">
			{{ t('AiSummaryDisclaimer', { count: summary.reviewsCount }) }}
		</footer>
	</section>
</template>

<style scoped>
.ai-summary {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
	padding: var(--spacing-xl);
	border: var(--border-width-thin) solid var(--color-border-secondary);
	border-radius: var(--border-radius-xl);
	background: var(--color-bg-secondary);
}

.ai-summary-header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	flex-wrap: wrap;
	gap: var(--spacing-sm);
}

.ai-summary-title {
	display: flex;
	align-items: center;
	gap: var(--spacing-sm);
	margin: 0;
	font-size: var(--font-size-lg);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-primary);
}

.sentiment-badge {
	font-size: var(--font-size-sm);
	font-weight: var(--font-weight-medium);
	padding: 2px var(--spacing-md);
	border-radius: var(--border-radius-full, 999px);
}

.sentiment-positive {
	color: var(--color-success-dark);
	background: var(--color-success-bg);
}

.sentiment-neutral {
	color: var(--color-text-secondary);
	background: var(--color-bg-primary);
}

.sentiment-negative {
	color: var(--color-danger-dark);
	background: var(--color-danger-bg);
}

.ai-summary-section {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xs);
}

.section-title {
	margin: 0;
	font-size: var(--font-size-base);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-secondary);
}

.ai-summary-list {
	margin: 0;
	padding-left: var(--spacing-xl);
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xs);
	color: var(--color-text-primary);
	line-height: 1.5;
}

.ai-summary-recommendations {
	margin: 0;
	padding: var(--spacing-md);
	background: var(--color-bg-primary);
	border-radius: var(--border-radius-md);
	color: var(--color-text-primary);
	line-height: 1.6;
}

.ai-summary-footer {
	font-size: var(--font-size-sm);
	color: var(--color-text-muted);
}
</style>
