<script setup lang="ts" generic="T">
import { getRegionalQuery } from '~/common/url-utils';

interface Props {
	title: string;
	items: T[];
	routeName: string;
	initialLimit?: number;
}

const props = withDefaults(defineProps<Props>(), {
	initialLimit: 10,
});

const { locale } = useI18n();

const totalCount = computed(() => props.items.length);

const sectionLink = computed(() => ({
	name: props.routeName,
	query: {
		...getRegionalQuery(locale.value),
	},
}));
</script>

<template>
	<div v-if="items.length > 0" class="service-section">
		<EntityPageSectionTitle
			:title="title"
			:count="totalCount"
			:link="sectionLink"
		>
			<template #icon>
				<slot name="icon" />
			</template>
		</EntityPageSectionTitle>

		<ClinicServiceSectionContent :items="items" :initialLimit="initialLimit">
			<template #default="{ item }">
				<slot :item="item" />
			</template>
		</ClinicServiceSectionContent>
	</div>
</template>

<style lang="less" scoped>
.service-section {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
}
</style>
