<script setup lang="ts">
import { ERROR_CODES } from '~/server/utils/api-codes';

const emit = defineEmits<{ updated: []; cancel: [] }>();

const { t } = useI18n({
	useScope: 'local',
	messages: {
		en: {
			note: 'A confirmation email will be sent to the new address. Email will change only after confirmation.',
			newEmailLabel: 'New email',
			newEmailPlaceholder: 'Enter new email',
			cancel: 'Cancel',
			send: 'Send email',
			emailChangeSent: 'Confirmation email sent to new address',
		},
		ru: {
			note: 'На новый email будет отправлено письмо с подтверждением. Email изменится только после подтверждения.',
			newEmailLabel: 'Новый email',
			newEmailPlaceholder: 'Введите новый email',
			cancel: 'Отмена',
			send: 'Отправить письмо',
			emailChangeSent: 'Письмо с подтверждением отправлено на новый email',
		},
		sr: {
			note: 'Email sa potvrdom će biti poslat na novu adresu. Email će se promeniti samo nakon potvrde.',
			newEmailLabel: 'Novi email',
			newEmailPlaceholder: 'Unesite novi email',
			cancel: 'Otkaži',
			send: 'Pošalji email',
			emailChangeSent: 'Email sa potvrdom poslat na novu adresu',
		},
		de: {
			note: 'Eine Bestätigungs-E-Mail wird an die neue Adresse gesendet. Die E-Mail wird erst nach Bestätigung geändert.',
			newEmailLabel: 'Neue E-Mail',
			newEmailPlaceholder: 'Neue E-Mail eingeben',
			cancel: 'Abbrechen',
			send: 'E-Mail senden',
			emailChangeSent: 'Bestätigungs-E-Mail an neue Adresse gesendet',
		},
		tr: {
			note: 'Yeni adrese bir onay e-postası gönderilecektir. E-posta sadece onaydan sonra değişecektir.',
			newEmailLabel: 'Yeni e-posta',
			newEmailPlaceholder: 'Yeni e-posta girin',
			cancel: 'İptal',
			send: 'E-posta gönder',
			emailChangeSent: 'Yeni adrese onay e-postası gönderildi',
		},
		'sr-cyrl': {
			note: 'Емаил са потврдом ће бити послат на нову адресу. Емаил ће се променити само након потврде.',
			newEmailLabel: 'Нови емаил',
			newEmailPlaceholder: 'Унесите нови емаил',
			cancel: 'Откажи',
			send: 'Пошаљи емаил',
			emailChangeSent: 'Емаил са потврдом послат на нову адресу',
		},
	},
});

const isLoading = ref(false);
const error = ref<ERROR_CODES | null>(null);
const newEmail = ref('');

async function handleSubmit() {
	error.value = null;
	if (!newEmail.value.trim()) {
		error.value = ERROR_CODES.EMAIL_REQUIRED;
		return;
	}
	try {
		isLoading.value = true;
		const response = await $fetch('/api/auth/request-email-change', {
			method: 'POST',
			body: { newEmail: newEmail.value },
		});
		ElMessage.success(t('emailChangeSent'));
		if (response.confirmUrl) {
			console.log('Confirmation URL:', response.confirmUrl);
		}
		emit('updated');
	} catch (err: any) {
		error.value =
			(err.data?.statusMessage as ERROR_CODES) ||
			ERROR_CODES.ERROR_REQUESTING_EMAIL_CHANGE;
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
	<p class="edit-email-dialog__note">{{ t('note') }}</p>
	<el-form @submit.prevent="handleSubmit" label-position="top">
		<el-form-item :label="t('newEmailLabel')">
			<el-input
				v-model="newEmail"
				type="email"
				:placeholder="t('newEmailPlaceholder')"
				:disabled="isLoading"
			/>
		</el-form-item>
	</el-form>
	<div class="edit-email-dialog__footer">
		<el-button :disabled="isLoading" @click="emit('cancel')">
			{{ t('cancel') }}
		</el-button>
		<el-button type="primary" :loading="isLoading" @click="handleSubmit">
			{{ t('send') }}
		</el-button>
	</div>
</template>

<style scoped>
.edit-email-dialog__note {
	font-size: var(--font-size-sm);
	color: var(--color-text-muted);
	margin: 0 0 var(--spacing-lg);
	line-height: 1.5;
}

.edit-email-dialog__footer {
	display: flex;
	justify-content: flex-end;
	gap: var(--spacing-sm);
	margin-top: var(--spacing-lg);
}
</style>
