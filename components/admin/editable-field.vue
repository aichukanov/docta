<script setup lang="ts">
import { RefreshLeft } from '@element-plus/icons-vue';
import { toCyrillic } from '~/common/serbian-transliteration';

const props = withDefaults(
	defineProps<{
		label: string;
		value?: string | null;
		modified?: boolean;
		type?: 'text' | 'photo' | 'textarea';
		readonly?: boolean;
		/** Текст на латинице для перевода в кириллицу */
		translateFrom?: string | null;
	}>(),
	{
		value: '',
		type: 'text',
		modified: false,
		readonly: false,
		translateFrom: null,
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

const translateToCyrillic = () => {
	if (props.translateFrom) {
		emit('update:value', toCyrillic(props.translateFrom));
	}
};

const showTranslateButton = computed(
	() => props.translateFrom !== null && props.translateFrom !== undefined,
);
</script>

<template>
	<div class="field" :class="{ modified: props.modified }">
		<label>{{ props.label }}</label>

		<div v-if="props.type === 'photo'" class="photo-container">
			<img :src="editableValue" width="100" height="100" />
			<el-input
				v-model="editableValue"
				type="textarea"
				:rows="3"
				:readonly="readonly"
			/>
		</div>
		<div v-else-if="props.type === 'textarea'" class="textarea-container">
			<el-input
				v-model="editableValue"
				type="textarea"
				:autosize="{ minRows: 2, maxRows: 10 }"
				:readonly="readonly"
			/>
			<div class="action-buttons">
				<el-button
					v-if="showTranslateButton"
					@click="translateToCyrillic"
					title="Перевести с латиницы на кириллицу"
					class="translate-button"
				>
					Č → Ч
				</el-button>
				<el-button
					v-if="props.modified"
					:icon="RefreshLeft"
					@click="$emit('reset')"
				/>
			</div>
		</div>
		<el-input v-else v-model="editableValue" :readonly="readonly">
			<template #append v-if="showTranslateButton || props.modified">
				<el-button
					v-if="showTranslateButton"
					@click="translateToCyrillic"
					title="Перевести с латиницы на кириллицу"
					class="translate-button"
				>
					Č → Ч
				</el-button>
				<el-button
					v-if="props.modified"
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

.textarea-container {
	display: flex;
	gap: var(--spacing-xs);
	align-items: flex-start;

	.action-buttons {
		display: flex;
		flex-direction: column;
		gap: var(--spacing-xs);
		margin-top: 4px;
	}
}

.translate-button {
	font-weight: 600;
}
</style>
