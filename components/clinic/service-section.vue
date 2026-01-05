<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';

interface Props {
	title: string;
	items: unknown[];
	routeName: string;
	clinicId: number;
	initialLimit?: number;
}

const props = withDefaults(defineProps<Props>(), {
	initialLimit: 10,
});

const { t, locale } = useI18n();

const showAll = ref(false);

const totalCount = computed(() => props.items.length);

const visibleItems = computed(() =>
	showAll.value ? props.items : props.items.slice(0, props.initialLimit),
);

const sectionLink = computed(() => ({
	name: props.routeName,
	query: {
		...getRegionalQuery(locale.value),
		clinicIds: props.clinicId,
	},
}));

const hasMoreItems = computed(() => totalCount.value > props.initialLimit);
</script>

<template>
	<div v-if="items.length > 0" class="service-section">
		<div class="section-header">
			<slot name="icon" />
			<NuxtLink :to="sectionLink" class="section-title-link">
				<h2 class="section-title">{{ title }}</h2>
			</NuxtLink>
			<el-badge :value="totalCount" class="section-badge" />
		</div>
		<div class="section-content">
			<slot :items="visibleItems" />
			<button
				v-if="hasMoreItems"
				class="show-more-button"
				@click="showAll = !showAll"
			>
				{{
					showAll
						? t('ShowLess')
						: t('ShowMore', { count: totalCount - initialLimit })
				}}
			</button>
		</div>
	</div>
</template>

<i18n lang="json">
{
	"en": {
		"ShowMore": "Show more ({count})",
		"ShowLess": "Show less"
	},
	"ru": {
		"ShowMore": "Показать ещё ({count})",
		"ShowLess": "Свернуть"
	},
	"de": {
		"ShowMore": "Mehr anzeigen ({count})",
		"ShowLess": "Weniger anzeigen"
	},
	"tr": {
		"ShowMore": "Daha fazla göster ({count})",
		"ShowLess": "Daha az göster"
	},
	"sr": {
		"ShowMore": "Prikaži više ({count})",
		"ShowLess": "Prikaži manje"
	},
	"sr-cyrl": {
		"ShowMore": "Прикажи више ({count})",
		"ShowLess": "Прикажи мање"
	}
}
</i18n>

<style lang="less" scoped>
.service-section {
	background: var(--color-surface-primary);
	border: 1px solid var(--color-border-light);
	border-radius: var(--border-radius-md);
	overflow: hidden;
}

.section-header {
	display: flex;
	align-items: center;
	gap: var(--spacing-md);
	padding: var(--spacing-lg) var(--spacing-xl);
	background: linear-gradient(to right, rgba(79, 70, 229, 0.04), transparent);
	border-bottom: 1px solid var(--color-border-light);
}

.section-header :slotted(svg) {
	width: 24px;
	height: 24px;
	color: var(--color-primary);
	flex-shrink: 0;
}

.section-title-link {
	flex: 1;
	text-decoration: none;
	color: inherit;

	&:hover .section-title {
		color: var(--color-primary);
	}
}

.section-title {
	font-size: var(--font-size-lg);
	font-weight: 600;
	color: var(--color-text-primary);
	margin: 0;
	font-family: system-ui, -apple-system, sans-serif;
	transition: color var(--transition-base);
}

.section-badge {
	:deep(.el-badge__content) {
		background: var(--color-primary);
	}
}

.section-content {
	padding: var(--spacing-lg) var(--spacing-xl);
}

.show-more-button {
	display: flex;
	align-items: center;
	justify-content: center;
	width: 100%;
	padding: var(--spacing-md);
	margin-top: var(--spacing-md);
	background: transparent;
	border: 1px dashed var(--color-border-light);
	border-radius: var(--border-radius-md);
	color: var(--color-primary);
	font-size: var(--font-size-sm);
	font-weight: 500;
	cursor: pointer;
	transition: all var(--transition-base);

	&:hover {
		border-color: var(--color-primary);
		background: rgba(79, 70, 229, 0.04);
	}
}
</style>
