<template>
	<div class="pagination-wrapper" :class="`pagination-wrapper_align_${align}`">
		<el-pagination
			background
			layout="prev, pager, next"
			:total="total"
			:page-size="pageSize"
			:pager-count="5"
			:disabled="disabled"
			v-model:current-page="pageNumber"
		/>
	</div>
</template>

<script setup lang="ts">
const props = withDefaults(
	defineProps<{
		total: number;
		currentPage: number;
		disabled?: boolean;
		pageSize?: number;
		align?: 'center' | 'right';
	}>(),
	{
		pageSize: 20,
		disabled: false,
		align: 'right',
	},
);

const emit = defineEmits(['update:current-page']);

const pageNumber = computed({
	get() {
		return props.currentPage;
	},
	set(value) {
		emit('update:current-page', value);
	},
});
</script>

<style lang="less" scoped>
.pagination-wrapper {
	display: flex;
	flex-direction: column;
	margin: 10px 0;
	flex: 0 0 30px;

	&_align_center {
		align-items: center;
	}

	&_align_right {
		align-items: flex-end;
	}
}
</style>
