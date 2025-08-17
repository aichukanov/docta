<template>
	<div class="pagination-wrapper">
		<el-pagination
			background
			layout="prev, pager, next"
			:total="total"
			:page-size="RECORD_LIMIT"
			:pager-count="5"
			:disabled="disabled"
			v-model:current-page="pageNumber"
		/>
	</div>
</template>

<script setup lang="ts">
const RECORD_LIMIT = 36;

const props = defineProps({
	total: { type: Number, default: 1 },
	currentPage: { type: Number, default: 1 },
	disabled: { type: Boolean, default: false },
});

const emit = defineEmits(['update:current-page']);

const pageNumber = computed({
	get() {
		return props.currentPage;
	},
	set(value) {
		window.scrollTo(0, 0);
		emit('update:current-page', value);
	},
});
</script>

<style lang="less" scoped>
.pagination-wrapper {
	display: flex;
	align-items: flex-end;
	flex-direction: column;
	margin: 10px 0;
	flex: 0 0 30px;
}
</style>
