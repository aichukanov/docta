<script setup lang="ts">
import doctorProfileI18n from '~/i18n/doctor-profile';
import type { DoctorMyProfile } from '~/server/api/doctors/my-profile';

const props = defineProps<{
	doctor: DoctorMyProfile;
}>();

const emit = defineEmits<{
	(e: 'saved'): void;
	(e: 'cancel'): void;
}>();

const { t } = useI18n({
	useScope: 'local',
	messages: doctorProfileI18n.messages,
});

const clinicsStore = useClinicsStore();
clinicsStore.fetchClinics();

const form = reactive({
	nameSr: props.doctor.nameSr,
	nameSrCyrl: props.doctor.nameSrCyrl,
	nameRu: props.doctor.nameRu,
	nameEn: props.doctor.nameEn,
	professionalTitle: props.doctor.professionalTitle,
	descriptionSr: props.doctor.descriptionSr,
	descriptionSrCyrl: props.doctor.descriptionSrCyrl,
	descriptionRu: props.doctor.descriptionRu,
	descriptionEn: props.doctor.descriptionEn,
	descriptionDe: props.doctor.descriptionDe,
	descriptionTr: props.doctor.descriptionTr,
	specialtyIds: props.doctor.specialtyIds
		? props.doctor.specialtyIds.split(',').map(Number)
		: [],
	languageIds: props.doctor.languageIds
		? props.doctor.languageIds.split(',').map(Number)
		: [],
	clinicIds: props.doctor.clinicIds
		? props.doctor.clinicIds.split(',').map(Number)
		: [],
});

const nameLanguages = [
	{ key: 'nameSr', code: 'SR' },
	{ key: 'nameSrCyrl', code: 'SR-CYRL' },
	{ key: 'nameRu', code: 'RU' },
	{ key: 'nameEn', code: 'EN' },
];

const descriptionLanguages = [
	{ key: 'descriptionSr', code: 'SR' },
	{ key: 'descriptionSrCyrl', code: 'SR-CYRL' },
	{ key: 'descriptionRu', code: 'RU' },
	{ key: 'descriptionEn', code: 'EN' },
	{ key: 'descriptionDe', code: 'DE' },
	{ key: 'descriptionTr', code: 'TR' },
];

function makeLocalizedComputed(keys: string[]) {
	return computed({
		get: () => {
			const result: Record<string, string> = {};
			for (const key of keys) {
				result[key] = (form as any)[key];
			}
			return result;
		},
		set: (val: Record<string, string>) => {
			Object.assign(form, val);
		},
	});
}

const names = makeLocalizedComputed(nameLanguages.map((l) => l.key));
const descriptions = makeLocalizedComputed(
	descriptionLanguages.map((l) => l.key),
);

const photoInput = ref<HTMLInputElement | null>(null);
const { isUploading, isRemoving, preview, upload, removePhoto, setPreview } =
	useImageUpload();
const photoRemoved = ref(false);

const photoDisplayUrl = computed(() => {
	if (photoRemoved.value) return null;
	return preview.value || props.doctor.photoUrl || null;
});

const canRemovePhoto = computed(
	() =>
		!photoRemoved.value &&
		(preview.value || props.doctor.photoUrl?.startsWith('/uploads/')),
);

async function removeDoctorPhoto() {
	const ok = await removePhoto('doctors');
	if (ok) {
		photoRemoved.value = true;
	}
}

function triggerPhotoUpload() {
	photoInput.value?.click();
}

async function onPhotoFileChange(e: Event) {
	const file = (e.target as HTMLInputElement).files?.[0];
	if (!file) return;

	setPreview(file);
	const url = await upload(file, 'doctors');

	if (url) {
		ElMessage.success(t('photoUpdated'));
	}

	if (photoInput.value) {
		photoInput.value.value = '';
	}
}

const isSaving = ref(false);

function validate(): string | null {
	if (!form.nameSr.trim()) return t('nameRequired');
	if (!form.specialtyIds.length) return t('specialtiesRequired');
	if (!form.languageIds.length) return t('languagesRequired');
	return null;
}

async function save() {
	const error = validate();
	if (error) {
		ElMessage.warning(error);
		return;
	}

	isSaving.value = true;
	try {
		await $fetch('/api/doctors/update-my-profile', {
			method: 'POST',
			body: {
				nameSr: form.nameSr,
				nameSrCyrl: form.nameSrCyrl,
				nameRu: form.nameRu,
				nameEn: form.nameEn,
				professionalTitle: form.professionalTitle,
				descriptionSr: form.descriptionSr,
				descriptionSrCyrl: form.descriptionSrCyrl,
				descriptionRu: form.descriptionRu,
				descriptionEn: form.descriptionEn,
				descriptionDe: form.descriptionDe,
				descriptionTr: form.descriptionTr,
				specialtyIds: form.specialtyIds,
				languageIds: form.languageIds,
				clinicIds: form.clinicIds,
			},
		});

		ElMessage.success(t('profileSaved'));
		emit('saved');
	} catch {
		ElMessage.error(t('errorSaving'));
	} finally {
		isSaving.value = false;
	}
}
</script>

<template>
	<section class="edit-form">
		<div class="edit-form__header">
			<IconEdit :size="20" />
			<h2 class="edit-form__title">{{ t('editProfile') }}</h2>
		</div>

		<div class="edit-form__photo-section">
			<div class="edit-form__avatar-wrap">
				<DoctorAvatar
					:name="doctor.name"
					:photo-url="photoDisplayUrl"
					:size="80"
				/>
				<button
					class="edit-form__avatar-upload"
					:title="t('changePhoto')"
					:disabled="isUploading"
					@click="triggerPhotoUpload"
				>
					<IconCamera v-if="!isUploading" :size="14" />
					<span v-else class="edit-form__avatar-spinner" />
				</button>
				<button
					v-if="canRemovePhoto"
					class="edit-form__avatar-remove"
					:title="t('removePhoto')"
					:disabled="isRemoving"
					@click="removeDoctorPhoto"
				>
					<IconClose :size="10" />
				</button>
				<input
					ref="photoInput"
					type="file"
					accept="image/jpeg,image/png,image/webp,image/gif"
					hidden
					@change="onPhotoFileChange"
				/>
			</div>
			<div class="edit-form__photo-hint">{{ t('changePhoto') }}</div>
		</div>

		<div class="edit-form__fields">
			<div class="edit-form__field">
				<label class="edit-form__label">{{ t('fieldName') }} *</label>
				<LocalizedFieldEditor :languages="nameLanguages" v-model="names" />
			</div>

			<div class="edit-form__field">
				<label class="edit-form__label">{{
					t('fieldProfessionalTitle')
				}}</label>
				<el-input v-model="form.professionalTitle" />
			</div>

			<FilterSpecialtySelect v-model:value="form.specialtyIds" />
			<FilterLanguageSelect v-model:value="form.languageIds" />
			<FilterClinicSelect v-model:value="form.clinicIds" />
		</div>

		<div class="edit-form__description-section">
			<div class="edit-form__section-header">
				<h3 class="edit-form__section-title">{{ t('descriptionSection') }}</h3>
				<span class="edit-form__markdown-hint">{{
					t('descriptionMarkdownHint')
				}}</span>
			</div>

			<LocalizedFieldEditor
				:languages="descriptionLanguages"
				v-model="descriptions"
				type="markdown"
			/>
		</div>

		<div class="edit-form__actions">
			<el-button @click="emit('cancel')">{{ t('cancel') }}</el-button>
			<el-button type="primary" :loading="isSaving" @click="save">
				{{ t('saveChanges') }}
			</el-button>
		</div>
	</section>
</template>

<style scoped>
.edit-form {
	background: var(--color-bg-primary);
	border-radius: var(--border-radius-xl);
	padding: var(--spacing-2xl);
	box-shadow: var(--shadow-sm);
	border: 1px solid var(--color-border-secondary);
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xl);
}

.edit-form__header {
	display: flex;
	align-items: center;
	gap: var(--spacing-md);
	color: var(--color-primary);
}

.edit-form__title {
	font-size: var(--font-size-2xl);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-heading);
	margin: 0;
}

.edit-form__photo-section {
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: var(--spacing-sm);
}

.edit-form__avatar-wrap {
	position: relative;
}

.edit-form__avatar-upload {
	position: absolute;
	bottom: -2px;
	right: -2px;
	width: 28px;
	height: 28px;
	border-radius: 50%;
	border: 2px solid var(--color-bg-primary);
	background: var(--color-primary);
	color: #fff;
	display: flex;
	align-items: center;
	justify-content: center;
	cursor: pointer;
	transition: all var(--transition-base);
	padding: 0;
}

.edit-form__avatar-upload:hover {
	background: var(--color-primary-dark, #3730a3);
	transform: scale(1.1);
}

.edit-form__avatar-upload:disabled {
	cursor: not-allowed;
	opacity: 0.7;
}

.edit-form__avatar-spinner {
	width: 14px;
	height: 14px;
	border: 2px solid rgba(255, 255, 255, 0.3);
	border-top-color: #fff;
	border-radius: 50%;
	animation: edit-avatar-spin 0.6s linear infinite;
}

.edit-form__avatar-remove {
	position: absolute;
	top: -4px;
	right: -4px;
	width: 20px;
	height: 20px;
	border-radius: 50%;
	border: 2px solid var(--color-bg-primary);
	background: var(--color-danger, #ef4444);
	color: #fff;
	display: flex;
	align-items: center;
	justify-content: center;
	cursor: pointer;
	transition: all var(--transition-base);
	padding: 0;
}

.edit-form__avatar-remove:hover {
	background: var(--color-danger-dark, #dc2626);
	transform: scale(1.1);
}

.edit-form__avatar-remove:disabled {
	cursor: not-allowed;
	opacity: 0.7;
}

@keyframes edit-avatar-spin {
	to {
		transform: rotate(360deg);
	}
}

.edit-form__photo-hint {
	font-size: var(--font-size-xs);
	color: var(--color-text-muted);
}

.edit-form__fields {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
}

.edit-form__field {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xs);
}

.edit-form__label {
	font-size: var(--font-size-sm);
	font-weight: var(--font-weight-medium);
	color: var(--color-text-secondary);
}

.edit-form__description-section {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
	padding-top: var(--spacing-lg);
	border-top: 1px solid var(--color-border-secondary);
}

.edit-form__section-header {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xs);
}

.edit-form__section-title {
	font-size: var(--font-size-lg);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-heading);
	margin: 0;
}

.edit-form__markdown-hint {
	font-size: var(--font-size-xs);
	color: var(--color-text-tertiary);
}

.edit-form__actions {
	display: flex;
	justify-content: flex-end;
	gap: var(--spacing-sm);
}

@media (max-width: 640px) {
	.edit-form {
		padding: var(--spacing-xl) var(--spacing-lg);
	}
}
</style>
