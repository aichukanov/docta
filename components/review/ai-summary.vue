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
	gap: var(--kit-spacing-md);
	padding: var(--kit-spacing-xl);
	border: var(--kit-border-width-thin) solid var(--kit-color-border-secondary);
	border-radius: var(--kit-border-radius-xl);
	background: var(--kit-color-bg-secondary);
}

.ai-summary-header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	flex-wrap: wrap;
	gap: var(--kit-spacing-sm);
}

.ai-summary-title {
	display: flex;
	align-items: center;
	gap: var(--kit-spacing-sm);
	margin: 0;
	font-size: var(--kit-font-size-lg);
	font-weight: var(--kit-font-weight-semibold);
	color: var(--kit-color-text-primary);
}

.sentiment-badge {
	font-size: var(--kit-font-size-sm);
	font-weight: var(--kit-font-weight-medium);
	padding: 2px var(--kit-spacing-md);
	border-radius: var(--kit-border-radius-full, 999px);
}

.sentiment-positive {
	color: var(--kit-color-success-dark);
	background: var(--kit-color-success-bg);
}

.sentiment-neutral {
	color: var(--kit-color-text-secondary);
	background: var(--kit-color-bg-primary);
}

.sentiment-negative {
	color: var(--kit-color-danger-dark);
	background: var(--kit-color-danger-bg);
}

.ai-summary-section {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-xs);
}

.section-title {
	margin: 0;
	font-size: var(--kit-font-size-base);
	font-weight: var(--kit-font-weight-semibold);
	color: var(--kit-color-text-secondary);
}

.ai-summary-list {
	margin: 0;
	padding-left: var(--kit-spacing-xl);
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-xs);
	color: var(--kit-color-text-primary);
	line-height: 1.5;
}

.ai-summary-recommendations {
	margin: 0;
	padding: var(--kit-spacing-md);
	background: var(--kit-color-bg-primary);
	border-radius: var(--kit-border-radius-md);
	color: var(--kit-color-text-primary);
	line-height: 1.6;
}

.ai-summary-footer {
	font-size: var(--kit-font-size-sm);
	color: var(--kit-color-text-muted);
}
</style>
