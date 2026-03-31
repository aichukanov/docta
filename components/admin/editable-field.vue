<script setup lang="ts">
import { RefreshLeft, Upload } from '@element-plus/icons-vue';
import { toCyrillic } from '~/common/serbian-transliteration';

const props = withDefaults(
	defineProps<{
		label: string;
		value?: string | null;
		modified?: boolean;
		type?: 'text' | 'photo' | 'textarea';
		readonly?: boolean;
		/** Категория изображения для загрузки файлов (doctors, clinics, avatars) */
		imageCategory?: string;
		/** Текст на латинице для перевода в кириллицу */
		translateFrom?: string | null;
	}>(),
	{
		value: '',
		type: 'text',
		modified: false,
		readonly: false,
		imageCategory: 'doctors',
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

const isUploading = ref(false);
const fileInputRef = ref<HTMLInputElement | null>(null);

const triggerFileSelect = () => {
	fileInputRef.value?.click();
};

const handleFileUpload = async (event: Event) => {
	const input = event.target as HTMLInputElement;
	const file = input.files?.[0];
	if (!file) return;

	isUploading.value = true;
	try {
		const formData = new FormData();
		formData.append('file', file);
		formData.append('category', props.imageCategory);

		const result = await $fetch<{ url: string }>('/api/upload/admin-image', {
			method: 'POST',
			body: formData,
		});

		emit('update:value', result.url);
	} catch (error) {
		console.error('Upload failed:', error);
		alert('Ошибка загрузки файла');
	} finally {
		isUploading.value = false;
		input.value = '';
	}
};

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
			<img v-if="editableValue" :src="editableValue" width="100" height="100" />
			<div class="photo-inputs">
				<el-input
					v-model="editableValue"
					type="textarea"
					:rows="3"
					:readonly="readonly"
					placeholder="Вставьте URL или загрузите файл"
				/>
				<div v-if="!readonly" class="photo-actions">
					<el-button
						:icon="Upload"
						:loading="isUploading"
						@click="triggerFileSelect"
					>
						Загрузить файл
					</el-button>
					<el-button
						v-if="props.modified"
						:icon="RefreshLeft"
						@click="$emit('reset')"
					/>
				</div>
				<input
					ref="fileInputRef"
					type="file"
					accept="image/*"
					class="hidden-file-input"
					@change="handleFileUpload"
				/>
			</div>
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
		flex-shrink: 0;
	}
}

.photo-inputs {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xs);
	flex: 1;
}

.photo-actions {
	display: flex;
	gap: var(--spacing-xs);
}

.hidden-file-input {
	display: none;
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
