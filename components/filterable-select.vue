<script setup lang="ts">
import type { ElSelectV2 } from 'element-plus';

type ValueType = string | number;

const selectRef = ref<InstanceType<typeof ElSelectV2>>();

const props = withDefaults(
	defineProps<{
		items: { value: ValueType; label: string }[];
		value: ValueType | ValueType[] | null;
		placeholder?: string;
		placeholderSearch?: string;
		ariaLabel?: string;
		noDataText?: string;
		multiple?: boolean;
		clearable?: boolean;
		/**
		 * Переносить длинные подписи на вторую строку. По умолчанию выключено:
		 * `el-select-v2` — виртуальный список с фиксированной высотой строки, и
		 * увеличение высоты ради переноса съедает видимую часть выпадашки. Там,
		 * где подписи короткие (города, специальности), это не нужно.
		 */
		wrapItems?: boolean;
	}>(),
	{
		placeholder: '',
		placeholderSearch: '',
		ariaLabel: '',
		noDataText: '',
		multiple: false,
		clearable: false,
		wrapItems: false,
	},
);

// Высота строки виртуального списка. 34 — дефолт Element Plus (одна строка),
// 52 хватает на две при line-height 1.3.
const itemHeight = computed(() => (props.wrapItems ? 52 : 34));

const emit = defineEmits<{
	(e: 'update:value', value: ValueType | ValueType[] | null): void;
}>();

const value = computed({
	get: () => props.value,
	set: (value: ValueType | ValueType[] | null) => {
		emit('update:value', value);
	},
});
</script>

<template>
	<el-select-v2
		ref="selectRef"
		v-model="value"
		:options="items"
		:placeholder="placeholder"
		:aria-label="ariaLabel"
		:no-data-text="noDataText"
		:multiple="multiple"
		:clearable="clearable"
		:item-height="itemHeight"
		:class="{ 'filterable-select--wrap': wrapItems }"
		:popper-class="wrapItems ? 'filterable-select-popper--wrap' : ''"
		filterable
		size="large"
		@change="selectRef?.blur()"
	>
		<!-- title даёт нативную подсказку с полным текстом: подписи вроде
		     «Гинекологическое противоинфекционное» не влезают в ширину панели -->
		<template #default="{ item }">
			<span class="filterable-select__option" :title="item.label">
				{{ item.label }}
			</span>
		</template>
	</el-select-v2>
</template>

<style lang="less" scoped>
.filterable-select__option {
	display: block;
	overflow: hidden;
	text-overflow: ellipsis;
}
</style>

<style lang="less">
/* Выпадашка живёт в teleport вне scope компонента, поэтому стиль глобальный
   и включается только своим popper-классом */
.filterable-select-popper--wrap .el-select-dropdown__item {
	display: flex;
	align-items: center;
	line-height: 1.3;
	white-space: normal;
}

.filterable-select-popper--wrap .filterable-select__option {
	display: -webkit-box;
	-webkit-line-clamp: 2;
	line-clamp: 2;
	-webkit-box-orient: vertical;
	white-space: normal;
}
</style>
