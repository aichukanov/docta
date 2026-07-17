<script setup lang="ts">
import reviewsI18n from '~/i18n/reviews';
import { combineI18nMessages } from '~/i18n/utils';

const props = defineProps<{
	reviewId: number;
}>();

const emit = defineEmits<{
	uploaded: [];
}>();

const { t } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([reviewsI18n]),
});

// Клиентская валидация и превью — из общего composable,
// сам аплоад идёт на отдельный приватный endpoint верификации
const { error, preview, setPreview, revokePreview, validateOnClient } =
	useImageUpload();

const fileInput = ref<HTMLInputElement | null>(null);
const selectedFile = ref<File | null>(null);
const isUploading = ref(false);

const errorMessage = computed(() => {
	if (!error.value) return '';
	const messages: Record<string, string> = {
		INVALID_FILE_TYPE: t('VerificationInvalidType'),
		FILE_TOO_LARGE: t('VerificationFileTooLarge'),
		REVIEW_VERIFICATION_EXISTS: t('VerificationAlreadyExists'),
	};
	return messages[error.value] || t('VerificationUploadFailed');
});

const onFileChange = (event: Event) => {
	const file = (event.target as HTMLInputElement).files?.[0];
	if (!file) return;
	error.value = null;
	if (!validateOnClient(file)) {
		selectedFile.value = null;
		revokePreview();
		return;
	}
	selectedFile.value = file;
	setPreview(file);
};

const upload = async () => {
	if (!selectedFile.value) return;
	isUploading.value = true;
	error.value = null;
	try {
		const form = new FormData();
		form.append('file', selectedFile.value);
		form.append('reviewId', String(props.reviewId));
		await $fetch('/api/reviews/upload-verification', {
			method: 'POST',
			body: form,
		});
		emit('uploaded');
	} catch (e: any) {
		error.value = e?.data?.data?.code ?? 'UPLOAD_FAILED';
	} finally {
		isUploading.value = false;
	}
};
</script>

<template>
	<div class="verification-upload">
		<input
			ref="fileInput"
			type="file"
			accept="image/*"
			class="file-input"
			@change="onFileChange"
		/>

		<div v-if="preview" class="preview-wrap">
			<img :src="preview" :alt="t('VerificationTitle')" class="preview-img" />
		</div>

		<el-alert
			v-if="errorMessage"
			type="error"
			:title="errorMessage"
			:closable="false"
			show-icon
		/>

		<div class="upload-actions">
			<el-button @click="fileInput?.click()">
				{{ selectedFile ? t('VerificationChangeFile') : t('VerificationSelectFile') }}
			</el-button>
			<el-button
				v-if="selectedFile"
				type="primary"
				:loading="isUploading"
				@click="upload"
			>
				{{ t('VerificationUploadButton') }}
			</el-button>
		</div>
	</div>
</template>

<style scoped>
.verification-upload {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
}

.file-input {
	display: none;
}

.preview-wrap {
	border: var(--border-width-thin) solid var(--color-border-secondary);
	border-radius: var(--border-radius-md);
	overflow: hidden;
	max-width: 320px;
}

.preview-img {
	display: block;
	width: 100%;
	max-height: 240px;
	object-fit: contain;
	background: var(--color-bg-secondary);
}

.upload-actions {
	display: flex;
	gap: var(--spacing-sm);
}
</style>
