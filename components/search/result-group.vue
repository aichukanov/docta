<script setup lang="ts">
import type { RouteLocationRaw } from 'vue-router';

// Группа выдачи глобального поиска: заголовок категории, строки и ссылка
// «ещё N» на соответствующий листинг.
defineProps<{
	title: string;
	moreTo?: RouteLocationRaw | null;
	moreLabel?: string | null;
}>();

const emit = defineEmits<{ (e: 'navigate'): void }>();
</script>

<template>
	<div class="search-group">
		<div class="search-group__title">
			<slot name="icon" />
			{{ title }}
		</div>
		<slot />
		<NuxtLink
			v-if="moreTo && moreLabel"
			:to="moreTo"
			class="search-group__more"
			@click="emit('navigate')"
		>
			{{ moreLabel }}
		</NuxtLink>
	</div>
</template>

<style lang="less" scoped>
.search-group {
	border-bottom: var(--kit-border-width-thin) solid var(--kit-color-border-secondary);

	&:last-child {
		border-bottom: none;
	}

	&__title {
		display: flex;
		align-items: center;
		gap: var(--kit-spacing-sm);
		padding: var(--kit-spacing-md) var(--kit-spacing-lg) var(--kit-spacing-xs);
		font-size: var(--kit-font-size-xs);
		font-weight: var(--kit-font-weight-semibold);
		text-transform: uppercase;
		letter-spacing: 0.05em;
		color: var(--kit-color-text-muted);

		// См. комментарий в result-row: не все icon-компоненты знают про size
		:deep(svg) {
			flex: 0 0 16px;
			width: 16px;
			height: 16px;
		}
	}

	// Строки внутри группы разделены тонкой линией — так видно, где
	// заканчивается многострочная карточка и начинается следующая
	:deep(.search-row + .search-row) {
		border-top: var(--kit-border-width-thin) solid var(--kit-color-border-light);
	}

	&__more {
		display: block;
		// Выровнено по тексту строк: иконка + отступ + внутренний отступ строки
		padding: var(--kit-spacing-sm) var(--kit-spacing-lg) var(--kit-spacing-md)
			calc(40px + var(--kit-spacing-md) + var(--kit-spacing-lg));
		color: var(--kit-color-primary);
		text-decoration: none;
		font-size: var(--kit-font-size-sm);
		transition: background var(--kit-transition-fast);

		&:hover {
			background: var(--kit-color-bg-secondary);
		}
	}
}

@media (max-width: 640px) {
	.search-group {
		&__title {
			padding: var(--kit-spacing-sm) var(--kit-spacing-md) var(--kit-spacing-xs);
		}

		&__more {
			padding: var(--kit-spacing-sm) var(--kit-spacing-md) var(--kit-spacing-md)
				calc(36px + var(--kit-spacing-md) + var(--kit-spacing-md));
		}
	}
}
</style>
