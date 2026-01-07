<script setup lang="ts">
export interface PricedItem {
	id: number;
	name: string;
	localName?: string;
	price?: number | null;
}

defineProps<{
	title?: string;
	items: PricedItem[];
	routeName?: string;
	routeParamName?: string;
}>();
</script>

<template>
	<section class="content-section">
		<h4 v-if="title" class="section-title">{{ title }}</h4>
		<div class="items-grid">
			<PricedItemCard
				v-for="item in items"
				:key="item.id"
				:id="item.id"
				:name="item.name"
				:localName="item.localName"
				:price="item.price"
				:routeName="routeName"
				:routeParamName="routeParamName"
			/>
		</div>
	</section>
</template>

<style scoped lang="less">
.content-section {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
}

.section-title {
	margin: 0;
	font-size: var(--font-size-md);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-primary);
	display: flex;
	align-items: center;
	gap: var(--spacing-sm);

	&::before {
		content: '';
		width: 3px;
		height: 1em;
		background: var(--color-primary);
		border-radius: 2px;
	}
}

.items-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
	gap: var(--spacing-sm);
}

@media (max-width: 400px) {
	.items-grid {
		grid-template-columns: 1fr;
	}
}
</style>
