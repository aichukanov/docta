<script setup lang="ts">
import reviewsI18n from '~/i18n/reviews';
import { combineI18nMessages } from '~/i18n/utils';

const { t } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([reviewsI18n]),
});
</script>

<template>
	<span class="verified-badge" :title="t('VerifiedReviewHint')">
		<IconCheck :size="12" />
		{{ t('VerifiedReview') }}
	</span>
</template>

<style scoped>
.verified-badge {
	display: inline-flex;
	align-items: center;
	gap: var(--spacing-xs);
	font-size: var(--font-size-sm);
	font-weight: var(--font-weight-medium);
	color: var(--color-success-dark);
	background: var(--color-success-bg);
	padding: 2px var(--spacing-sm);
	border-radius: var(--border-radius-sm);
	white-space: nowrap;
}
</style>
