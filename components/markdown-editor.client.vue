<script setup lang="ts">
import { MdEditor } from 'md-editor-v3';
import type { ToolbarNames } from 'md-editor-v3';
import 'md-editor-v3/lib/style.css';

withDefaults(
	defineProps<{
		modelValue: string;
		height?: string;
		placeholder?: string;
	}>(),
	{
		height: '200px',
		placeholder: '',
	},
);

const emit = defineEmits<{
	(e: 'update:modelValue', value: string): void;
}>();

const toolbars: ToolbarNames[] = [
	'bold',
	'italic',
	'strikeThrough',
	'-',
	'title',
	'quote',
	'unorderedList',
	'orderedList',
	'-',
	'link',
	'table',
	'-',
	'revoke',
	'next',
	'=',
	'preview',
];
</script>

<template>
	<MdEditor
		:modelValue="modelValue"
		@update:modelValue="emit('update:modelValue', $event)"
		:toolbars="toolbars"
		:language="'en-US'"
		:noUploadImg="true"
		:preview="false"
		:placeholder="placeholder"
		:height="height"
		class="md-editor-wrapper"
	/>
</template>

<style>
.md-editor-wrapper.md-editor {
	--md-bk-color: var(--color-bg-primary);
	--md-border-color: var(--color-border-secondary);

	border-radius: var(--border-radius-md);
	font-family: inherit;
}
</style>
