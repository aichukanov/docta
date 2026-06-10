<script setup lang="ts">
import { getDetailLinkQuery } from '~/common/url-utils';
import labTestI18n from '~/i18n/labtest';
import labTestCategoryI18n from '~/i18n/labtest-category';
import { combineI18nMessages } from '~/i18n/utils';
import { toCyrillic } from '~/common/serbian-transliteration';

const props = withDefaults(
	defineProps<{
		name: string;
		localName?: string;
		synonyms?: string[];
		categoryIds?: number[];
		short?: boolean;
		itemId?: number;
		itemSlug?: string;
		detailsRouteName?: string;
		detailsParamName?: string;
		// Активный city-фильтр на listing-странице. Переносим в URL детальной,
		// чтобы выбор пользователя сохранялся и у каждого города был свой
		// канонический URL.
		filterCityIds?: number[];
	}>(),
	{
		filterCityIds: () => [],
	},
);

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([labTestI18n, labTestCategoryI18n]),
});

const detailsLink = computed(() => {
	if (!props.detailsRouteName || !props.detailsParamName || !props.itemSlug) {
		return null;
	}
	return {
		name: props.detailsRouteName,
		params: { [props.detailsParamName]: props.itemSlug },
		query: getDetailLinkQuery(locale.value, props.filterCityIds),
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
			<CategoryTag v-for="categoryId in categoryIds" :key="categoryId" small>
				{{ t(`lab_test_category_${categoryId}`) }}
			</CategoryTag>
		</div>
	</div>
</template>

<style scoped lang="less">
.lab-test-info {
	padding: 0 var(--spacing-xs);

	.lab-test-name {
		font-size: var(--font-size-xl);
		font-weight: 600;
		color: var(--color-text-heading);
		margin: 0;
		font-family:
			system-ui,
			-apple-system,
			sans-serif;
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
		font-size: var(--font-size-sm);
		color: var(--color-text-muted);
		margin-top: var(--spacing-xs);
		font-style: italic;
		word-break: break-word;
	}

	.lab-test-categories {
		display: flex;
		flex-wrap: wrap;
		gap: var(--spacing-xs);
		margin-top: var(--spacing-sm);
	}

	.lab-test-synonyms {
		font-size: var(--font-size-sm);
		color: var(--color-text-muted);
		margin-top: var(--spacing-sm);

		.synonyms-label {
			margin-right: var(--spacing-xs);
		}

		.synonyms-list {
			color: var(--color-text-muted);
		}
	}
}
</style>
