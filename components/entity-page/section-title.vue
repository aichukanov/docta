<script setup lang="ts">
defineProps<{
	title: string;
	count?: number;
	link?: object;
}>();
</script>

<template>
	<div class="section-title-row">
		<span v-if="$slots.icon" class="section-title-icon">
			<slot name="icon" />
		</span>
		<NuxtLink v-if="link" :to="link" class="section-title-link">
			<h2 class="section-title">{{ title }}</h2>
		</NuxtLink>
		<!-- Слот — для заголовков, которым нужен не только текст (купонный талон
		     в табе «Купоны»); обычные секции передают title строкой -->
		<h2 v-else class="section-title">
			<slot>{{ title }}</slot>
		</h2>
		<span v-if="count != null" class="section-title-count">{{ count }}</span>
	</div>
</template>

<style lang="less" scoped>
.section-title-row {
	display: flex;
	align-items: baseline;
	gap: var(--kit-spacing-md);
}

.section-title-icon {
	display: flex;
	align-items: center;
	align-self: center;
	color: var(--kit-color-text-primary);
	flex-shrink: 0;
}

.section-title-link {
	text-decoration: none;
	color: inherit;

	&:hover .section-title {
		color: var(--kit-color-primary);
	}
}

.section-title {
	font-size: var(--kit-font-size-lg);
	font-weight: 600;
	color: var(--kit-color-text-primary);
	margin: 0;
	font-family:
		system-ui,
		-apple-system,
		sans-serif;
	transition: color 0.15s ease;
}

.section-title-count {
	font-size: var(--kit-font-size-sm);
	font-weight: 500;
	color: var(--kit-color-text-secondary);
	background: var(--kit-color-bg-tertiary);
	padding: 2px 8px;
	border-radius: 10px;
	line-height: 1.4;
}
</style>
