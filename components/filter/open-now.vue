<template>
	<el-checkbox v-model="checked" size="large">{{ label }}</el-checkbox>
</template>

<script setup lang="ts">
const props = defineProps<{
	label: string;
	value: boolean;
}>();

const emit = defineEmits<{
	(e: 'update:value', value: boolean): void;
}>();

const checked = computed({
	get: () => props.value,
	set: (value: boolean) => {
		emit('update:value', value);
	},
});
</script>
