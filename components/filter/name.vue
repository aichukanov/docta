<template>
	<FilterWrapper :label="label">
		<el-input
			v-model="localName"
			:placeholder="placeholder"
			:aria-label="label"
			size="large"
		/>
	</FilterWrapper>
</template>

<script setup lang="ts">
import { debounce } from 'lodash-es';

const props = defineProps<{
	label: string;
	placeholder: string;
	value: string;
}>();

const emit = defineEmits<{
	(e: 'update:value', value: string): void;
}>();

const localName = ref(props.value);

const emitName = debounce((value: string) => {
	emit('update:value', value);
}, 300);

watch(localName, (value) => {
	emitName(value);
});

watch(
	() => props.value,
	(value) => {
		if (value !== localName.value) {
			localName.value = value;
		}
	},
);
</script>
