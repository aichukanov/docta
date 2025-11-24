<script setup lang="ts">
import { RefreshLeft } from '@element-plus/icons-vue';

const props = withDefaults(
	defineProps<{
		label: string;
		value?: string | null;
		modified?: boolean;
		type?: 'text' | 'photo';
	}>(),
	{
		value: '',
		type: 'text',
		modified: false,
	},
);

const emit = defineEmits<{
	(e: 'update:value', value: string): void;
	(e: 'reset'): void;
}>();

const editableValue = computed({
	get: () => props.value,
	set: (value: string) => emit('update:value', value),
});
</script>

<template>
	<div class="field" :class="{ modified: props.modified }">
		<label>{{ props.label }}</label>

		<div v-if="props.type === 'photo'" class="photo-container">
			<img :src="editableValue" width="100" height="100" />
			<el-input v-model="editableValue" type="textarea" :rows="3" />
		</div>
		<el-input v-else v-model="editableValue">
			<template #append v-if="props.modified">
				<el-button :icon="RefreshLeft" @click="$emit('reset')" />
			</template>
		</el-input>
	</div>
</template>

<style scoped lang="less">
.field {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xs);

	& > label {
		color: var(--color-text-secondary);
		font-size: 14px;
	}

	&.modified {
		& > label {
			color: #f59e0b;
			font-weight: 500;
		}
	}
}

.photo-container {
	display: flex;
	flex-direction: row;
	align-items: flex-start;
	gap: var(--spacing-md);

	& > img {
		border-radius: 8px;
		object-fit: cover;
	}
}
</style>
