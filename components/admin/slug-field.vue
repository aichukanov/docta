<script setup lang="ts">
import { RefreshLeft } from '@element-plus/icons-vue';
import { generateSlug } from '~/common/slug-utils';

const props = withDefaults(
	defineProps<{
		/** Current slug value */
		value?: string;
		/** Source name to auto-generate slug from */
		nameSource?: string;
		/** Whether to show modified indicator */
		modified?: boolean;
	}>(),
	{
		value: '',
		nameSource: '',
		modified: false,
	},
);

const emit = defineEmits<{
	(e: 'update:value', value: string): void;
	(e: 'reset'): void;
}>();

const manuallyEdited = ref(false);

const editableValue = computed({
	get: () => props.value,
	set: (value: string) => {
		manuallyEdited.value = true;
		emit('update:value', value);
	},
});

// Auto-generate slug from name when name changes (unless manually edited)
watch(
	() => props.nameSource,
	(newName) => {
		if (!manuallyEdited.value && newName) {
			emit('update:value', generateSlug(newName));
		}
	},
);

function regenerate() {
	manuallyEdited.value = false;
	emit('update:value', generateSlug(props.nameSource || ''));
}
</script>

<template>
	<div class="field" :class="{ modified }">
		<label>Slug (URL)</label>
		<el-input v-model="editableValue">
			<template #append>
				<el-button title="Сгенерировать из названия" @click="regenerate">
					↻ Auto
				</el-button>
				<el-button
					v-if="modified"
					:icon="RefreshLeft"
					@click="$emit('reset')"
				/>
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
</style>
