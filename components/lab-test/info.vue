<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import labTestI18n from '~/i18n/labtest';
import labTestCategoryI18n from '~/i18n/labtest-category';
import { combineI18nMessages } from '~/i18n/utils';
import { toCyrillic } from '~/common/serbian-transliteration';

const props = defineProps<{
	name: string;
	localName?: string;
	synonyms?: string[];
	categoryIds?: number[];
	short?: boolean;
	itemId?: number;
	detailsRouteName?: string;
	detailsParamName?: string;
}>();

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([labTestI18n, labTestCategoryI18n]),
});

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
		<h2 class="lab-test-name">
			<NuxtLink v-if="detailsLink" :to="detailsLink" class="lab-test-link">
				{{ name }}
			</NuxtLink>
			<template v-else>{{ name }}</template>
		</h2>
		<div v-if="localName" class="lab-test-original">
			{{ localName }}
		</div>
		<div v-if="!short && synonyms?.length" class="lab-test-synonyms">
			<span class="synonyms-label">{{ t('Synonyms') }}:</span>
			<span class="synonyms-list">{{ synonyms.join(', ') }}</span>
		</div>
		<div v-if="categoryIds?.length" class="lab-test-categories">
			<span
				v-for="categoryId in categoryIds"
				:key="categoryId"
				class="category-tag"
			>
				{{ t(`lab_test_category_${categoryId}`) }}
			</span>
		</div>
	</div>
</template>

<style scoped lang="less">
.lab-test-info {
	padding: 0 var(--spacing-xs);

	.lab-test-name {
		font-size: 1.25rem;
		font-weight: 600;
		color: #1f2937;
		margin: 0;
		font-family: system-ui, -apple-system, sans-serif;
		word-break: break-word;

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
		word-break: break-word;
	}

	.lab-test-categories {
		display: flex;
		flex-wrap: wrap;
		gap: var(--spacing-xs);
		margin-top: var(--spacing-sm);

		.category-tag {
			display: inline-block;
			font-size: 0.75rem;
			color: var(--color-primary);
			background: rgba(79, 70, 229, 0.08);
			padding: 2px 8px;
			border-radius: 4px;
			border: 1px solid rgba(79, 70, 229, 0.15);
		}
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
