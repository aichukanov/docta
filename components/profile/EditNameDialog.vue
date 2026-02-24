<script setup lang="ts">
import { ERROR_CODES } from '~/server/utils/api-codes';

const props = defineProps<{ initialName: string }>();
const emit = defineEmits<{ updated: []; cancel: [] }>();

const { t } = useI18n({
	useScope: 'local',
	messages: {
		'en': {
			nameLabel: 'Name',
			namePlaceholder: 'Enter new name',
			cancel: 'Cancel',
			save: 'Save',
			nameUpdated: 'Name updated successfully',
		},
		'ru': {
			nameLabel: 'Имя',
			namePlaceholder: 'Введите новое имя',
			cancel: 'Отмена',
			save: 'Сохранить',
			nameUpdated: 'Имя успешно обновлено',
		},
		'sr': {
			nameLabel: 'Ime',
			namePlaceholder: 'Unesite novo ime',
			cancel: 'Otkaži',
			save: 'Sačuvaj',
			nameUpdated: 'Ime uspešno ažurirano',
		},
		'de': {
			nameLabel: 'Name',
			namePlaceholder: 'Neuen Namen eingeben',
			cancel: 'Abbrechen',
			save: 'Speichern',
			nameUpdated: 'Name erfolgreich aktualisiert',
		},
		'tr': {
			nameLabel: 'İsim',
			namePlaceholder: 'Yeni isim girin',
			cancel: 'İptal',
			save: 'Kaydet',
			nameUpdated: 'İsim başarıyla güncellendi',
		},
		'sr-cyrl': {
			nameLabel: 'Ime',
			namePlaceholder: 'Унесите ново ime',
			cancel: 'Откажи',
			save: 'Сачувај',
			nameUpdated: 'Ime успешно ажурирано',
		},
	},
});

const { fetchUser } = useUserStore();

const isLoading = ref(false);
const error = ref<ERROR_CODES | null>(null);
const name = ref(props.initialName);

async function handleSubmit() {
	error.value = null;
	if (!name.value.trim()) {
		error.value = ERROR_CODES.NAME_EMPTY;
		return;
	}
	try {
		isLoading.value = true;
		await $fetch('/api/auth/update-name', {
			method: 'POST',
			body: { name: name.value },
		});
		ElMessage.success(t('nameUpdated'));
		await fetchUser(true);
		emit('updated');
	} catch (err: any) {
		error.value =
			(err.data?.statusMessage as ERROR_CODES) ||
			ERROR_CODES.ERROR_UPDATING_NAME;
	} finally {
		isLoading.value = false;
	}
}
</script>

<template>
	<ApiErrorAlert
		:error="error"
		closable
		style="margin-bottom: 20px"
		@close="error = null"
	/>
	<el-form @submit.prevent="handleSubmit" label-position="top">
		<el-form-item :label="t('nameLabel')">
			<el-input
				v-model="name"
				:placeholder="t('namePlaceholder')"
				:disabled="isLoading"
			/>
		</el-form-item>
	</el-form>
	<div class="edit-name-dialog__footer">
		<el-button :disabled="isLoading" @click="emit('cancel')">
			{{ t('cancel') }}
		</el-button>
		<el-button type="primary" :loading="isLoading" @click="handleSubmit">
			{{ t('save') }}
		</el-button>
	</div>
</template>

<style scoped>
.edit-name-dialog__footer {
	display: flex;
	justify-content: flex-end;
	gap: var(--spacing-sm);
	margin-top: var(--spacing-lg);
}
</style>
