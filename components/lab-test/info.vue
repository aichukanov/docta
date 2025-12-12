<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import labTestI18n from '~/i18n/lab-test';

const props = defineProps<{
	name: string;
	originalName?: string;
	synonyms?: string[];
	short?: boolean;
	itemId?: number;
	detailsRouteName?: string;
	detailsParamName?: string;
}>();

const { t, locale } = useI18n(labTestI18n);

const detailsLink = computed(() => {
	if (!props.detailsRouteName || !props.detailsParamName || !props.itemId) {
		return null;
	}
	return {
		name: props.detailsRouteName,
		params: { [props.detailsParamName]: props.itemId },
		query: getRegionalQuery(locale.value),
	};
});
</script>

<template>
	<div class="lab-test-info">
		<h3 class="lab-test-name">
			<NuxtLink v-if="detailsLink" :to="detailsLink" class="lab-test-link">
				{{ name }}
			</NuxtLink>
			<template v-else>{{ name }}</template>
		</h3>
		<div v-if="originalName" class="lab-test-original">
			{{ originalName }}
		</div>
		<div v-if="!short && synonyms?.length" class="lab-test-synonyms">
			<span class="synonyms-label">{{ t('Synonyms') }}:</span>
			<span class="synonyms-list">{{ synonyms.join(', ') }}</span>
		</div>
	</div>
</template>

<style scoped lang="less">
.lab-test-info {
	.lab-test-name {
		font-size: 1.25rem;
		font-weight: 600;
		color: #1f2937;
		margin: 0;
		font-family: system-ui, -apple-system, sans-serif;

		.lab-test-link {
			color: var(--color-primary);
			text-decoration: none;

			&:hover {
				color: var(--color-primary-dark);
				text-decoration: underline;
			}
		}
	}

	.lab-test-original {
		font-size: 0.9rem;
		color: #6b7280;
		margin-top: var(--spacing-xs);
		font-style: italic;
	}

	.lab-test-synonyms {
		font-size: 0.85rem;
		color: #6b7280;
		margin-top: var(--spacing-sm);

		.synonyms-label {
			color: #9ca3af;
			margin-right: var(--spacing-xs);
		}

		.synonyms-list {
			color: #6b7280;
		}
	}
}
</style>

