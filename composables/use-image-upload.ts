import type { ImageCategory } from '~/server/utils/image-processing';

const MAX_FILE_SIZE = 10 * 1024 * 1024;
const ACCEPTED_TYPES = [
	'image/jpeg',
	'image/png',
	'image/webp',
	'image/gif',
	'image/avif',
	'image/tiff',
];

export function useImageUpload() {
	const isUploading = ref(false);
	const error = ref<string | null>(null);
	const preview = ref<string | null>(null);

	function validateOnClient(file: File): boolean {
		error.value = null;

		if (!ACCEPTED_TYPES.includes(file.type)) {
			error.value = 'INVALID_FILE_TYPE';
			return false;
		}
		if (file.size > MAX_FILE_SIZE) {
			error.value = 'FILE_TOO_LARGE';
			return false;
		}
		return true;
	}

	function setPreview(file: File) {
		revokePreview();
		preview.value = URL.createObjectURL(file);
	}

	function revokePreview() {
		if (preview.value) {
			URL.revokeObjectURL(preview.value);
			preview.value = null;
		}
	}

	const isRemoving = ref(false);

	async function removePhoto(category: ImageCategory): Promise<boolean> {
		isRemoving.value = true;
		error.value = null;

		try {
			await $fetch('/api/upload/image', {
				method: 'DELETE',
				body: { category },
			});
			revokePreview();
			return true;
		} catch (e: any) {
			error.value = e?.data?.data?.code ?? 'UPLOAD_FAILED';
			return false;
		} finally {
			isRemoving.value = false;
		}
	}

	async function upload(
		file: File,
		category: ImageCategory,
	): Promise<string | null> {
		if (!validateOnClient(file)) return null;

		isUploading.value = true;
		error.value = null;

		try {
			const form = new FormData();
			form.append('file', file);
			form.append('category', category);

			const result = await $fetch<{ success: boolean; data?: { url: string } }>(
				'/api/upload/image',
				{ method: 'POST', body: form },
			);

			return result.data?.url ?? null;
		} catch (e: any) {
			error.value = e?.data?.data?.code ?? 'UPLOAD_FAILED';
			return null;
		} finally {
			isUploading.value = false;
		}
	}

	onUnmounted(() => {
		revokePreview();
	});

	return {
		isUploading,
		isRemoving,
		error,
		preview,
		upload,
		removePhoto,
		setPreview,
		revokePreview,
		validateOnClient,
	};
}
