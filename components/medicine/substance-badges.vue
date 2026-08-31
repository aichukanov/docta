<!--
  Бейджи действующих веществ с состоянием сопоставления относительно текущей карточки:
  matched — есть в карточке (акцент), extra — лишнее (пунктир + тултип), missing —
  отсутствует (перечёркнут). Переиспользуется в блоке «аналоги в других странах» и в
  секции аналогов/компонентов. DRY: единый вид и логика бейджей.
-->
<template>
	<div v-if="items.length || missing.length" class="substance-badges">
		<span
			v-for="(s, i) in items"
			:key="'s' + i"
			class="substance-badge"
			:class="s.state === 'matched' ? 'is-match' : 'is-extra'"
			:title="s.state === 'extra' ? extraTitle || undefined : undefined"
			>{{ s.name }}</span
		>
		<span
			v-for="(m, i) in missing"
			:key="'m' + i"
			class="substance-badge is-missing"
			>{{ m }}</span
		>
	</div>
</template>

<script setup lang="ts">
import type { MedicineForeignSubstance } from '~/interfaces/medicine';

withDefaults(
	defineProps<{
		items: MedicineForeignSubstance[];
		missing?: string[];
		extraTitle?: string;
	}>(),
	{ missing: () => [], extraTitle: '' },
);
</script>

<style scoped>
.substance-badges {
	display: flex;
	flex-wrap: wrap;
	gap: 6px;
}

.substance-badge {
	font-size: var(--kit-font-size-sm);
	line-height: 1;
	padding: 5px 9px;
	border-radius: 999px;
	white-space: nowrap;
}

.substance-badge.is-match {
	background: var(--kit-color-primary-bg);
	color: var(--kit-color-primary-dark);
	font-weight: var(--kit-font-weight-semibold);
}

.substance-badge.is-extra {
	background: var(--kit-color-bg-primary);
	color: #92620b;
	border: 1px dashed var(--kit-color-accent);
	cursor: help;
}

.substance-badge.is-missing {
	background: transparent;
	color: var(--kit-color-text-light);
	border: 1px solid var(--kit-color-border-secondary);
	text-decoration: line-through;
}
</style>
